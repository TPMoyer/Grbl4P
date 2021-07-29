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
char[] crlf = new char[2];
char lf=10;
String crCharString="/n";
String lfCharString="/r";
int epromDelay=100;
String  portName         = null;
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
int     frameModulo      = 0;
int     frameRateLimit   = 5;
int     idleCount        =0; /* limit the number of unchanging reports which get logged */
int     alarmCount       =0; /* limit the number of unchanging reports which get logged */
int     currentWCO       =1; /* this corresponds to G54 */
float []           mPos = new float[3]; /* machine position */
float []           wco  = new float[3]; /* work co-ordinates */
float []           ov   = new float[3]; /* nfi (no bleeding idea) */
float [] maxFeedRates   = new float[3];
float [][] gParams = new float[11][3];
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
int       numOKs                    = 0;
int       numErrors                 = 0;
int       priorNumErrors                 = 0;
boolean   bufferedReaderSet         = false;
int       numRowsConfirmedProcessed = 0;
final int bufferSize                = 128; /* size of the grbl input buffer */
int       grblBufferUsed            = 0;   /* number of bytes currently used */
int       numLinesSent              = 0;
int       redBufferUsed             = 0;
BufferedReader     br               = null;
ArrayList<Integer> sentLineLengths  = new ArrayList<Integer>();
ArrayList<String>  redBuffer        = new ArrayList<String>(); /* past tense of read (reed) is spelled the same way as the present tense, so use Red as homophone of choise */
Long time0;
Long time1;

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
  crlf[0]=13;
  crlf[1]=10;
  initLog4j();
  initGUI();
  initGrblSettings();
  
  knownGoodGrblComPort="COM6";  /* for TPMoyer's windows diagnostic runs */
  openSerialPort(true);  
  frameRate(frameRateLimit);
  timeNSay("at end of setup");
  time0=System.nanoTime();
}
/**********************************************************************************************************/
void draw(){
  //log.debug("draw 0");
  background(212,208,200);
  surface.setTitle(frameTitle+"    "+round(frameRate) + " fps "+(heartBeat?"+":"-"));
  /* when this "ask for status" was 10 hz, would occasionally get a null error somewhere down inside the GUI from G4P code (source==unknown) */
  if(0==frameModulo){
    //log.debug("frameModulo says ask for status");
    time1 = System.nanoTime();
    port.write("?");
    //logNCon("cnc1 wrote ?","draw",0);    
    log.debug("streaming="+(streaming?"True":"False")+" queryDelta " + ((time1 - time0) / 1.0e+6) + " ms");
    time0=time1;
  }
  
  if(frameRateLimit==frameCount%(frameRateLimit+1)){
    heartBeat=!heartBeat;
    //log.debug("heartBeat="+(heartBeat?"True":"False"));
  }  
  
  if(  streaming ){
    frameModulo=(frameModulo+1)%frameRateLimit;  /* limit the status request to 1hz while streaming */
  } else {  
    //frameModulo=(5>=(round(frameRate)/5)?0:((frameModulo+1)%(round(frameRate)/5))); /* limit the status request to about 5hz */
    frameModulo=(frameModulo+1)%(round(frameRate/5.0+1));
    //frameModulo=(frameModulo+1)%frameRateLimit;
    //log.debug(String.format("frameRate=%6.1f frameCount=%4d frameModulo=%d",frameRate,frameCount,frameModulo));
   }   

  if(  ( ! seeGrbl)
   &&(timeOut < Duration.between(appStart,Instant.now()).toMillis()/1000)
  ){
    logNCon(String.format("unable to get a response on any port after %7.3f seconds\n                      exiting",timeOut),"draw",1);
    System.exit(1);
  }

  /* I'm not proud of this sectin... I would have preferred to access the labels as indexed istances of the label class
  or to have used "convert-string-to-code", but that seem combersome and risky as opposed to the implemented
  tediousness below */
  if(!labelPreTexts [1].equals(labelPriorTexts[1])){
     label1.setText(    labelPreTexts[1]);
     labelPriorTexts[1]=labelPreTexts[1];
  }
  if(!labelPreTexts [2].equals(labelPriorTexts[2])){
     label2.setText(    labelPreTexts[2]);
     labelPriorTexts[2]=labelPreTexts[2];
  }
  if(!labelPreTexts [3].equals(labelPriorTexts[3])){
  
  }
  //if(!labelPreTexts [4].equals(labelPriorTexts[4])){
  //   label4.setText(    labelPreTexts[4]);
  //   labelPriorTexts[4]=labelPreTexts[4];
  //}
  if(!labelPreTexts [5].equals(labelPriorTexts[5])){
     label5.setText(    labelPreTexts[5]);
     labelPriorTexts[5]=labelPreTexts[5];
  }
  if(!labelPreTexts [6].equals(labelPriorTexts[6])){
     label6.setText(    labelPreTexts[6]);
     labelPriorTexts[6]=labelPreTexts[6];
  }
  if(!labelPreTexts [7].equals(labelPriorTexts[7])){
     label7.setText(    labelPreTexts[7]);
     labelPriorTexts[7]=labelPreTexts[7];
  }
  if(!labelPreTexts [8].equals(labelPriorTexts[8])){
     label8.setText(    labelPreTexts[8]);
     labelPriorTexts[8]=labelPreTexts[8];
  }
  if(!labelPreTexts [9].equals(labelPriorTexts[9])){
     label9.setText(    labelPreTexts[9]);
     labelPriorTexts[9]=labelPreTexts[9];
  }
  if(!labelPreTexts [10].equals(labelPriorTexts[10])){
     label10.setText(    labelPreTexts[10]);
     labelPriorTexts[10]=labelPreTexts[10];
  }
  if(!labelPreTexts [11].equals(labelPriorTexts[11])){
     label11.setText(    labelPreTexts[11]);
     labelPriorTexts[11]=labelPreTexts[11];
  }
  if(!labelPreTexts [12].equals(labelPriorTexts[12])){
     label12.setText(    labelPreTexts[12]);
     labelPriorTexts[12]=labelPreTexts[12];
  }
  if(!labelPreTexts [13].equals(labelPriorTexts[13])){
     label13.setText(    labelPreTexts[13]);
     labelPriorTexts[13]=labelPreTexts[13];
  }
  if(!labelPreTexts [14].equals(labelPriorTexts[14])){
     log.debug("activeState label changed labelPreTexts[14]="+labelPreTexts[14]+" priorActiveDrawnState="+priorActiveDrawnState+" activeState="+activeState);
     label14.setText(    labelPreTexts[14]);
     labelPriorTexts[14]=labelPreTexts[14];
     if(  (  priorActiveDrawnState.equals("Alarm")
          ||priorActiveDrawnState.equals("error")
         ) 
       &&(!activeState.equals("Alarm"))              /* alarm is over, make all quiescent */
      ){
      //log.debug("pre label14 colorscheme set");
      label14.setLocalColorScheme(GCScheme.SCHEME_9);
      //log.debug("pre label14 setOpaque(false)");
      label14.setOpaque(false);
      label15.setLocalColorScheme(GCScheme.SCHEME_9);
      label15.setOpaque(false);
      labelPreTexts[22]="";
    } else 
    if(  (!priorActiveDrawnState.equals("Alarm"))
       &&(activeState.equals("Alarm"))               /* sound the alarm */
    ){
      //log.debug("pre label14.setColorScheme");
      label14.setLocalColorScheme(GCScheme.SCHEME_10);
      //log.debug("pre label14.setOpaque");
      label14.setOpaque(true);      
      label15.setLocalColorScheme(GCScheme.SCHEME_10);
      label15.setOpaque(true);
    }
    priorActiveDrawnState=activeState;
  }
  if(!labelPreTexts [15].equals(labelPriorTexts[15])){
     label15.setText(    labelPreTexts[15]);
     labelPriorTexts[15]=labelPreTexts[15];
  }
  if(!labelPreTexts [16].equals(labelPriorTexts[16])){
     label16.setText(    labelPreTexts[16]);
     labelPriorTexts[16]=labelPreTexts[16];
  }
  /* label17 is static "No Motion" which is made visible with yellow background or not visible */
  //if(!labelPreTexts [17].equals(labelPriorTexts[7])){
  //   label17.setText(    labelPreTexts[17]);
  //   labelPriorTexts[17]=labelPreTexts[17];
  //}
  if(!labelPreTexts [18].equals(labelPriorTexts[18])){
     label18.setText(    labelPreTexts[18]);
     labelPriorTexts[18]=labelPreTexts[18];
  }
  //if(!labelPreTexts [19].equals(labelPriorTexts[19])){
  //   label19.setText(    labelPreTexts[19]);
  //   labelPriorTexts[19]=labelPreTexts[19];
  //}
  if(!labelPreTexts [20].equals(labelPriorTexts[20])){
     label20.setText(    labelPreTexts[20]);
     labelPriorTexts[20]=labelPreTexts[20];
  }
  //if(!labelPreTexts [21].equals(labelPriorTexts[21])){
  //   label21.setText(    labelPreTexts[21]);
  //   labelPriorTexts[21]=labelPreTexts[21];
  //}
  if(!labelPreTexts [22].equals(labelPriorTexts[22])){
     label22.setText(    labelPreTexts[22]);
     labelPriorTexts[22]=labelPreTexts[22];
  }
  if(!labelPreTexts [23].equals(labelPriorTexts[23])){
    log.debug("labelPreTexts[23]="+labelPreTexts[23]+" labelPriorTexts[23]="+labelPriorTexts[23]+" labelPreState[23]="+labelPreState[23]+" labelPriorState[23]="+labelPriorState[23]+" scheme9or10="+(labelPreState[23]?10:9));
    label23.setText(    labelPreTexts[23]);
    labelPriorTexts[23]=labelPreTexts[23];
    label23.setLocalColorScheme(labelPreState[23]?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
    label23.setOpaque          (labelPreState[23]);
    labelPriorState[23]=labelPreState[23];
  }
  if(!labelPreTexts [24].equals(labelPriorTexts[24])){
    log.debug("labelPreTexts[24]="+labelPreTexts[24]+" labelPriorTexts[24]="+labelPriorTexts[24]+" labelPreState[24]="+labelPreState[24]+" labelPriorState[24]="+labelPriorState[24]+" scheme9or10="+(labelPreState[24]?10:9));
    label24.setText(    labelPreTexts[24]);
    labelPriorTexts[24]=labelPreTexts[24];
    label24.setLocalColorScheme(labelPreState[24]?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
    label24.setOpaque          (labelPreState[24]);
    labelPriorState[24]=labelPreState[24];
  }
  if(!labelPreTexts [25].equals(labelPriorTexts[25])){
    log.debug("labelPreTexts[25]="+labelPreTexts[25]+" labelPriorTexts[25]="+labelPriorTexts[25]+" labelPreState[25]="+labelPreState[25]+" labelPriorState[25]="+labelPriorState[25]+" scheme9or10="+(labelPreState[25]?10:9));
    label25.setText(    labelPreTexts[25]);
    labelPriorTexts[25]=labelPreTexts[25];
    label25.setLocalColorScheme(labelPreState[25]?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
    label25.setOpaque          (labelPreState[25]);
    labelPriorState[25]=labelPreState[25];
  }
  if(!labelPreTexts [26].equals(labelPriorTexts[26])){
    label26.setText(    labelPreTexts[26]);
    labelPriorTexts[26]=labelPreTexts[26];
    label26.setLocalColorScheme(labelPreState[26]?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
    label26.setOpaque          (labelPreState[26]);
    labelPriorState[6]=labelPreState[26];
  }
  if(!labelPreTexts [27].equals(labelPriorTexts[7])){
     label27.setText(    labelPreTexts[27]);
     labelPriorTexts[27]=labelPreTexts[27];
     label27.setLocalColorScheme(labelPreState[27]?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
     label27.setOpaque          (labelPreState[27]);
     labelPriorState[27]=labelPreState[27];
  }
  if(!labelPreTexts [28].equals(labelPriorTexts[28])){
     label28.setText(    labelPreTexts[28]);
     labelPriorTexts[28]=labelPreTexts[28];
  }
  //if(!labelPreTexts [29].equals(labelPriorTexts[29])){
  //   label29.setText(    labelPreTexts[29]);
  //   labelPriorTexts[29]=labelPreTexts[29];
  //}
  if(!labelPreTexts [30].equals(labelPriorTexts[30])){
     label30.setText(    labelPreTexts[30]);
     labelPriorTexts[30]=labelPreTexts[30];
  }
  

  //log.debug("draw 1 with frameModulo="+frameModulo+" divisor="+round(frameRate)/5);
  //log.debug("draw 1 with frameModulo="+frameModulo+" divisor="+round(frameRate)/5);
}
