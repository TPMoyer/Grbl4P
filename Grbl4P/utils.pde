/*********************************************************************************************************************************/
int findFirstNonNumeric(String highstack) {
  for (int ii = 0; ii < highstack.length(); ii++) {
    char c = highstack.charAt(ii);
    if (  (   c < '0' 
           || c > '9'
          )
        &&( c != '.')
        &&( c != '-')
       ) {
       return ii;
    } // if
  } // for
  return -1;
}
/*********************************************************************************************************************************/
float teaseValue(String modLine,char xyorz){
  String sr=modLine.substring(1+modLine.indexOf(xyorz));
  //log.debug(String.format("xyorz=%c  sr=|%s|",xyorz,sr));
  int endAt=findFirstNonNumeric(sr);
  if(-1 != endAt){              
    sr=sr.substring(0,endAt);
    //log.debug("chars following the "+xyorz+"# endAt="+endAt+" sr=|"+sr+"|");
  }
  try {
    //float out= Float.valueOf(srNum.trim()).floatValue();
    //log.debug(String.format("out=%20.10f",out));
    return(Float.parseFloat(sr.trim()));
  } catch (NumberFormatException nfe) {
    System.err.println("fatal NumberFormatException: " + nfe.getMessage());
    log.fatal("NumberFormatException: " + nfe.getMessage());
    System.exit(9);
    return(0.0);
  }
}
/*********************************************************************************************************************************/
/* user clicked verbose logging */
void initAuxiliarry0Log4j(){
  log.debug("cme@ initAuxiliary0Log4j()");
  time3=System.nanoTime();
  String ancillaryPattern="%m%n"; /* message only */
  /* the following line is instanced in the app header for the main processing app, so as to have app wide scope */ 
  /*Logger log1 = Logger.getLogger("Ancillary0"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */

  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.HH_mm_ss");
  String logFileNamePart0= String.format("%s_",sdf.format(new Date()));
  logFileNamePart0="";
  String logFileNamePart1="Grbl4P_";
  String logFileNamePart2="joySerial";
  String logFileNamePart3="joyJog";
  String logFileNameEndPart=".csv";

  FileAppender fa0 = new FileAppender();  
  String fid=((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs"))+
    logFileNamePart0+
    logFileNamePart1+
    logFileNamePart2+
    logFileNameEndPart
  );
  log.debug("aux fid="+fid);
  fa0.setFile(fid);
  fa0.setLayout(new PatternLayout(ancillaryPattern));
  fa0.setThreshold(Level.DEBUG);
  fa0.setAppend(false);
  fa0.activateOptions();
  log0.addAppender(fa0);
  
  //log0.trace("log checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  //log0.debug("log checking ability to write at debug level");
  //log0.info ("log checking ability to write at info  level");
  //log0.warn ("log checking ability to write at warn  level");
  //log0.error("log checking ability to write at error level");
  //log0.fatal("log checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)\n");
  //try{
  //  log0.info("this log file was created by "+System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5));
  //  log0.info(System.getProperty("sun.java.command"));
  // } catch (Exception e) {
  //  e.printStackTrace();
  //}
  log0.debug("time (seconds),X,Y,Throttle,hat,disableX,disableY,throttle X and Y,lock Current State");

  //log.debug("@endOf initAuxiliarryLog4j()");
}  
/*********************************************************************************************************************************/
/* user clicked $C for Gcode check mode, output this to a log with the XYZ triplets converted to full GCode
 * This will allow the output log file to be input to GWizard
 */
void initAuxiliarry1Log4j(){
  log.debug("cme@ initAuxiliary1Log4j()");
  time3=System.nanoTime();
  String ancillaryPattern="%m%n"; /* message only */
  /* the following line is instanced in the app header for the main processing app, so as to have app wide scope */ 
  /*Logger log1 = Logger.getLogger("Ancillary0"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */

  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.HH_mm_ss");
  String logFileNamePart0= String.format("%s_",sdf.format(new Date()));
  logFileNamePart0="";
  String logFileNamePart1="Grbl4P_";
  String logFileNamePart2="$C_";
  String logFileNamePart3="Output";
  String logFileNameEndPart=".ncm";

  FileAppender fa1 = new FileAppender();  
  String fid=((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs"))+
    logFileNamePart0+
    logFileNamePart1+
    logFileNamePart2+
    logFileNamePart3+
    logFileNameEndPart
  );
  log.debug("aux fid="+fid);
  fa1.setFile(fid);
  fa1.setLayout(new PatternLayout(ancillaryPattern));
  fa1.setThreshold(Level.DEBUG);
  fa1.setAppend(false);
  fa1.activateOptions();
  log1.addAppender(fa1);
  
  //log0.trace("log checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  //log0.debug("log checking ability to write at debug level");
  //log0.info ("log checking ability to write at info  level");
  //log0.warn ("log checking ability to write at warn  level");
  //log0.error("log checking ability to write at error level");
  //log0.fatal("log checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)\n");
  //try{
  //  log0.info("this log file was created by "+System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5));
  //  log0.info(System.getProperty("sun.java.command"));
  // } catch (Exception e) {
  //  e.printStackTrace();
  //}
  //log0.debug("time (seconds),X,Y,Throttle,hat,disableX,disableY,throttle X and Y");

  //log.debug("@endOf initAuxiliarryLog4j()");
}  
/*********************************************************************************************************************************/
void initLog4j(){
  /* Log stuff follows the input from Jake Seigel:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/ */
  
  /* Tried out several message patterns till I found one I liked   */
  //String masterPattern = "[%c{1}], %d{HH:mm:ss}, %-5p, {%C}, %m%n";
  //String masterPattern = "%-5p %8r %3L %c{1} - %m%n";  
  //String masterPattern = "%-5p - %m%n"; /* source - message */
  //String masterPattern = "%-5p %8r - %m%n"; /* source miliseconds - message *?  */
  String masterPattern = "%-5p %8r %M - %m%n"; /* priority miliseconds Originating_Method  - message *?  */
  
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.HH_mm_ss");
  String logFileNamePrepender= String.format("%s_",sdf.format(new Date()));
  String logFileNameEndPart="Grbl_Logger.log";
  logFileNamePrepender="";
  logFileNameEndPart="Always_Same_Name_Logger.log";
  
  /* the following line is instanced in the app header for the main processing app, so as to have app wide scope */
  //Logger log  = Logger.getLogger("Master"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  FileAppender fa0 = new FileAppender();
  //String fileName="Grbl_Logger.log";
  fa0.setFile((System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\":sketchPath("/home/pi/logs/"))+logFileNamePrepender+logFileNameEndPart);  
  fa0.setLayout(new PatternLayout(masterPattern));
  fa0.setThreshold(Level.DEBUG);
  fa0.setAppend(false);
  fa0.activateOptions();  
  //Logger.getRootLogger().addAppender(fa0); /* this causes all loggers to be collected into the file pointed to by fa0 */
  log.addAppender(fa0); /* this causes the fa0 file to get only the content sent to log */
  
  log.trace("log checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  log.debug("log checking ability to write at debug level");
  log.info ("log checking ability to write at info  level");
  log.warn ("log checking ability to write at warn  level");
  log.error("log checking ability to write at error level");
  log.fatal("log checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)\n");
  try{
    log.info("this log file was created by "+System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5));
    log.info(System.getProperty("sun.java.command"));
   } catch (Exception e) {
    e.printStackTrace();
  }
  
  //String ancillaryPattern="%m%n"; /* message only */
  ///* the following line is instanced in the header for the main processing app, so as to have app wide scope */ 
  ///*Logger log1 = Logger.getLogger("Ancillary0"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  //FileAppender fa1 = new FileAppender();
  //String fileName1="GrblLogger1.log";
  //fa1.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName1:sketchPath("/home/pi/logs/"+fileName1)); 
  //fa1.setLayout(new PatternLayout(ancillaryPattern));
  //fa1.setThreshold(Level.DEBUG);
  //fa1.setAppend(false);
  //fa1.activateOptions();
  //log1.addAppender(fa1);
  
  //FileAppender fa2 = new FileAppender();
  //String fileName2="logger2.log";
  //fa2.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName2:sketchPath("/home/pi/logs/"+fileName2));
  //fa2.setLayout(new PatternLayout(ancillaryPattern));
  //fa2.setThreshold(Level.DEBUG);
  //fa2.setAppend(false);
  //fa2.activateOptions();
  //log2.addAppender(fa2);
  
  //FileAppender fa3 = new FileAppender();
  //String fileName3="logger3.log";
  //fa3.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName3:sketchPath("/home/pi/logs/"+fileName3));
  //fa3.setLayout(new PatternLayout(ancillaryPattern));
  //fa3.setThreshold(Level.DEBUG);
  //fa3.setAppend(false);
  //fa3.activateOptions();
  //log3.addAppender(fa3);
  
  //log1.trace("log1 checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  //log1.debug("log1 checking ability to write at debug level");
  //log1.info ("log1 checking ability to write at info  level");
  //log1.warn ("log1 checking ability to write at warn  level");
  //log1.error("log1 checking ability to write at error level");
  //log1.fatal("log1 checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)");  
}
/************************************************************************************************************************************/
void config(){
  String fid="Grbl4P.config";
  String[] joyButtonNames={"A01","A02","A04","A08","A10","A20","A40","A80","B01","B02","B04","B08"};
  String[] lines = loadStrings(fid);
  //log.debug("there are " + lines.length + " lines");
  for (int ii = 0 ; ii < lines.length; ii++) {
    //log.debug(lines[ii]);
    if(  (0<lines[ii].length())
       &&('#' != lines[ii].charAt(0))
      ){
      //log.debug(String.format("nonComment %s",lines[ii]));
      String[] parts = lines[ii].replace(" ","").split("=");
      if(2 != parts.length){
        msg="A have a line in the ./data/"+fid+" file which did not parse into variable = value    "+lines[ii];
        log.debug(msg);
        println(msg);
        System.exit(8);
      }  
      boolean match=false;
      boolean bad=false;
      /**/for(int jj=0;jj<parts.length;jj++){
      /**/  log.debug(String.format("%2d %s",jj,parts[jj]));
      /**/}  
      if(parts[0].equals("disableJoyStickX")){
         if(-1==joy0.setDisableXButtonIndex(figureJoyButtonNames(joyButtonNames,parts[1]))){
           bad=true;
           msg="have unrecognized joyButtonName from "+parts[0]+" "+parts[1];             
         } else {
           log.debug("setting disableXButtonIndex="+joy0.getDisableXButtonIndex());
           match=true;
         }  
      } else   
      if(parts[0].equals("disableJoyStickY")){
        if(-1==joy0.setDisableYButtonIndex(figureJoyButtonNames(joyButtonNames,parts[1]))){
           bad=true;
           msg="have unrecognized joyButtonName from "+parts[0]+" "+parts[1];             
         }  else {
           log.debug("setting disableYButtonIndex="+joy0.getDisableYButtonIndex());
           match=true;
         }  
      } else   
      if(parts[0].equals("joyStickThrottleXandY")){
        if(-1==joy0.setThrottleXandYButtonIndex(figureJoyButtonNames(joyButtonNames,parts[1]))){
           bad=true;
           msg="have unrecognized joyButtonName from "+parts[0]+" "+parts[1];             
         }  else {
           log.debug("setting throttleXandYButtonIndex="+joy0.getThrottleXandYButtonIndex());
           match=true;
         }  
      }  else   
      if(parts[0].equals("lockCurrentState")){
        if(-1==joy0.setLockCurrentStateButtonIndex(figureJoyButtonNames(joyButtonNames,parts[1]))){
           bad=true;
           msg="have unrecognized joyButtonName from "+parts[0]+" "+parts[1];             
         }  else {
           log.debug("setting getLockCurrentStateButtonIndex="+joy0.getLockCurrentStateButtonIndex());
           match=true;
         }  
      } else
      if(parts[0].equals("angleYDiffersFromXOrthogonality")){
        angleYOffOrthogoality=radians(Float.parseFloat(parts[1]));
        sinAngleYOffOrthogonality=sin(angleYOffOrthogoality);
        log.debug(String.format("set angleYOffOrthogoality = %7.3f degrees sinAngleYOffOrthogonality=",degrees(angleYOffOrthogoality),sinAngleYOffOrthogonality));
        match=true;
      } else   
      if(parts[0].equals("GCCCE")){
        GCCCE=parts[1].toUpperCase().equals("TRUE");
        log.debug("GCCCE="+(GCCCE?"true":"false"));
        match=true;
      }

      if(bad){
        log.debug(msg);
        println(msg);
        System.exit(9);
      }   
      if(!match){
        msg="B have a line in the ./data/"+fid+" file which did not parse into variable = value    "+lines[ii];
        log.debug(msg);
        println(msg);
        System.exit(10);
      }
    }    
  }
}
/************************************************************************************************************************************/
int figureJoyButtonNames(String[] names,String s){
  for(int ii=0;ii<names.length;ii++){
    if(s.equals("LEPJoy0_"+names[ii])){
      return(ii);
    }
  }
  return(-1); 
} 
/************************************************************************************************************************************/
