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
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

/* Thank you Jake Seigel for the processing log4j connectivity!    
 * I'm a logggerDebugger and this was key to being able to 
 * dig myself out of several/many  holes/traps/mistakes/typos:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/    */
import org.apache.log4j.*;
Logger log  = Logger.getLogger("Master"); 
//Logger log1 = Logger.getLogger("Ancillary0");
//Logger log2 = Logger.getLogger("Ancillary1");
//Logger log3 = Logger.getLogger("Ancillary2");


String  frameTitle       = "GRBL Gui";
int frameRateLimit=10;
char[] crlf = new char[2];
char lf=10;
String crCharString="/n";
String lfCharString="/r";
char jogCancel=0x85;
int epromDelay=100;
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
String [] labelPreTexts   = new String[40];
String [] labelPriorTexts = new String[40];
boolean[] labelPreState   = new boolean[40];  /* default state == false */
boolean[] labelPriorState = new boolean[40];
int numLabels=30;

float [] jogStepSizes = {1.,1.,1.,1.,1.,1.};
float [] homes2WorkAllPositive = new float[3];
String[] grblSettings = null; /* save these as strings to avoid the    "some are ints, some are floats"    difficulties in printing */
String[] paramNames = {"G54","G55","G56","G57","G58","G59","G28","G30","G92","TLO","PRB"};
Instant appStart = Instant.now();
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
int       redBufferUsed             = 0;
BufferedReader     br               = null;
ArrayList<Integer> sentLineLengths  = new ArrayList<Integer>();
ArrayList<String>  redBuffer        = new ArrayList<String>(); /* past tense of read (reed) is spelled the same way as the present tense, so use Red as homophone of choise */

/* these three [] are aligned along the Serial.list of ports */ 
String[] portNames=null;
String[] serialThisNames=null;
Serial[] ports=null;
boolean[] portsBusy;
int grblIndex=-1;
/* this being not -1 will be the boolean for is-a-joystick-present */
int joyIndex=-1;

float   joyY;       /* outside the dead-zone, is mapped to -1.0 for full back, 0.0 for center, 1.0 for full forward */ 
float   joyX;       /* outside the dead-zone, is mapped to -1.0 for full left, 0.0 for center, 1.0 for full right */
float   joyThrottle;/* has no dead-zone.         mapped to 0.01 for full back to 1.0 for full forward */
//int     joyZUpDown; 
float   joyRotate;  /* not currently used by Grbl4P */
int     joyHat=8;  /* only positions up and down on the hat are used.   These are 0 for up and 4 for down */
float   joyStickDeadZone=0.15;
boolean feedHold0;                /*  Trigger                            bit0    button 0 */
//boolean resetSlashAbort;        /*  Thumb Switch                       bit1    button 1    not connected, I hit it too much unintentionally */                                              
boolean auxPowerOff;              /*  Near Button Left of Hat            bit2    button 2 */
boolean auxPowerOn;               /*  Near Button Right of Hat           bit3    button 3 */
boolean feedHold1;                /*  Far Button Left of Hat             bit4    button 4 */
boolean cycleStartSlashResume;    /*  Far Button Right of Hat            bit5    button 5 */
boolean motorsDisable;            /*  Lower Far Button on Base           bit6    button 6 */
boolean motorsEnable;             /*  Upper Far Button on Base           bit7    button 7 */
boolean spindleOff;               /*  Lower Mid-Distance Button on Base  bit8    button 8 */
boolean spindleOne;               /*  Upper Mid-Distance Button on Base  bit9    button 9 */
boolean coolantSlashLaserDisable; /*  Lower Near Button on Base          bit10   button 10 */
boolean coolantSlashLaserEnable;  /*  Upper Near Button on Base          bit11   button 11 */
/* joystick hat is recieved as part of the buttons integer.  
 * Hat has bits 12,13,14,15 encoded as after shifting right 12 bits ie    >>12
 *    8   hat centered
 *    0   hat Up
 *    1   hat UpRight
 *    2   hat Right
 *    3   hat DownRight
 *    4   hat Down
 *    5   hat DownLeft
 *    6   hat Left
 *    7   hat UpLeft
 */

boolean amJoyStickJogging=false;
int     numJoyStickJogsSent=0;
int     numJoyStickJoggingOKs=0;
boolean gotJoyPriors=false;
boolean[] joyStickButtons = new boolean[12];
int priorJoyX;
int priorJoyY;
int priorJoyR; /* R for rotate (twist of the handle) */
int priorJoyT; /* T for throttle, the slider at the rear of the joystick */
int priorJoyS; /* S for switches (includes all 12 and the hat) */
//int priorJoyZUpDown;
int priorJoyHat=8;
boolean joyUpdateHasBeenHandled=true;
Long time0=System.nanoTime(); /* initialized at the end of setup(), reset at end of every draw */
Long time1=System.nanoTime(); /* reset to the beginning of each ? query to the arduino to say   "How you doing?" */
/* an Attempt has been made to have time1 turnover occur every 0.5 seconds (ish) */
Long time2=System.nanoTime(); /* reset at beginning of every joystik excursion from deadZone */


/**********************************************************************************************************/
void setup(){
  size(900, 850  );
  background(212,208,200);
  boolean windows=System.getProperty("os.name").toLowerCase().startsWith("win");
  surface.setLocation(windows?1300:1020,windows?0:50);
  crlf[0]=13;
  crlf[1]=10;
  initLog4j();
  initGUI();
  initGrblSettings();
   
  knownGoodGrblComPort="COM6";  /* for TPMoyer's windows diagnostic runs */
  openSerialPorts(true);  
  //frameRate(frameRateLimit);

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
  if(-1!=grblIndex)doJoyStickJogging();
  time0= System.nanoTime();
}
/**********************************************************************************************************/
