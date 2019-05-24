 void serialEvent(Serial p){
  
  String s = p.readStringUntil('\n').trim();
  /* Initial peek at the stream of data which enters this method 
   * for(int ii=0;ii<s.length();ii++)println(String.format("%2d %c %3d",ii,s.charAt(ii),(int)s.charAt(ii))); 
   * That show-every-character for() has become legacy code
   */
  
  if(0<s.length()){
      
    if(  (!streaming)
       &&(  verboseOutput
          ||('<'!=s.charAt(0))
         ) 
       &&('$'!=s.charAt(0)) /* do not push thru the grblParams,    they are pretty-printed post collection of the full set */  
       &&('#'!=s.charAt(0)) /* do not push thru the hashtagParams, they are pretty-printed post collection of the full set */
       
      ){ 
      timeNSay(String.format("se |%s|",s.trim()));
      //timeNSay(String.format("serialEvent got pipeBound |%s|",s.trim()));
      //timeNSay(String.format("serialEvent with "+(priorStatusHadPn?"true ":"false")+"==priorStatusHadPn  got pipeBound |%s|",s.trim()));
    }
    /* check for ok or error to have the numbers fed into the streaming handler be correct */
    if(s.equals("ok") ){
      if(streaming)numOKs+=1;
      else {
        label22.setText(""); /* remove any error or alarm text */
        if(true==seeHashtagParams){
          hashtagParams2Console();
          seeHashtagParams=false;
        }
        if(true==seeGrblParams){
          grblParams2Console();
          seeGrblParams=false;
        }
      }
    } else
    if(  s.startsWith("error")
       ||s.startsWith("ALARM")
    ){
      if(streaming) handleStreamingError(s);
      else handleAlarmNError(s); 
    }
    
    if(streaming && bufferedReaderSet){
      //println("streaming "+s);
      handleFileBufferFillNPush();
    }
    
    if(s.charAt(0)=='<'){
      handleStatusReport(s); /* the response to the 5hz status report query needed extensive handling */
    } else
    if(s.startsWith("[GC")){  /* currently no action taken upon recieving this */
      println("got [GC.   reflects "+s);
    } else
    if(s.startsWith("[HLP")){ /* currently no action taken upon recieving this */
      println("got [HLP.   reflects "+s);
    } else
    if(s.startsWith("[VER")){ /* currently no action taken upon recieving this */
      println("got [VER.   reflects "+s);
    } else
    if(s.startsWith("[OPT")){ /* currently no action taken upon recieving this */
      println("got [VER.   reflects "+s);
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

void handleFileBufferFillNPush(){
  //timeNSay("handleFileBufferFillNPush() numLinesSent="+numLinesSent+" numOks="+numOKs+" numErrors="+numErrors);
  //timeNSay("h");
  if(  (0< numLinesSent)
     &&(numLinesSent==(numOKs+numErrors))
  ){
    streaming=false;
    String msg="streaming completed on "+numLinesSent+" gCode rows with "+numErrors+" errors";
    println(msg);
    label22.setText(msg);
    if(0==numErrors)label22.setLocalColorScheme(GCScheme.GREEN_SCHEME);
    label22.setTextBold();
  } else {  
    try {
      /* read line by line until the number of bytes is greater than 128
       * then push as many as will fit into the potentially partilly filled grbl buffer */
      String line="";
      
      /* This loads up the redBuffer with enough lines to be more than enough bytes to fill the entire grbl buffer  */
      while(  (redBufferUsed < bufferSize)
            &&((line = br.readLine()) != null)
      ){
        //println("lineOrig=|"+line+"|");
        if(line.contains(";"))line=line.substring(0,line.indexOf(";"));
        String modLine=line.replaceAll("\\(.*\\)", "").replaceAll(" ","").toUpperCase()+"\n";
        if(1<modLine.length()){
          redBuffer.add(modLine);
          redBufferUsed+=modLine.length();
        }  
      }
      //println("redBuffer has "+redBuffer.size()+" rows");
      //for(int ii=0;ii<redBuffer.size();ii++)println(
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
        //println(String.format("numRowsConfirmedProcessed=%6d vs %6d %3d %2d",numRowsConfirmedProcessed,(numOKs+numErrors),grblBufferUsed,sentLineLengths.size()));
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
          //println(String.format(
          //  "sent %3d bytes of %3d which will leave %3d bytes among the remaining %2d rows. |%s|",
          //  nextUpLength,
          //  redBufferUsed,        
          //  redBufferUsed-nextUpLength,
          //  redBuffer.size()-1,
          //  redBuffer.get(0).toString().substring(0,redBuffer.get(0).toString().length()-1)        
          //  )
          //);
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
  //println("number of chunks = "+chunks.length);
  //for(int ii=0;ii<chunks.length;ii++){
  //  println("\n"+chunks[ii]);
  //  for(int jj=0;jj<chunks[ii].length();jj++){
  //    println(String.format("%2d %2d %c %3d",ii,jj,chunks[ii].charAt(jj),(int)chunks[ii].charAt(jj)));
  //  }  
  //}
  for(int ii=1;ii<chunks.length;ii++){
    String[] labelData = chunks[ii].split(":",2);
    if(labelData[0].equals("MPos")){
      String[] pos = labelData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          mPos[jj]=Float.valueOf(pos[jj]);
        } catch (NumberFormatException nfe) {
            System.err.println("NumberFormatException: " + nfe.getMessage());
        }
      }
      /* the WPos bold, larger upper row of locations */
      label2 .setText(String.format("(%9.3f,",mPos[0]-wco[0]));
      label10.setText(String.format("%9.3f," ,mPos[1]-wco[1]));
      label11.setText(String.format("%9.3f)" ,mPos[2]-wco[2]));
      label2 .setTextBold();
      label10.setTextBold();
      label11.setTextBold();
      
      /* the MPos plain, smaller lower row of locations */
      label7.setText(String.format("(%9.3f,",mPos[0]));
      label8.setText(String.format("%9.3f," ,mPos[1]));
      label9.setText(String.format("%9.3f)" ,mPos[2]));
      label7.setTextBold();
      label8.setTextBold();
      label9.setTextBold();
    } else 
    if(labelData[0].equals("FS")){
      String[] nums = labelData[1].split(",",2);
      try {
        feedRate=Float.valueOf(nums[0]);
        label17.setText(String.format("%4.0f",feedRate));
        label17.setTextBold();
        //println("feedRate="+feedRate);
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
      try {
        spindleSpeed=Integer.parseInt(nums[1]);
        label19.setText(NumberFormat.getNumberInstance(Locale.US).format(feedRate));
        label19.setTextBold();
        //println("spindleSpeed="+spindleSpeed);
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    } else 
    if(labelData[0].equals("F")){
      try {
        feedRate=Float.valueOf(labelData[1]);
        label17.setText(String.format("%4.0f",feedRate));
        label17.setTextBold();
        //println("feedRate="+feedRate);
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }else
    if(labelData[0].equals("Ov")){
      String[] ovs = labelData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          ov[jj]=Float.parseFloat(ovs[jj]);
        } catch (NumberFormatException nfe) {
          System.err.println("NumberFormatException: " + nfe.getMessage());
          System.exit(8);
        }
      }
    } else
    if(labelData[0].equals("WCO")){
      String[] wcos = labelData[1].split(",",3);
      for(int jj=0;jj<3;jj++){
        try {
          wco[jj]=Float.valueOf(wcos[jj]);
        } catch (NumberFormatException nfe) {
            System.err.println("NumberFormatException: " + nfe.getMessage());
            System.exit(5);
        }
      }
      //label2.setText(String.format("(%9.3f,%9.3f,%9.3f)",mPos[0],mPos[1],mPos[2]));
      //label2.setTextBold();
    } else
    if(labelData[0].equals("Pn")){
      /* did not put indicators on GUI for hold pin, soft-reset pin, or cycle-start pin */
     
      label23.setText(labelData[1].contains("X")?"X Limit On":"X Limit Off");
      label24.setText(labelData[1].contains("Y")?"Y Limit On":"Y Limit Off");
      label25.setText(labelData[1].contains("Z")?"Z Limit On":"Z Limit Off");
      label26.setText(labelData[1].contains("P")?"Probe On"  :"Probe Off"  );
      label27.setText(labelData[1].contains("D")?"Door Open" :"Door Closed");
      
      label23.setLocalColorScheme(labelData[1].contains("X")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label24.setLocalColorScheme(labelData[1].contains("Y")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label25.setLocalColorScheme(labelData[1].contains("Z")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label26.setLocalColorScheme(labelData[1].contains("P")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label27.setLocalColorScheme(labelData[1].contains("D")?GCScheme.SCHEME_10:GCScheme.SCHEME_9);
      label23.setOpaque(labelData[1].contains("X"));
      label24.setOpaque(labelData[1].contains("Y"));
      label25.setOpaque(labelData[1].contains("Z"));
      label26.setOpaque(labelData[1].contains("P"));
      label27.setOpaque(labelData[1].contains("D"));
      
      priorStatusHadPn=true; 
    } else  {
       println("UnKnown status label encounterd in chunk:"+chunks[ii]+"\n Am aborting.");
       timeNSay(String.format("status recieved as pipeBound |%s|",s.trim()));
       System.exit(2);
    }    
  }  
  /* activeState can be:   Idle, Run, Hold, Door, Home, Alarm, Check */
  String priorActiveState=activeState;
  activeState=chunks[0].split(",",2)[0];
  label3.setText("Active State:"+activeState);
  if(  (  priorActiveState.equals("Alarm")
        ||priorActiveState.equals("error")
       ) 
     &&(!activeState.equals("Alarm"))
    ){
    label3.setLocalColorScheme(GCScheme.SCHEME_9);
    label3.setTextBold();
    label3.setOpaque(false);
  } else 
  if(  (!priorActiveState.equals("Alarm"))
     &&(activeState.equals("Alarm"))
  ){
    label3.setLocalColorScheme(GCScheme.SCHEME_10);
    label3.setOpaque(true);
    label3.setTextBold();        
  }
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleMsg(String s){
  //println("gcode parser state reflects "+s);
  lastMessage=s;
  label15.setText(lastMessage);
  label15.setTextBold();
  if(!activeState.equals("Alarm")){
    label22.setText(""); 
  }
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleNumberParams(String s){
  //println("s="+s);   
  int index=-1;
  String[] chunks=s.substring(1,s.length()-1).split(":",0);
  String[] nums = chunks[1].split(",",3);
  if(chunks[0].charAt(0)=='G'){
    //println("chunks[0]="+chunks[0]+" num from "+chunks[0].substring(1,3));
    int num =-1;
    try {
      num=Integer.parseInt(chunks[0].substring(1,3));
    } catch (NumberFormatException nfe) {
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
      default: println("UnKnown gcode GXX parameter where XX=="+num+"\n Am aborting.");
        timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
        System.exit(4);
    }   
  } else 
  if(chunks[0].equals("TLO")){
    index=9;
  } else   
  if(chunks[0].equals("PRB")){
    index=10;
    //println("chunks[2]=|"+chunks[2]+"|");
    lastProbeGood=('1'==chunks[2].charAt(0));                    
  } else {
    println("UnKnown gcode parameter in "+s+"\n Am aborting.");
    timeNSay(String.format("gcode parameter as pipeBound |%s|",s.trim()));
    System.exit(3);
  }
  //println("index="+index);
  int limit=(9==index?1:3);
  for(int jj=0;jj<limit;jj++){
    try {
      gParams[index][jj]=Float.parseFloat(nums[jj]);
    } catch (NumberFormatException nfe) {
      System.err.println("NumberFormatException: " + nfe.getMessage());
      System.exit(6);
    }
  }
  seeHashtagParams=true;
  //println("got to end of s.charAt(0)=='['  if");
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSaysHello(String s){
  /* initial hellow from grbl.  send the $# command to get the eprom parameters */
  frameTitle="GRBL Gui connected     port="+portName+"   "+s.substring(0,s.indexOf("[")-2);
  timeNSay("grbl said hello");
  button22.setText((verboseOutput ?"halt ":"resume ")+"verbose output");
  
  /* prompt for the stored eprom variables */
  portMsg="$#\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");

  /* prompt for the stored settings */
  portMsg="$$\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
  
  ///* if uncommentd, this will prompt the help response. see https://github.com/gnea/grbl/wiki/Grbl-v1.1-Commands */
  //portMsg="$\n";
  //port.write(portMsg);
  //println("port.wrote("+portMsg+")");    
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleAlarmNError(String s){
  try {
    int num=Integer.parseInt(s.substring(s.indexOf(":")+1));
    label22.setText(s.startsWith("ALARM")?alarms[num-1]:errors[num-1]);
    println("setting label22 to "+(s.startsWith("ALARM")?"alarms":"errors")+"["+(num-1)+"]");
    label22.setTextBold();
  } catch (NumberFormatException nfe) {
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
  activeState=s.startsWith("ALARM")?"Alarm":"error";
  label3.setText("Active State:"+activeState);
  label3.setLocalColorScheme(GCScheme.SCHEME_10);
  label3.setOpaque(true);
  label3.setTextBold();
  if(s.startsWith("ALARM"))port.write("?");
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleStreamingError(String s){
  numErrors+=1;
  try {
    int num=Integer.parseInt(s.substring(s.indexOf(":")+1));
    label22.setText(s.startsWith("ALARM")?alarms[num-1]:errors[num-1]);
    println(String.format(
      "row %6d has %s[%2d]=%s",
      numRowsConfirmedProcessed+1,
      (s.startsWith("ALARM")?"alarm":"error"),
      (num-1),
      (s.startsWith("ALARM")?alarms[num-1]:errors[num-1])
      )
    );
    label22.setTextBold();
  } catch (NumberFormatException nfe) {
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
}  
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleCleanupOfNoMorePin(String s){
  println("cleanup of the Pn affected lables due to expiration of a Pn:");  
  label22.setText(""); /* remove any error or alarm text */
    
  label23.setText("X Limit Off");
  label24.setText("Y Limit Off");
  label25.setText("Z Limit Off");
  label26.setText("Probe Off"  );
  label27.setText("Door Closed");
  
  label23.setLocalColorScheme(GCScheme.SCHEME_9);
  label24.setLocalColorScheme(GCScheme.SCHEME_9);
  label25.setLocalColorScheme(GCScheme.SCHEME_9);
  label26.setLocalColorScheme(GCScheme.SCHEME_9);
  label27.setLocalColorScheme(GCScheme.SCHEME_9);
  
  label23.setOpaque(false);
  label24.setOpaque(false);
  label25.setOpaque(false);
  label26.setOpaque(false);
  label27.setOpaque(false);
  
  priorStatusHadPn=false; 
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

void handleGrblSettingCollection(String s){
  //println("see "+s);
  String[] chunks=s.substring(1).split("=",2);
  try {
    int num=Integer.parseInt(chunks[0]);
    for(int ii=0;ii<grblSettingIndices.length;ii++){
       if(num==grblSettingIndices[ii])grblSettings[ii]=chunks[1]; 
    }
  } catch (NumberFormatException nfe) {
    System.err.println("NumberFormatException: " + nfe.getMessage());
    System.exit(6);
  }
  seeGrblParams=true;
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
