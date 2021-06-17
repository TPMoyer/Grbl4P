/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleAlarmNError(String s){
  //log.debug("inside handleAlarmNError s="+s);
  String[] chunks=s.substring(1,s.length()-1).split("\\|",0);
  //logNCon("number of chunks = "+chunks.length);
  //for(int ii=0;ii<chunks.length;ii++){
  //  logNCon("\n"+chunks[ii]);
  //  for(int jj=0;jj<chunks[ii].length();jj++){
  //    logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks[ii].charAt(jj),(int)chunks[ii].charAt(jj)));
  //  }  
  //}
  for(int ii=1;ii<chunks.length;ii++){
    /**/log.debug("at chunks "+ii+" "+chunks[ii]);
    String[] responseData = chunks[ii].split(":",2);
    //log.debug("responseData[0]="+responseData[0]);
    //log.debug("responseData[1]="+responseData[1]);
    if(responseData[0].equals("MPos")){
      String[] pos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          mPos[jj]=Float.valueOf(pos[jj]);
        } catch (NumberFormatException nfe) {
           logNCon("NumberFormatException: " + nfe.getMessage());
           System.err.println("NumberFormatException: " + nfe.getMessage());
        }
      }
      /* label try 4 */
      /* the WPos bold, larger upper row of locations */
      label2 .setText(String.format("(%9.3f,",mPos[0]-wco[0]));
      label10.setText(String.format("%9.3f," ,mPos[1]-wco[1]));
      label11.setText(String.format("%9.3f)" ,mPos[2]-wco[2]));
      
      /* the MPos plain, smaller lower row of locations */
      label7.setText(String.format("(%9.3f,",mPos[0]));
      label8.setText(String.format("%9.3f," ,mPos[1]));
      label9.setText(String.format("%9.3f)" ,mPos[2]));
    } else 
    if(responseData[0].equals("WCO")){
      String[] wcos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          wco[jj]=Float.valueOf(wcos[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage());
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(5);
        }
      }
      //label2.setText(String.format("(%9.3f,%9.3f,%9.3f)",mPos[0],mPos[1],mPos[2]));
      //label2.setTextBold();
    }  else
    if(responseData[0].equals("Ov")){
      String[] ovs = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          ov[jj]=Float.parseFloat(ovs[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage());
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
        /* label try 4 */
        label16.setText(String.format("   Feed: %5.0f",feedRate));
        //logNCon("feedRate="+feedRate);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage());
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
      try {
        spindleSpeed=Integer.parseInt(nums[1]);
        /* label try 4 */
        label18.setText(String.format("Spindle: %5d",spindleSpeed));
        //logNCon("spindleSpeed="+spindleSpeed);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage());
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else 
    if(responseData[0].equals("Pn")){
      //logNCon("responseData[1]="+responseData[1]);
    } else  {
       logNCon("UnKnown status label encounterd in chunk:"+chunks[ii]+"\n Am aborting.");
       timeNSay(String.format("status recieved as pipeBound |%s|",s.trim()));
       System.exit(2);
    }
  }
  activeState=s.startsWith("Alarm")?"Alarm":"error";
  /* label try 4 */
  label3.setText("Active State:"+activeState);
  label3.setLocalColorScheme(GCScheme.SCHEME_10);
  label3.setOpaque(true);
  //label3.setTextBold();
  if(s.startsWith("Alarm"))port.write("?");
  //log.debug("@endOf handleAlarmNError");
}
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
void serialEvent(Serial p){
  
  String s = p.readStringUntil('\n').trim();
  /* Initial peek at the stream of data which enters this method 
   * for(int ii=0;ii<s.length();ii++)logNCon(String.format("%2d %c %3d",ii,s.charAt(ii),(int)s.charAt(ii))); 
   * The above show-every-character for() has become legacy code
   */
  if(0<s.length()){  
    //logNCon("serialEvent have s="+s);
    //if(-1!=s.indexOf('>'))s=s.substring(0,s.indexOf('>')); 
    if(!streaming){
      if(  (5>idleCount)
         &&(5>alarmCount)
        ){ 
        log.debug(String.format("see |%s|",s.trim()));
      }
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
    if(  (!streaming)
       &&(  verboseOutput
          ||('<'!=s.charAt(0))
         ) 
       &&('$'!=s.charAt(0)) /* do not push thru the grblParams,    they are pretty-printed post collection of the full set */  
       &&('#'!=s.charAt(0)) /* do not push thru the hashtagParams, they are pretty-printed post collection of the full set */
       
      ){ 
      timeNSay(String.format("see |%s|",s.trim()));
       //timeNSay(String.format("serialEvent got pipeBound |%s|",s.trim()));
      //timeNSay(String.format("serialEvent with "+(priorStatusHadPn?"true ":"false")+"==priorStatusHadPn  got pipeBound |%s|",s.trim()));
    }
    /* check for ok or error to have the numbers fed into the streaming handler be correct */
    if(s.equals("ok") ){
      if(streaming)numOKs+=1;
      else {
        label22.setText(""); /* remove any error or Alarm text */    /* label try 0 */
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
    ){
      if(streaming) handleStreamingError(s);
      else handleAlarmNError(s); 
    }
    
    if(streaming && bufferedReaderSet){
      //logNCon("streaming "+s);
      handleFileBufferFillNPush();
    }
    
    if(s.charAt(0)=='<'){
      handleStatusReport(s); /* the response to the 5hz status report query needed extensive handling */
    } else
    if(s.startsWith("[GC")){  /* currently no action taken upon recieving this */
      logNCon("got [GC.   reflects "+s);
    } else
    if(s.startsWith("[HLP")){ /* currently no action taken upon recieving this */
      logNCon("got [HLP.   reflects "+s);
    } else
    if(s.startsWith("[VER")){ /* currently no action taken upon recieving this */
      logNCon("got [VER.   reflects "+s);
    } else
    if(s.startsWith("[OPT")){ /* currently no action taken upon recieving this */
      logNCon("got [VER.   reflects "+s);
    } else
    if(s.startsWith("[MSG")){ /* currently no action taken upon recieving this */
      handleMsg(s);
    }else
    if(  s.charAt(0)=='['){ /* the assembly of these into the (float[11][3]+lastProbeGood) needed extensive handling  */
      handleNumberParams(s);
    }  else
    if(s.startsWith("Grbl")){
      seeGrbl=true;
      handleGrblSaysHello(s);
    } else    
    if(s.startsWith("$")){ /* collect these grbl parameters for use in the GUI  */
      handleGrblSettingCollection(s);
    } else
    if(s.startsWith("<Idle")){ /* currently no action taken upon recieving this */
      /* nada to to */
    } 
    /* this is not part of the above if{}else if{} stack.  This is an independent if */
    if(  (true==priorStatusHadPn)
       &&(!s.contains("Pn:"))
      ){
      handleCleanupOfNoMorePin(s);
    }
  }
} 

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
/* this method reads the file and pushes the content to the arduino GRBL */
void handleFileBufferFillNPush(){
  //timeNSay("handleFileBufferFillNPush() numLinesSent="+numLinesSent+" numOks="+numOKs+" numErrors="+numErrors);
  //timeNSay("h");
  String line="";
  String regex = "[0-9, /, /., /-]+";  /* used to look for lines which have only 3 numbers (as output by Rhino) 1.000, 3.223,-1.3   */
  DecimalFormat df=new DecimalFormat("#.#");
  if(  (0< numLinesSent)
     &&(numLinesSent==(numOKs+numErrors))
  ){
    streaming=false;
    String msg="streaming completed on "+numLinesSent+" gCode rows with "+numErrors+" errors";
    logNCon(msg);
    /* label try 1 */
    label22.setText(msg);
    if(0==numErrors)label22.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    log.debug("post label22 mod");    
  } else {  
    try {
      /* read line by line until the number of bytes is greater than 128
       * then push as many as will fit into the potentially partilly filled grbl buffer */
       
      /* This loads up the redBuffer with enough lines to be more than enough bytes to fill the entire grbl buffer  */
      while(  (redBufferUsed < bufferSize)
            &&((line = br.readLine()) != null)
      ){
        log.debug("lineOrig=|"+line+"|");
        //logNCon("lineOrig=|"+line+"|");
        //log.debug("       pipe bound line as input=|"+line+"|");
        if(line.contains(";"))line=line.substring(0,line.indexOf(";"));
        //log.debug("pipe bound comment purged line =|"+line+"|");
        //String modLine=line.replaceAll("\\(.*\\)", "").replaceAll(" ","").toUpperCase()+"\n";
        String modLine=line.replaceAll("\\(.*\\)", "").replaceAll(" ","").toUpperCase();
        //log.debug("initial     pipe bound modLine =|"+modLine+"|");
        if (modLine.matches(regex)) {
          //log.debug("we have only numbers, commas, and/or decimalpoints");
          String[] coords=modLine.split(",");
          if(3==coords.length){
            //log.debug("we will treat this as an XYZ tripplet");
            modLine="G1X"+df.format(Double.parseDouble(coords[0]))+"Y"+df.format(Double.parseDouble(coords[1]))+"Z"+df.format(Double.parseDouble(coords[2]));
            //log.debug("XYZ modded  pipe bound modLine =|"+modLine+"|");
          }  
        } //else {
        //  log.debug("some Alphas seen");
        //}
        /* add some parsing to make XYZ tripples conform to GRBL GCode */
        if(0<modLine.length()){
          redBuffer.add(modLine+"\n");
          redBufferUsed+=modLine.length()+1;
        }  
        rowCounter++;
        label22.setText(rowCounter+" of "+numRows+" read");
      }
      //logNCon("redBuffer has "+redBuffer.size()+" rows");
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
      while(numRowsConfirmedProcessed<(numOKs+numErrors)){
        //logNCon(String.format("numRowsConfirmedProcessed=%6d vs %6d %3d %2d",numRowsConfirmedProcessed,(numOKs+numErrors),grblBufferUsed,sentLineLengths.size()));
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
        String nextUp=redBuffer.get(0).toString();
        int nextUpLength=nextUp.length();
        while ((grblBufferUsed+nextUpLength)<=bufferSize){
          port.write(nextUp);
          grblBufferUsed+=nextUpLength;
          sentLineLengths.add(nextUpLength);
          numLinesSent+=1;
          /**/log.debug(String.format(
          /**/  "sent %3d bytes of %3d which will leave %3d bytes among the remaining %2d rows. |%s|",
          /**/  nextUpLength,
          /**/  redBufferUsed,        
          /**/  redBufferUsed-nextUpLength,
          /**/  redBuffer.size()-1,
          /**/  redBuffer.get(0).toString().substring(0,redBuffer.get(0).toString().length()-1)        
          /**/  )
          /**/);
          redBufferUsed-=nextUpLength;
          redBuffer.remove(0);
       
          if(0<redBuffer.size()){
            nextUp=redBuffer.get(0).toString();
            nextUpLength=nextUp.length();
          } else { /* the else will happen at the end of the file */
            nextUpLength=bufferSize+1;
          }      
        }
      }
      //timeNSay("numLinesSent="+numLinesSent+" grblBufferUsed="+grblBufferUsed+" numOks="+numOKs+" numErrors="+numErrors);
    
    } catch (IOException e) {
       System.err.format("IOException: %s%n", e);
    }
  } 
} 

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleStatusReport(String s){ /* the response to the 5hz status report query */
  String[] chunks=s.substring(1,s.length()-1).split("\\|",0);
  //logNCon("number of chunks = "+chunks.length);
  //for(int ii=0;ii<chunks.length;ii++){
  //  logNCon("\n"+chunks[ii]);
  //  for(int jj=0;jj<chunks[ii].length();jj++){
  //    logNCon(String.format("%2d %2d %c %3d",ii,jj,chunks[ii].charAt(jj),(int)chunks[ii].charAt(jj)));
  //  }  
  //}
  for(int ii=1;ii<chunks.length;ii++){
    String[] responseData = chunks[ii].split(":",2);
    if(responseData[0].equals("MPos")){
      //log.debug("MPos");
      String[] pos = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          mPos[jj]=Float.valueOf(pos[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage());
          System.err.println("NumberFormatException: " + nfe.getMessage());
        }
      }
      /* label try 1 */
      /* the WPos bold, larger upper row of locations */
      label2 .setText(String.format("(%9.3f,",mPos[0]-wco[0]));
      label10.setText(String.format( "%9.3f,",mPos[1]-wco[1]));
      label11.setText(String.format( "%9.3f)",mPos[2]-wco[2]));
      
      /* the MPos plain, smaller lower row of locations */
      label7.setText(String.format("(%9.3f,",mPos[0]));
      label8.setText(String.format( "%9.3f,",mPos[1]));
      label9.setText(String.format( "%9.3f)",mPos[2]));
    } else 
    if(responseData[0].equals("FS")){
      //log.debug("FS");
      String[] nums = responseData[1].split(",",2);
      try {
        feedRate=Float.valueOf(nums[0]);
        /* label try 2 */
        //log.debug("2.0");
        String aaa=String.format("%4.0f",feedRate);
        //log.debug("2.0 "+aaa);
        label16.setText(String.format("   Feed: %5.0f",feedRate));
        //logNCon("feedRate="+feedRate);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage());
        System.err.println("NumberFormatException: " + nfe.getMessage());
        log.debug("NumberFormatException: " + nfe.getMessage());
      }
      try {
        spindleSpeed=Integer.parseInt(nums[1]);
        /* label try 2 */
        //log.debug("2.1");
        label18.setText(String.format("Spindle: %5d",spindleSpeed));
        //logNCon("spindleSpeed="+spindleSpeed);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage());
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else 
    if(responseData[0].equals("F")){
      //log.debug("F");
      try {
        feedRate=Float.valueOf(responseData[1]);
        /* label try 2 */
        String aaa=String.format("%4.0f",feedRate);
        //log.debug("2.2 "+aaa);
        label16.setText(String.format("   Feed: %5.0f",feedRate));
        //logNCon("feedRate="+feedRate);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage());
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else
    if(responseData[0].equals("Ov")){
      //log.debug("Ov");
      String[] ovs = responseData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          ov[jj]=Float.parseFloat(ovs[jj]);
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage());
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
        } catch (NumberFormatException nfe) {
          logNCon("NumberFormatException: " + nfe.getMessage());
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(5);
        }
      }
      //label2.setText(String.format("(%9.3f,%9.3f,%9.3f)",mPos[0],mPos[1],mPos[2]));
    } else
    if(responseData[0].equals("Bf")){
      //log.debug("Bf");
      String[] bf = responseData[1].split(",",2);
      //log.debug("number of available blocks in the planner buffer ="+bf[0]);
      //log.debug("number of available bytes in the serial RX buffer="+bf[1]);
    } else
    if(responseData[0].equals("Pn")){
      //log.debug("Pn");
      /* did not put indicators on GUI for hold pin, soft-reset pin, or cycle-start pin */
      /* label try 2 */
      log.debug("2.3");
      label23.setText(responseData[1].contains("X")?"X Limit On":"X Limit Off");
      label24.setText(responseData[1].contains("Y")?"Y Limit On":"Y Limit Off");
      label25.setText(responseData[1].contains("Z")?"Z Limit On":"Z Limit Off");
      label26.setText(responseData[1].contains("P")?"Probe On"  :"Probe Off"  );
      label27.setText(responseData[1].contains("D")?"Door Open" :"Door Closed");
      
      label23.setLocalColorScheme(responseData[1].contains("X")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label24.setLocalColorScheme(responseData[1].contains("Y")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label25.setLocalColorScheme(responseData[1].contains("Z")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label26.setLocalColorScheme(responseData[1].contains("P")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label27.setLocalColorScheme(responseData[1].contains("D")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label23.setOpaque(responseData[1].contains("X"));
      label24.setOpaque(responseData[1].contains("Y"));
      label25.setOpaque(responseData[1].contains("Z"));
      label26.setOpaque(responseData[1].contains("P"));
      label27.setOpaque(responseData[1].contains("D"));
      
      priorStatusHadPn=true; 
    } else  {
       logNCon("UnKnown status label encounterd in chunk:"+chunks[ii]+"\n Am aborting.");
       timeNSay(String.format("status recieved as pipeBound |%s|",s.trim()));
       System.exit(2);
    }    
  }   
  /* activeState can be:   Idle, Run, Hold, Door, Home, Alarm, Check */
  String priorActiveState=activeState;
  activeState=chunks[0].split(",",2)[0];
  /* label try 3 */
  //log.debug("3.0");
  label3.setText("Active State:"+activeState);
  if(  (  priorActiveState.equals("Alarm")
        ||priorActiveState.equals("error")
       ) 
     &&(!activeState.equals("Alarm"))
    ){
    /* label try 3 */
    //log.debug("3.1");
    label3.setLocalColorScheme(GCScheme.SCHEME_9);
    label3.setOpaque(false);
  } else 
  if(  (!priorActiveState.equals("Alarm"))
     &&(activeState.equals("Alarm"))
  ){
    /* label try 3 */
    //log.debug("3.2");
    label3.setLocalColorScheme(GCScheme.SCHEME_10);
    label3.setOpaque(true);
  }
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleMsg(String s){
  //logNCon("gcode parser state reflects "+s);
  lastMessage=s;
  /* label try 3 */
  log.debug("3.4");
  label15.setText(lastMessage);
  if(!activeState.equals("Alarm")){
    label22.setText(""); 
  }
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleNumberParams(String s){
  //logNCon("s="+s);   
  int index=-1;
  String[] chunks=s.substring(1,s.length()-1).split(":",0);
  String[] nums = chunks[1].split(",",3);
  if(chunks[0].charAt(0)=='G'){
    //logNCon("chunks[0]="+chunks[0]+" num from "+chunks[0].substring(1,3));
    int num =-1;
    try {
      num=Integer.parseInt(chunks[0].substring(1,3));
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage());
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
      default: logNCon("UnKnown gcode GXX parameter where XX=="+num+"\n Am aborting.");
        timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
        System.exit(4);
    }   
  } else 
  if(chunks[0].equals("TLO")){
    index=9;
  } else   
  if(chunks[0].equals("PRB")){
    index=10;
    //logNCon("chunks[2]=|"+chunks[2]+"|");
    lastProbeGood=('1'==chunks[2].charAt(0));                    
  } else {
    logNCon("UnKnown gcode parameter in "+s+"\n Am aborting.");
    timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
    System.exit(3);
  }
  //logNCon("index="+index);
  int limit=(9==index?1:3);
  for(int jj=0;jj<limit;jj++){
    try {
      gParams[index][jj]=Float.parseFloat(nums[jj]);
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage());
      System.err.println("NumberFormatException: " + nfe.getMessage());
      System.exit(6);
    }
  }
  seeHashtagParams=true;
  //logNCon("got to end of s.charAt(0)=='['  if");
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSaysHello(String s){
  /* initial hellow from grbl.  send the $# command to get the eprom parameters */
  frameTitle="GRBL Gui connected     port="+portName+"   "+s.substring(0,s.indexOf("[")-2);
  timeNSay("grbl said hello");
  button22.setText((verboseOutput ?"halt ":"provide ")+"verbose output");
  
  /* prompt for the stored eprom variables */
  portMsg="$#\n";
  port.write(portMsg);
  //logNCon("port.wrote("+portMsg+")");

  /* prompt for the stored settings */
  portMsg="$$\n";
  port.write(portMsg);
  //logNCon("port.wrote("+portMsg+")");
  
  ///* if uncommentd, this will prompt the help response. see https://github.com/gnea/grbl/wiki/Grbl-v1.1-Commands */
  //portMsg="$\n";
  //port.write(portMsg);
  //logNCon("port.wrote("+portMsg+")");    
}



/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleStreamingError(String s){
  numErrors+=1;
  try {
    int num=Integer.parseInt(s.substring(s.indexOf(":")+1));
    log.debug("streaming error num="+num);
    label22.setText(s.startsWith("Alarm")?alarms[num-1]:errors[num-1]);
    String err=String.format(
      "row %6d has %s[%2d]=%s",
      numRowsConfirmedProcessed+1,
      (s.startsWith("Alarm")?"Alarm":"error"),
      (num-1),
      (s.startsWith("Alarm")?alarms[num-1]:errors[num-1])
    );
    logNCon(err);
  } catch (NumberFormatException nfe) {
    logNCon("NumberFormatException: " + nfe.getMessage());
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
}  
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleCleanupOfNoMorePin(String s){
  logNCon("cleanup of the Pn affected lables due to expiration of a Pn:");  
//*  label22.setText(""); /* remove any error or Alarm text */
//*    
//*  label23.setText("X Limit Off");
//*  label24.setText("Y Limit Off");
//*  label25.setText("Z Limit Off");
//*  label26.setText("Probe Off"  );
//*  label27.setText("Door Closed");
//*  
//*  label23.setLocalColorScheme(GCScheme.SCHEME_9);
//*  label24.setLocalColorScheme(GCScheme.SCHEME_9);
//*  label25.setLocalColorScheme(GCScheme.SCHEME_9);
//*  label26.setLocalColorScheme(GCScheme.SCHEME_9);
//*  label27.setLocalColorScheme(GCScheme.SCHEME_9);
//*  
//*  label23.setOpaque(false);
//*  label24.setOpaque(false);
//*  label25.setOpaque(false);
//*  label26.setOpaque(false);
//*  label27.setOpaque(false);
  
  priorStatusHadPn=false; 
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSettingCollection(String s){
  //logNCon("handleGrblSettingCollection("+s+") with grblSettingIndices.length="+grblSettingIndices.length);
  String[] chunks=s.substring(1).split("=",2);
  //for(int ii=0;ii<chunks.length;ii++)logNCon(String.format("chunk[%d]=%s",ii,chunks[ii])); 
  try {
    int num=Integer.parseInt(chunks[0]);
    for(int ii=0;ii<grblSettingIndices.length;ii++){
       if(num==grblSettingIndices[ii])grblSettings[ii]=chunks[1]; 
    }
  } catch (NumberFormatException nfe) {
    logNCon("NumberFormatException: " + nfe.getMessage());
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
  seeGrblParams=true;
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
