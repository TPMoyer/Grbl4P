
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
void serialEvent(Serial p){
  String s = p.readStringUntil('\n').trim();
  /* Initial peek at the stream of data which enters this method 
   * for(int ii=0;ii<s.length();ii++)logNCon(String.format("%2d %c %3d",ii,s.charAt(ii),(int)s.charAt(ii)),"serialEvent",0); 
   * The above show-every-character for() has become legacy code
   */
  //if(s.startsWith("Grbl"))logNCon("see Grbl initialization with grblIndex="+grblIndex,"serialEvent",0);
  if(  (-1==grblIndex)
    &&(s.startsWith("Grbl"))
   ){
   grblIndex=portMatcher(p);  
   log.debug("grblIndex set to "+grblIndex+" which is "+portNames[grblIndex]);
  }
  if(  (-1==joy0.getPortIndex())
     &&(s.startsWith("J0Y"))
    ){
    joy0.setPortIndex(portMatcher(p));
    label4 .setVisible(true);
    label19.setVisible(true);
    button16.setVisible(true);
    button24.setVisible(true);
    //labelPreTexts[21]="X state="+joy0.getXResponseState()+" preState="+joy0.getPriorXResponseState(); 
    //labelPreTexts[29]="Y state="+joy0.getYResponseState()+" preState="+joy0.getPriorYResponseState();
    //labelPreTexts[31]="Sticky="+(joy0.getResponseStatesAreSticky()?"true ":"false")+" prior="+(joy0.getPriorResponseStatesWereSticky()?"true ":"false");
    //log.debug("port initialization \n"+labelPreTexts[21]+"\n"+labelPreTexts[29]+"\n"+labelPreTexts[31]);
    log.debug("J0Y setting joy0.portIndex="+joy0.getPortIndex()+" prompted by "+s+" and made label4 visible");
  } else {
    //log.debug("Serial"+p+" s="+s);
    if(s.startsWith("J0Y")){
      joy0.joyStickSerialEvent(s);
    } else {
      grblSerialEvent(s,p);
    }
  }
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
void grblSerialEvent(String s,Serial p){
  if(verboseLogging)log.debug("GrblSerialEvent s="+s);
  if(0<s.length()){  
    //logNCon("s="+s,"serialEvent",1);
    //log.debug("serialEvent |s|=|"+s+"|");
    //if(-1!=s.indexOf('>'))s=s.substring(0,s.indexOf('>')); 
    if(!streaming){
      if(s.startsWith("<Idle" )){
        idleCount++;
      } else {
        idleCount =0;
      }  
      if(s.startsWith("<Alarm")){
        alarmCount++; 
      } else {
        alarmCount=0;
      }  
    }  
    //if(  (!streaming)
    //   &&(  verboseOutput
    //      ||('<'!=s.charAt(0))
    //     ) 
    //   &&('$'!=s.charAt(0)) /* do not push thru the grblParams,    they are pretty-printed post collection of the full set */  
    //   &&('#'!=s.charAt(0)) /* do not push thru the hashtagParams, they are pretty-printed post collection of the full set */
    //   &&(!s.trim().equals("ok"))
    //  ){ 
    //  timeNSay(String.format("160 see |%s|",s.trim()));
    //}
    /* check for ok or error to have the numbers fed into the streaming handler be correct */
    if(s.equals("ok") ){
      Long aTime= System.nanoTime();;
      if(streaming){
        numStreamingOKs+=1;
      } else   
      if(joy0.getAmJoyStickJogging()){
        //log.debug(String.format("jog ok %6.3f %6.3f",((aTime - time2) / 1.0e+6),((aTime - time0) / 1.0e+6)));
        joy0.incrementNumJoyStickJoggingOKs();
      }
      else {
        //log.debug(String.format("    ok %6.3f %6.3f",((aTime - time2) / 1.0e+6),((aTime - time0) / 1.0e+6)));
        /* remove any error or Alarm text */
        msg="";
        labelPreTexts[22]=msg;
        if(true==seeHashtagParams){
          log.debug("in seehashtagParams");
          hashtagParams2Console();
          seeHashtagParams=false;
        }
        if(true==seeGrblParams){
          log.debug("in seeGrblParams");
          grblParams2Console();
          seeGrblParams=false;
        }
      }
    } else
    if(  s.startsWith("error")
       ||s.startsWith("<Alarm")
       ||s.startsWith("ALARM")
    ){
      if(streaming) handleStreamingError(s);
      else handleAlarmNError(s); 
    }
    
    if(streaming && bufferedReaderSet){
      //logNCon("streaming "+s,"serialEvent",2);
      handleFileBufferFillNPush();
    }
    
    if(s.startsWith("<Idle")){ /* currently no action taken upon recieving this */
      if(5>idleCount){
        log.debug("see fresh Idle s=|"+s+"|");
      } else {  
        if(doNotAllowIdleToGoStale){
          log.debug("see unfresh Idle s=|"+s+"|");
        } else {
          //log.debug("see stale Idle |s|=|"+s+"|");
        }  
      }
    } 
    if(  (  (s.startsWith("<Idle"))
          &&(  (5>idleCount)
             ||doNotAllowIdleToGoStale
            ) 
         )
       ||(  (!s.startsWith("<Idle"))
          &&(s.charAt(0)=='<')
         ) 
      ){
      handleStatusReport(s); /* the response to the 5hz status report query needed extensive handling */
    } else
    if(s.startsWith("[GC")){  /* currently no action taken upon recieving this */
      logNCon("got [GC.   reflects "+s,"serialEvent",3);
    } else
    if(s.startsWith("[HLP")){ /* currently no action taken upon recieving this */
      logNCon("got [HLP.   reflects "+s,"serialEvent",4);
    } else
    if(s.startsWith("[VER")){ /* currently no action taken upon recieving this */
      logNCon("got [VER.   reflects "+s,"serialEvent",5);
    } else
    if(s.startsWith("[OPT")){ /* currently no action taken upon recieving this */
      logNCon("got [VER.   reflects "+s,"serialEvent",6);
    } else
    if(s.startsWith("[MSG")){ /* currently no action taken upon recieving this */
      handleMsg(s);
    } else
    if(  s.charAt(0)=='['){ /* the assembly of these into the (float[11][3]+lastProbeGood) needed extensive handling  */
      handleNumberParams(s);
    } else
    if(s.startsWith("Grbl")){
      grblIndex=portMatcher(p);
      if(-1==grblIndex){
        msg="no match to a grbl Serial.list member.   This is fatal";
        logNCon(msg,"SerialEvent",3);
        System.exit(2);
      }  
      handleGrblSaysHello(s);
    } else    
    if(s.startsWith("$")){ /* collect these grbl parameters for use in the GUI  */
      handleGrblSettingCollection(s);
    } 
    /* this is not part of the above if{}else if{} stack.  This is an independent if */
    if(  (s.startsWith("<"))
       &&(true==priorStatusHadPn)
       &&(!s.contains("Pn:"))
      ){
      handleCleanupOfNoMorePn(s);
    }
  }
  //log.debug("@endOf serialEvent()");
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleStatusReport(String s){ /* the response to the 5hz status report query */
  String[] chunks=s.substring(1,s.length()-1).split("\\|",0);
  //logNCon("number of chunks = "+chunks.length+" from s="+s,"handleStatusReport",14);
  //logNCon("handleStatusReport nuChunks = "+chunks.length,"handleStatusReport",0);
  //log.debug("handleStatusReport nuChunks = "+chunks.length);
  //for(int ii=0;ii<chunks.length;ii++){
  //  logNCon("\n"+chunks[ii],"handleStatusReport",1);
  //  for(int jj=0;jj<chunks[ii].length();jj++){
  //    logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks[ii].charAt(jj),(int)chunks[ii].charAt(jj)),"handleStatusReport",2);
  //  }  
  //}
  for(int ii=1;ii<chunks.length;ii++){
    String[] responseData = chunks[ii].split(":",2);
    if(responseData[0].equals("MPos")){
      //log.debug("MPos");
      String[] pos = responseData[1].split(",",3);
      /* the reported mPos numbers are out of date, when joystick jogging is happening */
      float[] priorMPos= new float[3];
      for(int jj=0;jj<3;jj++){
        try {
          priorMPos[jj]=mPos[jj];
          //log.debug("pos["+jj+"]="+pos[jj]);
          mPos[jj]=Float.valueOf(pos[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",3);
          System.err.println("NumberFormatException: " + nfe.getMessage());
        }
      }
      /* the Machine Position (MPos) is shown is the GUI as the non-bold, smaller, lower row of location coordinatess */
      if(0.0==angleYOffOrthogoality){
        msg=String.format("(%9.3f,",mPos[0]);
      } else {
        msg=String.format("(%9.3f,",mPos[0]-sinAngleYOffOrthogonality*mPos[1]);
      }  
      //log.debug("7 msg="+msg);
      labelPreTexts[7]=msg;
      //label7.setText(msg);
      msg=String.format( "%9.3f,",mPos[1]);
      //log.debug("8 msg="+msg);
      labelPreTexts[8]=msg;
      //label8.setText(msg);
      msg=String.format( "%9.3f)",mPos[2]);
      //log.debug("9 msg="+msg);
      labelPreTexts[9]=msg;
      //label9.setText(msg);

      /* the Work Position (WPos) is shown in the GUI as the bold, larger, upper row of location coordinates */
      if(0.0==angleYOffOrthogoality){
        msg=String.format("(%9.3f,",mPos[0]-gParams[activeWCO][0]);
      } else {
         msg=String.format("(%9.3f,",mPos[0]-gParams[activeWCO][0]-(sinAngleYOffOrthogonality *(mPos[1]-gParams[activeWCO][1]) ));
      }  
      //log.debug("2 msg="+msg);
      labelPreTexts[2]=msg;
      msg=String.format( "%9.3f,",mPos[1]-gParams[activeWCO][1]);
      //log.debug("10 msg="+msg);
      labelPreTexts[10]=msg;
      msg=String.format( "%9.3f)",mPos[2]-gParams[activeWCO][2]);
      //log.debug("11 msg="+msg);
      labelPreTexts[11]=msg;
    } else 
    if(responseData[0].equals("FS")){
      //log.debug("FS");
      String[] nums = responseData[1].split(",",2);
      try {
        feedRate=Float.valueOf(nums[0]);
        msg=String.format("   Feed: %5.0f",feedRate);
        //log.debug("16 msg="+msg);
        labelPreTexts[16]=msg;
        //label16.setText(msg);
        //logNCon("feedRate="+feedRate,"handleStatusReport",4);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",13);
        System.err.println("NumberFormatException: " + nfe.getMessage());
        log.debug("NumberFormatException: " + nfe.getMessage());
      }
      try {
        spindleSpeed=Integer.parseInt(nums[1]);
        msg=String.format("Spindle: %5d",spindleSpeed);
        //log.debug("18 msg="+msg);
        labelPreTexts[18]=msg;
        //label18.setText(msg);
        //logNCon("spindleSpeed="+spindleSpeed,"handleStatusReport",5);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",12);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else 
    if(responseData[0].equals("F")){
      //log.debug("F");
      try {
        feedRate=Float.valueOf(responseData[1]);
        msg=String.format("   Feed: %5.0f",feedRate);
        //log.debug("16 msg="+msg);
        labelPreTexts[16]=msg;
        //label16.setText(msg);
        //logNCon("feedRate="+feedRate,"handleStatusReport",6);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",7);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else
    if(responseData[0].equals("Ov")){
      //log.debug("Ov");
      String[] ovs = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          ov[jj]=Float.parseFloat(ovs[jj]);
          //log.debug("ov["+jj+"]="+ov[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",8);
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(8);
        }
      }
    } else
    if(responseData[0].equals("WCO")){
      //log.debug("WCO");
      String[] wcos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          wco[jj]=Float.valueOf(wcos[jj]);
          //log.debug("wco["+jj+"]="+wco[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage(),"handleStatusReport",9);
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(5);
        }
      }
      // /* the Work Position (WPos) is shown in the GUI as the bold, larger, upper row of location coordinates */
      // //msg=String.format("(%9.3f,",mPos[0]-wco[0]);
      // msg=String.format("(%9.3f,",wco[0]);
      // //log.debug("2 msg="+msg);
      // labelPreTexts[2]=msg;
      // //label2 .setText(msg);
      // //msg=String.format( "%9.3f,",mPos[1]-wco[1]);
      // msg=String.format( "%9.3f,",wco[1]);
      // //log.debug("10 msg="+msg);
      // labelPreTexts[10]=msg;
      // //label10.setText(msg);
      // //msg=String.format( "%9.3f)",mPos[2]-wco[2]);
      // msg=String.format( "%9.3f)",wco[2]);
      // //log.debug("11 msg="+msg);
      // labelPreTexts[11]=msg;
      //label11.setText(msg);
    } else
    if(responseData[0].equals("Bf")){
      //log.debug("Bf");
      String[] bf = responseData[1].split(",",2);
      /**/log.debug("number of available blocks in the planner buffer ="+bf[0]);
      /**/log.debug("number of available bytes in the serial RX buffer="+bf[1]);
    } else
    if(responseData[0].equals("Pn")){
      //log.debug("Pn");
      /* did not put indicators on GUI for hold pin, soft-reset pin, or cycle-start pin */
      //log.debug("Pn");
      boolean currentXLimitState=responseData[1].contains("X");
      boolean currentYLimitState=responseData[1].contains("Y");
      boolean currentZLimitState=responseData[1].contains("Z");
      boolean currentProbeState =responseData[1].contains("P");
      boolean currentDoorState  =responseData[1].contains("D");
      if(labelPriorState[23] != currentXLimitState){
        labelPreTexts[23]=(currentXLimitState?"X Limit On":"X Limit Off");
        labelPreState[23]=!labelPreState[23];
      }
      if(labelPriorState[24] != currentYLimitState){
        labelPreTexts[24]=(currentYLimitState?"Y Limit On":"Y Limit Off");
        labelPreState[24]=!labelPreState[24];
      }
      if(labelPriorState[25] != currentZLimitState){
        labelPreTexts[25]= (currentZLimitState?"Z Limit On":"Z Limit Off");
        labelPreState[25]=!labelPreState[25];
      }
      
      if(labelPriorState[26] != currentProbeState){
        labelPreTexts[26]=(currentProbeState?"probe ok":"probe bad");
        labelPreState[26]=!labelPreState[26];
      }
      if(labelPriorState[27] != currentDoorState){
        labelPreTexts[27]=(currentDoorState?"door ok":"door open");
        labelPreState[27]=!labelPreState[27];
      }
      
      priorStatusHadPn=true; 
    } else  {
       logNCon("UnKnown status label encounterd in chunk:"+chunks[ii]+"\n Am aborting.","handleStatusReport",10);
       timeNSay(String.format("status recieved as pipeBound |%s|",s.trim()));
       System.exit(2);
    }    
  }   
  /* activeState can be:   Idle, Run, Hold, Door, Home, Alarm, Check */
  activeState=chunks[0].split(",",2)[0];
  if(!activeState.equals(labelPreTexts[14])){
    msg="activeState="+activeState;
    //log.debug("msg="+msg);
    labelPreTexts[14]=activeState;
    //logNCon("setting |activeState|=|"+activeState+"|","handleStatusReport",12);
  }
  msg="end of handleStatusReport()";
  //logNCon(msg,"handleStatusReport",11);
} 
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleAlarmNError(String s){
  /**/if(5>alarmCount)log.debug("alarmCount="+alarmCount+" s="+s);
  boolean alarmIsSticky=false;
  String[] chunks=s.substring(1,s.length()-1).split("\\|",0);
  //logNCon("number of chunks = "+chunks.length,"handleAlarmNError",0);
  //for(int ii=0;ii<chunks.length;ii++){
  //  logNCon("\nchunks["+ii+"]="+chunks[ii],"handleAlarmNError",1);
  //  for(int jj=0;jj<chunks[ii].length();jj++){
  //    logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks[ii].charAt(jj),(int)chunks[ii].charAt(jj)),"handleAlarmNError",2);
  //  }  
  //}
  if(   (1==chunks.length)
     &&(s.startsWith("ALARM"))
    ){
    logNCon("have a full fledged ALARM","handleAlarmNError",10);
    activeState="Alarm";
    alarmIsSticky=true;
    String[] chunks0=s.split(":");
    //logNCon("number of chunks0 = "+chunks0.length,"handleAlarmNError",12);
    //for(int ii=0;ii<chunks0.length;ii++){
    //  logNCon("\n chunks0["+ii+"]="+chunks0[ii],"handleAlarmNError",13);
    //  //for(int jj=0;jj<chunks0[ii].length();jj++){
    //  //  logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks0[ii].charAt(jj),(int)chunks0[ii].charAt(jj)),"handleAlarmNError",17);
    //  //}
    //}
    try {
      labelPreTexts[22]=alarms[Integer.parseInt(chunks0[1])-1];
      log.debug("setting label22 2b alarms["+(Integer.parseInt(chunks0[1])-1)+"]                                   "+labelPreTexts[22]);
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",19);
      System.err.println("NumberFormatException: " + nfe.getMessage());
    }    
  }  
  if(   (1==chunks.length)
     &&(s.startsWith("error"))
    ){
    logNCon("have a full fledged \"error\"","handleAlarmNError",11);
    activeState="Alarm";
    String[] chunks0=s.split(":");
    //logNCon("number of chunks0 = "+chunks0.length,"handleAlarmNError",14);
    //for(int ii=0;ii<chunks0.length;ii++){
    //  logNCon("\n chunks0["+ii+"]="+chunks0[ii],"handleAlarmNError",15);
    //  for(int jj=0;jj<chunks0[ii].length();jj++){
    //    logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks0[ii].charAt(jj),(int)chunks0[ii].charAt(jj)),"handleAlarmNError",16);
    //  }
    //}
    try {
      labelPreTexts[22]=errors[Integer.parseInt(chunks0[1])-1];
      log.debug("setting label22 2b "+labelPreTexts[22]+" as errors["+(Integer.parseInt(chunks0[1])-1));
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",18);
      System.err.println("NumberFormatException: " + nfe.getMessage());
    }    
  }  
  for(int ii=1;ii<chunks.length;ii++){
    //log.debug("at chunks "+ii+" "+chunks[ii]);
    String[] responseData = chunks[ii].split(":",2);
    //log.debug("responseData[0]="+responseData[0]);
    //log.debug("responseData[1]="+responseData[1]);
    if(responseData[0].equals("MPos")){
      String[] pos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          mPos[jj]=Float.valueOf(pos[jj]);
        } catch (NumberFormatException nfe) {
           logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",3);
           System.err.println("NumberFormatException: " + nfe.getMessage());
        }
      }
      /* the Work Position   WPos bold, larger upper row of locations */
      msg=String.format("(%9.3f,",mPos[0]-gParams[activeWCO][0]);
      labelPreTexts[2]=msg;
      msg=String.format( "%9.3f,",mPos[1]-gParams[activeWCO][1]);
      labelPreTexts[10]=msg;
      msg=String.format( "%9.3f)",mPos[2]-gParams[activeWCO][2]);
      labelPreTexts[11]=msg;          

      /* the MPos plain, smaller lower row of locations */
      msg=String.format("(%9.3f,",mPos[0]);
      labelPreTexts[7]=msg;
      msg=String.format("%9.3f," ,mPos[1]);
      labelPreTexts[8]=msg;
      msg=String.format("%9.3f)" ,mPos[2]);
      labelPreTexts[9]=msg;
    } else 
    if(responseData[0].equals("WCO")){
      String[] wcos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          wco[jj]=Float.valueOf(wcos[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",4);
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(5);
        }
      }
    }  else
    if(responseData[0].equals("Ov")){
      String[] ovs = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          ov[jj]=Float.parseFloat(ovs[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",5);
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(8);
        }
      }
    } else
      if(responseData[0].equals("FS")){
      String[] nums = responseData[1].split(",",2);
      //log.debug("nums[0]="+nums[0]+" nums[1]="+nums[1]);
      try {
        String theFed=nums[0]+((-1==nums[0].indexOf('.')?" ":""));
        //log.debug("theFed="+theFed);
        feedRate=Float.valueOf(theFed);
        //label16.setText(String.format("   Feed: %5.0f",feedRate));
        msg=String.format("   Feed: %5.0f",feedRate);
        labelPreTexts[16]=msg;
        //logNCon("feedRate="+feedRate,"handleAlarmNError",6);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",7);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
      try {
        spindleSpeed=Integer.parseInt(nums[1]);
        /* label try 4 */
        //label18.setText(String.format("Spindle: %5d",spindleSpeed));
        msg=String.format("Spindle: %5d",spindleSpeed);
        labelPreTexts[18]=msg;
        //logNCon("spindleSpeed="+spindleSpeed,"handleAlarmNError",8);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"handleAlarmNError",9);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else 
    if(responseData[0].equals("Pn")){
      //logNCon("responseData[1]="+responseData[1],"handleAlarmNError",10);
    } else  {
       logNCon("UnKnown status label encounterd in chunk:"+chunks[ii]+"\n Am aborting.","handleAlarmNError",11);
       timeNSay(String.format("status recieved as pipeBound |%s|",s.trim()));
       System.exit(2);
    }
  }
  if(!alarmIsSticky){
  activeState=s.startsWith("Alarm")?"Alarm":"error";
  }
  if(s.startsWith("Alarm"))ports[grblIndex].write("?");
  //log.debug("@endOf handleAlarmNError");
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
/* this method reads the file and pushes the content to the arduino GRBL */
void handleFileBufferFillNPush(){
  //timeNSay("handleFileBufferFillNPush() numLinesSent="+numLinesSent+" numStreamingOKs="+numStreamingOKs+" numErrors="+numErrors);
  //timeNSay("h");
  String line="";
  String regex = "[0-9, /, /., /-]+";  /* used to look for lines which have only 3 numbers (as output by Rhino) 1.000, 3.223,-1.3   */
  DecimalFormat df=new DecimalFormat("#.###"); /* this gives the desired format of not including needless leading spaces, or trailing zeros */
  int numEPROMs=ePROM_reads_or_writes.length;
  if(  (0< numLinesSent)
     &&(numLinesSent==(numStreamingOKs+numErrors))
  ){
    streaming=false;
    log.debug("done       streaming  numLinesSent="+numLinesSent+" vs (numStreamingOKs+numErrors)="+numStreamingOKs+"+"+numErrors+"="+(numStreamingOKs+numErrors));
    msg="streaming completed on "+numLinesSent+" gCode rows with "+numErrors+" errors";
    logNCon(msg,"handleFileBufferFillNPush",0);
    labelPreTexts[22]=msg;
    if(  (0==numErrors)
       &&(0!=priorNumErrors)
      ){
      logNCon("pre setting label22 colorscheme green","handleFileBufferFillNPush",1);
      label22.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      logNCon("post setting label22 colorscheme green","handleFileBufferFillNPush",2);
    }  
    numLinesSent=0;
    numStreamingOKs=0;
    numErrors=0;
  } else { 
    //log.debug("Seem to be streaming  numLinesSent="+numLinesSent+" vs (numStreamingOKs+numErrors)="+numStreamingOKs+"+"+numErrors+"="+(numStreamingOKs+numErrors));
    try {
      float lastX=0.0;
      float lastY=0.0;
      redBufferUsed=0;
      /* read line by line until the number of bytes is greater than 128
       * then push as many as will fit into the potentially partilly filled grbl buffer */
      /* This loads up the redBuffer with enough lines to be morehat than enough bytes to fill the entire grbl buffer  */      
      while(  (redBufferUsed < bufferSize)
            &&((line = br.readLine()) != null)
      ){
        numLinesRead++;
        /**/log.debug("lineOrig=|"+line+"| which has length()="+line.length());
        //for(int ii=0;ii<line.length();ii++){
        //  log.debug(String.format("%3d %3d %c",ii,(int)line.charAt(ii),line.charAt(ii)));
        //}
        //logNCon("lineOrig=|"+line+"|","handleFileBufferFillNPush",3);
        //log.debug("       pipe bound line as input=|"+line+"|");
        line=line.trim();
        if(line.contains(";"))line=line.substring(0,line.indexOf(";"));
        if(line.contains("("))line=line.substring(0,line.indexOf("("));
        //log.debug("pipe bound comment purged line =|"+line+"|");
        //String modLine=line.replaceAll("\\(.*\\)", "").replaceAll(" ","").toUpperCase()+"\n";
        String modLine=line.replaceAll("\\(.*\\)", "").replaceAll(" ","").replaceAll(crCharString,"").replaceAll(lfCharString,"").toUpperCase();
        //log.debug("\n\n"+numLinesRead+" initial     |modLine|=|"+modLine+"| which has length="+modLine.length());
        //for(int ii=0;ii<modLine.length();ii++){
        //  log.debug(String.format("%3d %3d %c",ii,(int)modLine.charAt(ii),modLine.charAt(ii)));
        //}
        if(0<modLine.length()){
          /* add some parsing to make coma seperated, otherwize naked, XYZ tripples conform to GRBL GCode */
          if (modLine.matches(regex)) {
            //log.debug("we have only numbers, commas, and/or decimalpoints");
            String[] coords=modLine.split(",");
            if(2==coords.length){
              //log.debug("we will treat this as an XYZ tripplet");
              modLine=String.format("G1X%sY%s",
                df.format(Double.parseDouble(coords[0])+((0.0==angleYOffOrthogoality)?0.0:(sinAngleYOffOrthogonality*Double.parseDouble(coords[1])))),
                df.format(Double.parseDouble(coords[1]))
              );
              //modLine=String.format("G1X%.3fY%.3fZ%.3f",Float.parseFloat(coords[0]+(sinAngleYOffOrthogonality*Float.parseFloat(coords[1]))),Float.parseFloat(coords[1]),Float.parseFloat(coords[2]));
              //log.debug("538 XYZ modded  |modLine|=|"+modLine+"| which has length="+modLine.length());
            } else
            if(3==coords.length){
              //log.debug("we will treat this as an XYZ tripplet");
              modLine=String.format("G1X%sY%sZ%s",
                df.format(Double.parseDouble(coords[0])+((0.0==angleYOffOrthogoality)?0.0:(sinAngleYOffOrthogonality*Double.parseDouble(coords[1])))),
                df.format(Double.parseDouble(coords[1])),
                df.format(Double.parseDouble(coords[2]))
              );
              //modLine=String.format("G1X%.3fY%.3fZ%.3f",Float.parseFloat(coords[0]+(sinAngleYOffOrthogonality*Float.parseFloat(coords[1]))),Float.parseFloat(coords[1]),Float.parseFloat(coords[2]));
              //log.debug("538 XYZ modded  |modLine|=|"+modLine+"| which has length="+modLine.length());
            }
          } else
          if(0.0!=angleYOffOrthogoality){
            //log.debug("nonOrthogonalMachine |Alpha_containg_row|=|"+modLine+"|");
            /* the Y value can be needed in calculations to refine X, even if it is not present in the current Gcode row */
            if(modLine.contains("Y")){
              lastY=teaseValue(modLine,'Y');
              //log.debug(String.format("lastY=%20.12f",lastY));
              /* the X value will be used in calculations only if present in this line */
              if(modLine.contains("X")){
                lastX=teaseValue(modLine,'X');
                //log.debug(String.format("lastX=%20.12f",lastX));
              }
            }
            if(  modLine.contains("G0X")
               ||modLine.contains("G0Y")
               ||modLine.contains("G1X")
               ||modLine.contains("G1Y")
              ){
              //log.debug("G0X or G0Y or G1X or G1Y");
              if(modLine.contains("Y")){
                StringBuilder sb = new StringBuilder();
                if(modLine.contains("X")){
                  sb.append(modLine.substring(0,1+modLine.indexOf('X')));
                  //log.debug("sb for modline.contains(\"X\")  0 sb="+sb);
                  sb.append(String.format("%sY%s",
                    df.format(lastX+(sinAngleYOffOrthogonality*lastY)),
                    df.format(lastY                                  )
                  ));
                  //log.debug("sb for modline.contains(\"X\")  1 sb="+sb);
                } else {
                  sb.append(modLine.substring(0,modLine.indexOf('Y'))+"X");
                  //log.debug("sb for !modline.contains(\"X\") 2 sb="+sb);
                  sb.append(String.format("%sY%s",
                    df.format(lastX+(sinAngleYOffOrthogonality*lastY)),
                    df.format(lastY                                  )
                  ));
                  //log.debug("sb for !modline.contains(\"X\") 3 sb="+sb);
                }
                if(modLine.contains("Z")){
                  sb.append(modLine.substring(modLine.indexOf('Z')));
                  //log.debug("sb for modline.contains(\"Z\")  4 sb="+sb);
                }
                modLine=sb.toString();
              } //else {
              //  log.debug("noY leave full modLine unchanged");
              //}
            }// else {
            //  log.debug("neither G0 nor G1, (with XorY) so pass on unchanged");
            //}
          }
          if(0<modLine.length()){
            redBuffer.add(modLine);
            //log.debug("|modLine|=|"+modLine+"| which has lengh "+modLine.length());
            redBufferUsed+=modLine.length()+1;
          }  
          rowCounter++;
          msg=rowCounter+" of "+numRows+" read";
          labelPreTexts[22]=msg;
          //log.debug("post 562 msg="+msg+" redBufferUsed="+redBufferUsed);
        }
      }
      //logNCon("redBuffer has "+redBuffer.size()+" rows","handleFileBufferFillNPush",4);
      //for(int ii=0;ii<redBuffer.size();ii++)logNCon(
      //  String.format(
      //    "%2d %3d %3d %s",          ii,
      //    redBufferUsed,
      //    redBuffer.get(ii).toString().length(),
      //    redBuffer.get(ii).toString().substring(0,redBuffer.get(ii).toString().length()-1)
      //  )
      //);
      
      /* bean count the number of bytes still filling the grbl buffer
       * by accounting for the lengths of the rows processed.
       * The knowledge of "been processed" is gleened from grbl sending either an "ok" or and error:N
       * for each row pulled in from the buffer and parsed into it's look-ahead scheme
       */
      while(numRowsConfirmedProcessed<(numStreamingOKs+numErrors)){
        /*logNCon(String.format("numRowsConfirmedProcessed=%6d vs %6d sent.  grblBufferUsed=%3d %s",numRowsConfirmedProcessed,(numStreamingOKs+numErrors),grblBufferUsed,sentLineLengths.toString()),"handleFileBufferFillNPush",5);*/
        //logNCon(String.format("numRowsConfirmedProcessed=%6d vs %6d sent",numRowsConfirmedProcessed,(numStreamingOKs+numErrors)),"handleFileBufferFillNPush",5);
        grblBufferUsed-=sentLineLengths.get(0);
        sentLineLengths.remove(0);
        numRowsConfirmedProcessed+=1;
      }
      
      /* pull rows off the head of the redBuffer, and push them into the grblBuffer.
       * Stop when one more row would overflow the grblBuffer 
       * After having read the last row of the file, 
       * and after having sent that last row to the buffer, redBuffer.size will be 0
       */
      if(0<redBuffer.size()){ 
        String nextUp=redBuffer.get(0).toString().toUpperCase();
        int nextUpLength=nextUp.length()+1;
        //log.debug("redBuffer.size()="+redBuffer.size()+" with redBufferUsed="+redBufferUsed+" nextUp="+nextUp);
        while ((grblBufferUsed+nextUpLength)<=bufferSize){
          ports[grblIndex].write(nextUp+lf); 
          if(checkGCodeMode){
            if(nextUp.startsWith("G10P0")){
              nextUp="G10P"+(activeWCO+1)+nextUp.substring(5);
            }
            log1.debug(nextUp);
          }
          grblBufferUsed+=nextUpLength;
          sentLineLengths.add(nextUpLength);
          numLinesSent+=1;
          //log.debug(String.format(
          //  "sent %3d bytes of %3d which will leave %3d bytes among the remaining %2d rows. nextUpLength=%d |%s|",
          //  nextUpLength,
          //  redBufferUsed,
          //  redBufferUsed-nextUpLength,
          //  redBuffer.size()-1,
          //  nextUp.length(),
          //  nextUp
          //  )
          //);
          boolean haveEPROM=false;
          for(int ii=0;ii<numEPROMs;ii++){
            if(nextUp.contains(ePROM_reads_or_writes[ii]))haveEPROM=true;
          }
          if(haveEPROM){
            delay(epromDelay);
            //log.debug("have one or more of the eprom read-or-write commands, delay "+epromDelay+" milliseconds to prevent data corruption or loss");
          } //else {
            //log.debug("nextUp="+nextUp+" had none of the eprom read-or-write strings");
          //} 
          redBufferUsed-=nextUpLength;
          redBuffer.remove(0);
          if(0<redBuffer.size()){
            nextUp=redBuffer.get(0).toString();
            nextUpLength=nextUp.length()+1;
          } else { /* the else will happen at the end of the file */
            nextUpLength=bufferSize+1;
          }
        }
      }
      //timeNSay("numLinesSent="+numLinesSent+" grblBufferUsed="+grblBufferUsed+" numStreamingOKs="+numStreamingOKs+" numErrors="+numErrors);
    } catch (IOException e) {
       System.err.format("IOException: %s%n", e);
    }
  }
  //log.debug("@endOf ");
}



/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleMsg(String s){
  /**/logNCon("gcode parser state reflects "+s+" and s.substrng(5)="+s.substring(5,s.length()-1)+" from s.length()="+s.length(),"handleMsg",0);
  //lastMessage=s;
  /* label try 3 */
  //log.debug("526");
  //label15.setText(lastMessage);
  labelPreTexts[15]=s.substring(5,s.length()-1);
  if(!activeState.equals("Alarm")){
    log.debug("!activeState.equals(\"Alarm\") so PreText[22]=\"\" activeState="+activeState);
    //label22.setText(""); 
    labelPreTexts[22]=""; 
    //log.debug("post sending label22 nada");
  } else {
    log.debug("activeState.equals(\"Alarm\") so leave label22 unchanged");
  }
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleNumberParams(String s){
  //logNCon("s="+s,"handleNumberParams",0);
  int index=-1;
  String[] chunks=s.substring(1,s.length()-1).split(":",0);
  String[] nums = chunks[1].split(",",3);
  if(chunks[0].charAt(0)=='G'){
    //logNCon("chunks[0]="+chunks[0]+" num from "+chunks[0].substring(1,3),"handleNumberParams",1);
    int num =-1;
    try {
      num=Integer.parseInt(chunks[0].substring(1,3));
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage(),"handleNumberParams",2);
      System.err.println("NumberFormatException: " + nfe.getMessage());
      System.exit(6);
    }
    switch (num) {
      case 54: index=0;
        break;
      case 55: index=1;
        break;
      case 56: index=2;
        break;
      case 57: index=3;
        break;
      case 58: index=4;
        break;
      case 59: index=5;
        break;
      case 28: index=6;
        break;
      case 30: index=7;
        break;
      case 92: index=8;
        break;
      default: logNCon("UnKnown gcode GXX parameter where XX=="+num+"\n Am aborting.","handleNumberParams",3);
        timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
        System.exit(4);
    }   
  } else 
  if(chunks[0].equals("TLO")){
    index=9;
  } else   
  if(chunks[0].equals("PRB")){
    index=10;
    //logNCon("chunks[2]=|"+chunks[2]+"|","handleNumberParams",4);
    lastProbeGood=('1'==chunks[2].charAt(0));                    
  } else {
    logNCon("UnKnown gcode parameter in "+s+"\n Am aborting.","handleNumberParams",5);
    timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
    System.exit(3);
  }
  //logNCon("index="+index,"handleNumberParams",6);
  int limit=(9==index?1:3);
  for(int jj=0;jj<limit;jj++){
    try {
      gParams[index][jj]=Float.parseFloat(nums[jj]);
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage(),"handleNumberParams",7);
      System.err.println("NumberFormatException: " + nfe.getMessage());
      System.exit(6);
    }
  }
  seeHashtagParams=true;
  //logNCon("got to end of s.charAt(0)=='['  if","handleNumberParams",8);
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSaysHello(String s){
  /* initial hellow from grbl.  send the $# command to get the eprom parameters */
  frameTitle="GRBL Gui connected     port="+portNames[grblIndex]+"   "+s.substring(0,s.indexOf("[")-2);
  timeNSay("grbl said hello");
  button22.setText("go2 "+(verboseOutput ?"sparse ":"verbose ")+"output");
  
  /* prompt for the stored eprom variables */
  portMsg="$#\n";
  ports[grblIndex].write(portMsg);
  //logNCon("port.wrote("+portMsg+")","handleGrblSaysHello",0);

  /* prompt for the stored settings */
  portMsg="$$\n";
  ports[grblIndex].write(portMsg);
  //logNCon("port.wrote("+portMsg+")","handleGrblSaysHello",1);
  
  ///* if uncommentd, this will prompt the help response. see https://github.com/gnea/grbl/wiki/Grbl-v1.1-Commands */
  //portMsg="$\n";
  //ports[grblIndex].write(portMsg);
  //logNCon("port.wrote("+portMsg+")","handleGrblSaysHello",2);
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleStreamingError(String s){
  numErrors+=1;
  try {
    int num=Integer.parseInt(s.substring(s.indexOf(":")+1));
    log.debug("streaming error num="+num);
    //label22.setText(s.startsWith("Alarm")?alarms[num-1]:errors[num-1]);
    msg=s.startsWith("Alarm")?alarms[num-1]:errors[num-1];
    labelPreTexts[22]=msg;
    String err=String.format(
      "Gcode row %6d has %s[%2d]=%s",
      numRowsConfirmedProcessed+1,      
      (s.startsWith("Alarm")?"Alarm":"error"),
      (num),
      (s.startsWith("Alarm")?alarms[num-1]:errors[num-1])
    );
    logNCon(err,"handleStreamingError",0);
  } catch (NumberFormatException nfe) {
    logNCon("NumberFormatException: " + nfe.getMessage(),"handleStreamingError",1);
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
}  
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleCleanupOfNoMorePn(String s){
  logNCon("cleanup of the Pn affected lables due to expiration of a Pn:","handleCleanupOfNoMorePn",0);  
  // label22.setText(""); /* remove any error or Alarm text */
  labelPreTexts[22]="";

  // label23.setText("X Limit Off");
  // label24.setText("Y Limit Off");
  // label25.setText("Z Limit Off");
  // label26.setText("Probe Off"  );
  // label27.setText("Door Closed");
  labelPreTexts[23]="X Limit Off";
  labelPreTexts[24]="Y Limit Off";
  labelPreTexts[25]="Z Limit Off";
  labelPreTexts[26]="Probe Off"  ;
  labelPreTexts[27]="Door Closed";

  labelPreState[23]=false;
  labelPreState[24]=false;
  labelPreState[25]=false;
  labelPreState[26]=false;
  labelPreState[27]=false;

  // label23.setLocalColorScheme(GCScheme.SCHEME_9);
  // label24.setLocalColorScheme(GCScheme.SCHEME_9);
  // label25.setLocalColorScheme(GCScheme.SCHEME_9);
  // label26.setLocalColorScheme(GCScheme.SCHEME_9);
  // label27.setLocalColorScheme(GCScheme.SCHEME_9);

  // label23.setOpaque(false);
  // label24.setOpaque(false);
  // label25.setOpaque(false);
  // label26.setOpaque(false);
  // label27.setOpaque(false);

  priorStatusHadPn=false; 
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSettingCollection(String s){
  //logNCon("s="+s+" with grblSettingIndices.length="+grblSettingIndices.length,"handleGrblSettingCollection",0);
  String[] chunks=s.substring(1).split("=",2);
  //for(int ii=0;ii<chunks.length;ii++)logNCon(String.format("chunk[%d]=%s",ii,chunks[ii]),"handleGrblSettingCollection",1); 
  try {
    int num=Integer.parseInt(chunks[0]);
    for(int ii=0;ii<grblSettingIndices.length;ii++){
       if(num==grblSettingIndices[ii])grblSettings[ii]=chunks[1]; 
    }
  } catch (NumberFormatException nfe) {
    logNCon("NumberFormatException: " + nfe.getMessage(),"handleGrblSettingCollection",2);
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
  seeGrblParams=true;
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
int portMatcher(Serial p){
  String target=String.format("%s",p);
  //log.debug("initializing which port is grbl. target="+target);
  int match=-1;
  for(int ii=0;ii<portNames.length;ii++){
    if(false==portsBusy[ii]){
      //log.debug(String.format("%2d %-33s vs %-33s",ii,serialThisNames[ii],target));
      if(serialThisNames[ii].equals(target)){
        //log.debug("match");
        match=ii;
      }
    } //else {
    //  log.debug("no match");
    //}  
  }
  return(match);
}      
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
