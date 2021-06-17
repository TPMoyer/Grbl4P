/*********************************************************************************************************************************/
void initLog4j(){
  /* Log stuff follows the input from Jake Seigel:   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/ */
    
  /* Tried out several message patterns till I found one I liked   */
  //String masterPattern = "[%c{1}], %d{HH:mm:ss}, %-5p, {%C}, %m%n";
  //String masterPattern = "%-5p %8r %3L %c{1} - %m%n";  
  //String masterPattern = "%-5p - %m%n"; /* source - message */
  String masterPattern = "%-5p %8r - %m%n"; /* source miliseconds - message *?
  
  /* the following line is instanced in the header for the main processing app, so as to have app wide scope */
  //Logger log  = Logger.getLogger("Master"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
  FileAppender fa0 = new FileAppender();
  String fileName="GPS_logger.log";
  fa0.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+fileName:sketchPath("/home/pi/logs/"+fileName));  
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
    log.fatal("this log file was created by "+System.getProperty("sun.java.command").substring(System.getProperty("sun.java.command").indexOf("path=")+5));
   } catch (Exception e) {
    e.printStackTrace();
  }
  
  String ancillaryPattern="%m%n"; /* message only */
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd.hhmmss");
  String logFileNamePrepender= String.format("%s_%d_",sdf.format(new Date()),milliSecondsBetweenReadings);
  String logFileNameEndPart;
  
  /* the following line is instanced in the header for the main processing app, so as to have app wide scope */ 
  /*Logger log1 = Logger.getLogger("Ancillary0"); /* Thank you Jake Seigel   https://jestermax.wordpress.com/2014/06/09/log4j-4-you/   */
    
  logFileNameEndPart="GPS_GGA.csv"; /*  GPS Fix Data */
  FileAppender fa1 = new FileAppender();
  fa1.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+logFileNamePrepender+logFileNameEndPart:sketchPath("/home/pi/logs/"+logFileNamePrepender+logFileNameEndPart)); 
  fa1.setLayout(new PatternLayout(ancillaryPattern));
  fa1.setThreshold(Level.DEBUG);
  fa1.setAppend(false);
  fa1.activateOptions();
  log1.addAppender(fa1);
  
  logFileNameEndPart="GPS_VTG.csv"; /* Course and Speed over Ground */
  FileAppender fa2 = new FileAppender();
  fa2.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+logFileNamePrepender+logFileNameEndPart:sketchPath("/home/pi/logs/"+logFileNamePrepender+logFileNameEndPart)); 
  fa2.setLayout(new PatternLayout(ancillaryPattern));
  fa2.setThreshold(Level.DEBUG);
  fa2.setAppend(false);
  fa2.activateOptions();
  log2.addAppender(fa2);
  
  logFileNameEndPart="GPS_GSA.csv"; /* DOPS and active Satellites */
  FileAppender fa3 = new FileAppender();
  fa3.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+logFileNamePrepender+logFileNameEndPart:sketchPath("/home/pi/logs/"+logFileNamePrepender+logFileNameEndPart)); 
  fa3.setLayout(new PatternLayout(ancillaryPattern));
  fa3.setThreshold(Level.DEBUG);
  fa3.setAppend(false);
  fa3.activateOptions();
  log3.addAppender(fa3);
  
  logFileNameEndPart="GPS_GSV.csv"; /* Satellites in view */
  FileAppender fa4 = new FileAppender();
  fa4.setFile(System.getProperty("os.name").toLowerCase().startsWith("win")?"c:\\logs\\"+logFileNamePrepender+logFileNameEndPart:sketchPath("/home/pi/logs/"+logFileNamePrepender+logFileNameEndPart)); 
  fa4.setLayout(new PatternLayout(ancillaryPattern));
  fa4.setThreshold(Level.DEBUG);
  fa4.setAppend(false);
  fa4.activateOptions();
  log4.addAppender(fa4);
  
 
  //log1.trace("log1 checking ability to write at trace level"); /* not believed to be part of log4j, maby it came in with log4j2???  */
  //log1.debug("log1 checking ability to write at debug level");
  //log1.info ("log1 checking ability to write at info  level");
  //log1.warn ("log1 checking ability to write at warn  level");
  //log1.error("log1 checking ability to write at error level");
  //log1.fatal("log1 checking ability to write at fatal level\nIf you see this in the Eclipse console, your log4j2.xml was not active (it should be in /src/main/resources)");  
}

/************************************************************************************************************************************/
void logDumpPackets(String[] packets){
  for(int ii=0;ii<packets.length;ii++){
     log.debug(String.format("packets[%2d]=%s",ii,packets[ii]));
   }
}
/************************************************************************************************************************************/
String[] packetizer(String s){
  //log.debug("packetizer see P "+(s.charAt(1)=='P'?"true":"False"));
  String[] packets=s.substring(s.charAt(1)=='P'?5:3).split(",");     
  packets[packets.length-1]=packets[packets.length-1].substring(0,packets[packets.length-1].length()-3);  
  return(packets);
}   
/************************************************************************************************************************************/  
void timeNSay(String s){
  float timeElapsedInSeconds = Duration.between(appStart,Instant.now()).toMillis()/1000.;
  String so=String.format("%8.3f %s",timeElapsedInSeconds,s);
  println(so);
  log.debug(so);
}  
/**************************************************************************************************************/
/* send to the log file and to the console, a string what was pushed to the port */
void logNCon(String s){
  println(s);
  log.debug(s);
}  
/**************************************************************************************************************/
