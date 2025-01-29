/*
  Copyright (c) 2019 2021 2025 Thomas P Moyer

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
import java.util.TreeMap;
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

String  frameTitle       = "Grbl4P: a multiPlatform GCode Sender for Grbl and GrblHAL";
int     frameRateLimit=10;
char[]  crlf = new char[2];
char    lf=10;
char    cr=13;
String  crCharString="\n";
String  lfCharString="\r";
char    jogCancel=0x85;
int     epromDelay=100;
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
//boolean verboseLogging   = false;
boolean verboseLogging   = true;
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
boolean helpFlag = false;
boolean pinsFlag = false;



int   numAxies=-1;   /* this will be set when grbl report.c sends it's AXS: quantity */
String axisNames=""; /* this will be set when grbl report.c sends it's AXS: quantity */
/* the following are used with a dimension of numAxies, but are instanced here with the max numAxies (==8) */
float []   mPos         = new float    [8]; /* machine position */
float []   wco          = new float    [8]; /* work co-ordinates */
float []   maxFeedRates = new float    [8];
float [][] gParams      = new float[14][8];
int activeWCO=1; /* 1->G54  2->G55  3->G56  4->G57  5->G58  6->G59  7->G59.1  8->59.2  9->59.3 */
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
String [] labelPreTexts       = new String [40]; /* currently there are only 30 labels, so this is wasteful, but a buffer against sloppy expansion */
String [] labelPriorTexts     = new String [40];
boolean[] labelPreState       = new boolean[40];  /* default state == false */
boolean[] labelPriorState     = new boolean[40];
String [] textFieldPreTexts   = new String [20]; /* currently there are only 11 textfields, so this is wasteful, but a buffer against sloppy expansion */
String [] textFieldPriorTexts = new String [20];
//String [] buttonPreTexts      = new String [40];
//String [] buttonPriorTexts    = new String [40];
int numLabels=30;
boolean GCCCE=false; /* GCode Conformance Checking Enabled */

float [] jogStepSizes = {1.,1.,1.,1.,1.,1.};
float [] homes2WorkAllPositive = new float[8];
String[] grblSettings = null; /* save these as strings to avoid the    "some are ints, some are floats"    difficulties in printing */
String[] paramNames = {"G54","G55","G56","G57","G58","G59","G59.1","G59.2","G59.3","G28","G30","G92","TLO","PRB"};
Map<String,String>mGrblSettings = new HashMap<String,String>();
Map<String,String>mGrblPins     = new TreeMap<String,String>();
int numRows=0;
int rowCounter=0;
double timeOut=10.0;
String msg="";

/* streaming variables. Triggered within the gui, updated within the SerialEvent handlers */
String fid="";
int   [] bf = new int  [2]; /* bf[0]= plan_get_block_buffer_available()  bf[1]=hal.stream.get_rx_buffer_free() */
float [] ov = new float[3]; /* ov[0]=sys.override.feed_rate  ov[1]=sys.override.rapid_rate ov[2]=spindle_0->param->override_pct  */
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
int grblIndex=-1; /* reassigned to one of the ports upon reciept of the grblHal "hello" */
boolean seeAnyCom=false;
int longestPortNameLength=0;
int serialCounter=-1;
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
  size(940,940);
  background(212,208,200);
  surface.setTitle(frameTitle);
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  surface.setLocation(windows?1300:1020,windows?200:50);
  initLog4j();
  config();
  initGUI();
  initGrblSettings();
   
  knownGoodGrblComPort="COM5";  /* for TPMoyer's windows diagnostic runs */
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
