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
import java.math.*;

/* Thank you Jake Seigel for the processing log4j connectivity!    
 * I'm a logggerDebugger and this was key to being able to 
 * dig myself out of several/many  holes/traps/mistakes/typos:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/    */
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master"); 
Logger log0 = Logger.getLogger("Ancillary0");
Logger log1 = Logger.getLogger("Ancillary1");
//Logger log2 = Logger.getLogger("Ancillary2");


String  frameTitle       = "GRBL Gui";
int frameRateLimit=10;
char[] crlf = new char[2];
char lf=10;
String crCharString="/n";
String lfCharString="/r";
char   jogCancel=0x85;
int    epromDelay=100;
String  portMsg          = "";
char    portCode         = 0;
boolean laserPresent     = false;
boolean spindlePresent   = false;
String  activeState      = ""; /* activeState can be:   Idle, Run, Hold, Door, Home, Alarm, Check */
String  priorActiveDrawnState  = "";
boolean seeHashtagParams = false;
boolean seeGrblParams    = false;
boolean checkGCodeMode   = false;
boolean lastProbeGood    = false;
boolean verboseOutput    = false;
boolean verboseLogging   = false;
boolean individualHomesEnabled=false;
int     spindleSpeed     = 0;
//String  lastMessage      = "";
//float   maxFeedRate      = 300;
float   feedRate         = 0.;
//float   minMaxFeedRate   = 1000000.;
boolean heartBeat        = true;
int     framesPerHeartBeat = 30;
int     heartBeatFrameCount=0;
int     idleCount        =0; /* limit the number of unchanging reports which get logged */
int     alarmCount       =0; /* limit the number of unchanging reports which get logged */
float []           mPos = new float[3]; /* machine position */
float []           wco  = new float[3]; /* work co-ordinates */
//float []           wcoOffsetPostHome  = new float[3]; /* work co-ordinates */
float []           ov   = new float[3]; /* nfi (no bleeding idea) */
float [] maxFeedRates   = new float[3];
float [][] gParams = new float[11][3];
int activeWCO=0; /* 0->G54  1->G55  2->G56  3>-G57  4->G58  5>-G59  */
boolean sayIdle=true;
boolean priorStatusHadPn=false;
//boolean priorXLimitState=false;
//boolean priorYLimitState=false;
//boolean priorZLimitState=false;
//boolean priorProbeState =false;
//boolean priorDoorState  =false;
boolean doNotAllowIdleToGoStale=false;  /* normal operation */
//boolean doNotAllowIdleToGoStale=true;  /* full amount of debug dump on every status */

/* I had a problem with the asyncronous serial communication to the arduino accessing the fields under the GUI causing an infrequent intermittent null-pointer */
/* My prescriptive solution is to have the serial interface access only global variables, which are then in turn accessed by the GUI only from within the draw */
/* I have only two states for my label fields, normal and WTF, so use a boolean instead of an int */
String [] labelPreTexts       = new String [40]; 
String [] labelPriorTexts     = new String [40];
boolean[] labelPreState       = new boolean[40];  /* default state == false */
boolean[] labelPriorState     = new boolean[40];
String [] textFieldPreTexts   = new String [20];
String [] textFieldPriorTexts = new String [20];
//String [] buttonPreTexts      = new String [40];
//String [] buttonPriorTexts    = new String [40];
int numLabels=30;

float [] jogStepSizes = {1.,1.,1.,1.,1.,1.};
float [] homes2WorkAllPositive = new float[3];
String[] grblSettings = null; /* save these as strings to avoid the    "some are ints, some are floats"    difficulties in printing */
String[] paramNames = {"G54","G55","G56","G57","G58","G59","G28","G30","G92","TLO","PRB"};
Map<String,String>mGrblSettings = new HashMap<String,String>();
int numRows=0;
int rowCounter=0;
double  timeOut=10.0;
String msg="";

/* streaming variables. Triggered within the gui, updated within the SerialEvent handlers */
String fid="";
boolean   streaming                 = false;
int       numStreamingOKs           = 0;
int       numErrors                 = 0;
int       priorNumErrors            = 0;
boolean   bufferedReaderSet         = false;
int       numRowsConfirmedProcessed = 0;
final int bufferSize                = 128; /* size of the grbl input buffer */
int       grblBufferUsed            = 0;   /* number of bytes currently used */
int       numLinesSent              = 0;
int       numLinesRead              = 0;
int       redBufferUsed             = 0;
BufferedReader     br               = null;
ArrayList<Integer> sentLineLengths  = new ArrayList<Integer>();
ArrayList<String>  redBuffer        = new ArrayList<String>(); /* past tense of read (reed) is spelled the same way as the present tense, so use Red as homophone of choise */

/* these four [] are aligned along the Serial.list of ports */ 
String [] portNames=null;
String [] serialThisNames=null;
Serial [] ports=null;
boolean[] portsBusy;
int grblIndex=-1;
JoyStick joy0 = new JoyStick();
float angleYOffOrthogoality=0.0;
float sinAngleYOffOrthogonality=0.0;
float xNonOrthogonalResidue=0.0;

Instant appStart = Instant.now();
Long time0=System.nanoTime(); /* initialized at the end of setup(), reset at end of every draw */
Long time1=System.nanoTime(); /* reset to the beginning of each ? query to the arduino to say   "How you doing?" */
/* an Attempt has been made to have time1 turnover occur every 0.5 seconds (ish) */
Long time2=System.nanoTime(); /* reset at beginning of every joystik excursion from deadZone */
Long time3=System.nanoTime(); /* reset at beginning of every instance of verbose logging */


/**********************************************************************************************************/
void setup(){
  size(900, 850  );
  background(212,208,200);
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  surface.setLocation(windows?1300:1020,windows?200:50);
  crlf[0]=13;
  crlf[1]=10;
  initLog4j();
  config();
  initGUI();
  initGrblSettings();

   
  knownGoodGrblComPort="COM6";  /* for TPMoyer's windows diagnostic runs */
  openSerialPorts(true);  
  /**/frameRate(frameRateLimit);

  if(-1 != grblIndex)ports[grblIndex].write("?"); /* get initial (hopefully "Idle") actionState */
  time0=System.nanoTime();
  timeNSay("at end of setup");
  
}
/**********************************************************************************************************/
void draw(){
  //log.debug("draw 0");
  background(212,208,200);
  surface.setTitle(frameTitle+"    "+round(frameRate) + " fps "+(heartBeat?"+":"-"));

  Long aTime= System.nanoTime();
  double deltaT=(aTime - time1) / 1.0e+6;
  //log.debug("deltaT="+deltaT);
  if((streaming?1000:500)<deltaT){ /*if streaming, query position every second, if normal, every 1/2 second */
    if(-1!=grblIndex)ports[grblIndex].write("?");
    //log.debug(String.format("draw wrote ? with deltaT=%5.3f frameRate=%5.1f",deltaT,frameRate));
    time1=aTime;
  }
  
  if(heartBeatFrameCount > framesPerHeartBeat){
    heartBeat=!heartBeat;
    heartBeatFrameCount=0;
    //log.debug("heartBeat="+(heartBeat?"True":"False"));
  }

  if(  (-1==grblIndex)
   &&(timeOut < Duration.between(appStart,Instant.now()).toMillis()/1000)
  ){
    logNCon(String.format("unable to get a response from GRBL after %7.3f seconds\n                      exiting",timeOut),"draw",1);
    System.exit(1);
  }
  doGuiLabels();
  if(-1!=grblIndex)joy0.doJoyStickJogging();
  time0= System.nanoTime();
}
/**********************************************************************************************************/
