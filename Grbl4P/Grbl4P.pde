/*
  Copyright (c) 2019 2021 Thomas P Moyer

  Grbl4P is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Grbl4P is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Grbl4P.  If not, see <http://www.gnu.org/licenses/>.
*/

//String knownGoodGrblComPort="";/* If this variable is left as zero length, Grbl4P will iterate through the com ports */
String knownGoodGrblComPort="/dev/ttyACM0"; /* This quickens initialization on TPMoyer's RasperryPi CNC working hardware */
//String knownGoodGrblComPort="COM5";        /* This quickens initialization on TPMoyer's development workstation */

import processing.serial.*;
import g4p_controls.*;
import java.time.Duration;
import java.time.Instant;
import java.awt.Font;
import java.text.NumberFormat;
import java.text.DecimalFormat;
import java.util.Locale;
import java.util.Map;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;
import java.text.SimpleDateFormat;

boolean seeGrbl          = false;
String  frameTitle       = "GRBL Gui";
Serial  port             = null;
String  portName         = null;
String  portMsg          = "";
char    portCode         = 0;
boolean laserPresent     = false;
boolean spindlePresent   = false;
String  activeState      = ""; /* activeState can be:   Idle, Run, Hold, Door, Home, Alarm, Check */
boolean seeHashtagParams = false;
boolean seeGrblParams    = false;
boolean checkGCodeMode   = false;
boolean lastProbeGood    = false;
boolean verboseOutput    = false;
boolean priorStatusHadPn = false;
boolean individualHomesEnabled=false;
int     spindleSpeed     = 0;
String  lastMessage      = "";
float   maxFeedRate      = 300;
float   feedRate         = 0.;
float   minMaxFeedRate   = 1000000.;
boolean heartBeat        = true;
int     frameModulo      = 0;
int     frameRateLimit   = 10;
int     idleCount        =0; /* limit the number of unchanging reports which get logged */
int     alarmCount       =0; /* limit the number of unchanging reports which get logged */
float [] mPos = new float[3];
float [] wco  = new float[3];
float [] ov   = new float[3];
float [][] gParams = new float[11][3];
float [] jogStepSizes = {1.,1.,1.,1.,1.,1.};
float [] homes2WorkAllPositive = new float[3];
String[] grblSettings = null; /* save these as strings to avoid the    "some are ints, some are floats"    difficulties in printing */
String[] paramNames = {"G54","G55","G56","G57","G58","G59","G28","G30","G92","TLO","PRB"};
Instant appStart = Instant.now();
Map<String,String>mGrblSettings = new HashMap<String,String>();
int numRows=0;
int rowCounter=0;
double  timeOut=10.0;

/* streaming variables. Triggered within the gui, updated within the SerialEvent handlers */
String fid="";
boolean   streaming                 = false;
int       numOKs                    = 0;
int       numErrors                 = 0;
boolean   bufferedReaderSet         = false;
int       numRowsConfirmedProcessed = 0;
final int bufferSize                = 128; /* size of the grbl input buffer */
int       grblBufferUsed            = 0;   /* number of bytes currently used */
int       numLinesSent              = 0;
int       redBufferUsed             = 0;
BufferedReader     br               = null;
ArrayList<Integer> sentLineLengths  = new ArrayList<Integer>();
ArrayList<String>  redBuffer        = new ArrayList<String>(); /* past tense of read (reed) is spelled the same way as the present tense, so use Red as homophone of choise */

/* Thank you Jake Seigel for the processing log4j connectivity!    
 * I'm a logggerDebugger and this was key to being able to 
 * dig myself out of several/many  holes/traps/mistakes/typos:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/    */
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master"); 
//Logger log1 = Logger.getLogger("Ancillary0");
//Logger log2 = Logger.getLogger("Ancillary1");
//Logger log3 = Logger.getLogger("Ancillary2");

/**********************************************************************************************************/
void setup(){
  size(900, 850  );
  background(212,208,200);
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  surface.setLocation(windows?1300:1020,windows?0:50);
  initLog4j();
  initGUI();
  initGrblSettings();
  
  knownGoodGrblComPort="COM6";  /* for TPMoyer's windows diagnostic runs */
  openSerialPort(true);  
  frameRate(frameRateLimit);
  timeNSay("at end of setup");
}
/**********************************************************************************************************/
void draw(){
  background(212,208,200);
  surface.setTitle(frameTitle+"    "+round(frameRate) + " fps "+(heartBeat?"+":"-"));
  if(0==frameModulo){
    port.write("?");
    //logNCon("cnc1 wrote ?");    
  }
  
  if(frameRateLimit==frameCount%(frameRateLimit+1))heartBeat=!heartBeat;
  
  if(  streaming ){
    frameModulo=(frameModulo+1)%frameRateLimit;  /* limit the status request to 1hz while streaming */
  } else {  
    frameModulo=(5>=(round(frameRate)/5)?0:((frameModulo+1)%(round(frameRate)/5))); /* limit the status request to about 5hz */
  }   

  if(  ( ! seeGrbl)
   &&(timeOut < Duration.between(appStart,Instant.now()).toMillis()/1000)
  ){
    logNCon(String.format("unable to get a response on any port after %7.3f seconds\n                      exiting",timeOut));
    System.exit(1);
  }
}
