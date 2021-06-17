/*
  Copyright (c) 2021 Thomas P Moyer

  GPS4P is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  GPS4P is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with GPS4P.  If not, see <http://www.gnu.org/licenses/>.
    
  https://en.wikipedia.org/wiki/NMEA_0183
  https://www.gpsworld.com/what-exactly-is-gps-nmea-data/#:~:text=Today%20in%20the%20world%20of,and%20match%20hardware%20and%20software.
  
  https://github.com/dimhoff/mt333x-fw-utils purports to be a firmware reader/writer repo
*/

//String knownGoodGrblComPort="";/* If this variable is left as zero length, GPS4P will iterate through the com ports */
//String knownGoodGrblComPort="/dev/ttyUSB0"; /* This quickens initialization on TPMoyer's RasperryPi CNC working hardware */
//String knownGoodGrblComPort="/dev/ttyAMA0"; /* This quickens initialization on TPMoyer's RasperryPi CNC working hardware */
//String knownGoodGrblComPort="/dev/ttyS0"; /* This quickens initialization on TPMoyer's RasperryPi CNC working hardware */
String knownGoodGrblComPort="COM6";        /* This quickens initialization on TPMoyer's development workstation */

import processing.serial.*;
import g4p_controls.*;
import java.time.Duration;
import java.time.Instant;
import java.awt.Font;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Map;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;
import java.text.SimpleDateFormat;

boolean seeGPS          = false;
String  frameTitle       = "GPS Gui";
Serial  port             = null;
//String  portName         = null;
String  portMsg          = "";
char    portCode         = 0;
boolean fixSeen          =false;
Instant appStart = Instant.now();
Instant priorInstant = Instant.now();
String utc="";
double latitude=0.0;
double longitude=0.0;
double altitude=0.0;
String positionFixIndicator="";
int    numSatellites=0;        /* this is vital, 1 of 30 fixes with 3 satellite had an altitude 300 meters off */
double pdop=0.0;               /* believe not first order useful */ 
double hdop=0.0;               /* believe not first order useful */
double vdop=0.0;               /* believe not first order useful */
double geoidalSeparation=0.0;  /* believe not first order useful */
int    ageOfDiffCorr0=0;       /* believe not first order useful */
int    ageOfDiffCorr1=0;       /* believe not first order useful */
boolean    ggaSeenPriorToGsv  = false;
boolean    gsaSeenPriorToGsv  = false;
boolean[]  activeSatelliteIDs = new boolean[100]; /* use the provided Id numbers, ie 0 is not used */
String[]   elevations         = new String [100];
String[]   azimuths           = new String [100];
String[]   signalToNoises     = new String [100];
int    milliSecondsBetweenReadings=10000;  /* 100 gives 10Hz, 1000 gives 1Hz, 10000 gives 0.1Hz       Acceptable range is 100 to 10000 */
boolean gpsInitialized=false;
boolean initGPSstarted=false;
boolean gotFix=false;
boolean mtk3339Acknolwledged=false;
double  timeOut=20.;

/* Calculations to convert latitude, longitude, altitude to cartesian XYZ triplets per
per https://en.wikipedia.org/wiki/Reference_ellipsoid#:~:text=The%20ellipsoid%20WGS%2D84%2C%20widely,more%20precisely%2C%2021.3846858%20km).
have the following invariant inputs.  
Do them once here instead of every iteration of the conversion. 
*/
final double wsg84A = 6378137.;
final double wsg84F = 1/298.257223563;
final double wsg84B = wsg84A * (1.0 - wsg84F);
final double wsg84ASquared = wsg84A*wsg84A;
final double wsg84BSquared = wsg84B*wsg84B;
final double wsg84BSquaredOverASquared=wsg84BSquared/wsg84ASquared;
double[] xyz0 = new double[3]; /* used in the conversion of lat, lon, alt into XYZ */ 
double[] xyz1 = new double[3]; /* used in the conversion of lat, lon, alt into XYZ, the R is for radius */
final double oneOneHundredthArcSecond=0.01/3600.0;

boolean seeGPSParams     = false;
boolean heartBeat        = true;
int     frameModulo      = 0;
int     frameRateLimit   = 1;

/* Thank you Jake Seigel for the processing log4j connectivity!    
 * I'm a logggerDebugger and this was key to being able to 
 * dig myself out of several/many  holes/traps/mistakes/typos:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/    */
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master"); 
Logger log1 = Logger.getLogger("Ancillary0");
Logger log2 = Logger.getLogger("Ancillary1");
Logger log3 = Logger.getLogger("Ancillary2");
Logger log4 = Logger.getLogger("Ancillary3");
/*********************************************************************************************/
void setup(){
  /* ySize = (int)400/1.61803398875 application of golden ratio */
  size(400, 247);
  background(212,208,200);  
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  surface.setLocation(windows?1300:200,windows?0:50);
  initLog4j();
  //checkWSG84CalculationNumbers();  /* Check wsg84 constants and do some unit tests */ 
  initGUI();
  frameRate(frameRateLimit);
  textSize(32);
  fill(0);
  text("Ultimate GPS Initializing",10,60);  
    
  /* write the top row of the .csv files */
  log1.debug("Longitude,Latitude,Altitude,Number of Satellites,UTC,fix,Age of Dif0,Age of Dif1");
  log2.debug("direction (true degrees),speed (km/hr)");
  log3.debug("UTC,HDOP,VDOP,PDOP");
  StringBuilder sb = new StringBuilder();
  for(int ii=1;ii<100;ii++){
    String satID=String.format("Sat%02d",ii);
    sb.append(
      String.format(
        "%s%s active,%s elevation,%s azimuth,%s sigToNoise",
        (1==ii?"UTC,":","),
        satID,
        satID,
        satID,
        satID
      )
    );
  }
  log4.debug(sb);
  
  //timeNSay("at end of setup");
}
/*********************************************************************************************/
void draw(){
  background(212,208,200);
  surface.setTitle(frameTitle+"    "+round(frameRate) + " fps "+(heartBeat?"+":"-"));
  if(!initGPSstarted)openSerialPort(true);
  if(  ( ! mtk3339Acknolwledged)
     &&(timeOut< Duration.between(appStart,Instant.now()).toMillis()/1000)
    ){
      logNCon(String.format("unable to get a response on any port after %7.3f seconds\n                      exiting",timeOut));
      System.exit(1);
   } 
}
/*********************************************************************************************/
