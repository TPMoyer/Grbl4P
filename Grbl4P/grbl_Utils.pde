/**************************************************************************************************************/
/* joyX and joyY have been censored by the serialEvent handler to ignore a deadzone */
void doJoyStickJogging(){
  float multiFactor=1.0;
  boolean hatUpOrDown= (joyHat==0)||(joyHat==4);
  if(  amJoyStickJogging
     &&(joyX == 0.0)
     &&(joyY == 0.0)
     &&(!hatUpOrDown)
    ){
    amJoyStickJogging=false;
    numJoyStickJogsSent=0;
    numJoyStickJoggingOKs=0;
    delay(400);
  }
  else
  if(numJoyStickJogsSent <= numJoyStickJoggingOKs+2){
    if(  (joyX != 0.0)
       ||(joyY != 0.0)
       ||(hatUpOrDown)
      ){
      float timePerDraw=1.0/frameRate;
      float deltaX=0.0;
      float deltaY=0.0;
      float deltaZ=0.0;
      
      if(joyX != 0.0){
        //joyX=1.0*(joyX>0?1:-1);
        deltaX=multiFactor*joyX*maxFeedRates[0]/60*timePerDraw;
      }
      if(joyY != 0.0){
        deltaY=multiFactor*joyY*maxFeedRates[1]/60*timePerDraw;
      }
      if(!amJoyStickJogging){
        numJoyStickJogsSent=0;
        numJoyStickJoggingOKs=0;  
      }
      if(hatUpOrDown){
        deltaZ=multiFactor*joyThrottle*((joyHat==0)?1.0:-1.0)*maxFeedRates[2]/60*timePerDraw;  
      } 
      //log.debug(String.format("vel calc sqrt(%9.3f + %9.3f + %9.3f)",(joyX*maxFeedRates[0]*joyX*maxFeedRates[0]),(joyY*maxFeedRates[1] * joyY*maxFeedRates[1]),(joyThrottle*maxFeedRates[2] * joyThrottle*maxFeedRates[2] * (hatUpOrDown?1.0:0.0))));
      double vel=Math.sqrt( (joyX*maxFeedRates[0] * joyX*maxFeedRates[0]) + (joyY*maxFeedRates[1] * joyY*maxFeedRates[1]) + (joyThrottle*maxFeedRates[2] * joyThrottle*maxFeedRates[2] * (hatUpOrDown?1.0:0.0) ));
      
      amJoyStickJogging=true;
      if(  (0.0==joyY)
         &&(!hatUpOrDown)
        ){
        msg=String.format("$J=G91 X%.3f F%.3f\n",deltaX,vel);
      } else
      if(  (0.0==joyX)
         &&(!hatUpOrDown)
        ){
        msg=String.format("$J=G91 Y%.3f F%.3f\n",deltaY,vel);
      } else
      if(!hatUpOrDown){
        msg=String.format("$J=G91 X%.3f Y%.3f F%.3f\n",deltaX,deltaY,vel);
      } else
      if(0.0==joyY){
        msg=String.format("$J=G91 X%.3f Z%.3f F%.3f\n",deltaX,deltaZ,vel);
      } else
      if(0.0==joyX){
        msg=String.format("$J=G91 Y%.3f Z%.3f F%.3f\n",deltaY,deltaZ,vel);
      } else{
        msg=String.format("$J=G91 X%.3f Y%.3f Z%.3f F%.3f\n",deltaX,deltaY,deltaZ,vel);
      }           
      numJoyStickJogsSent+=1;
      writeJoyJog(msg);
      //log.debug(String.format("joyX=%6.3f joyY=%6.3f throttle=%5.2f hat=%d numJoyStickJogsSent=%d vs %d=numJoggingOKs deltas=(%7.3f,%7.3f,%7.3f) vel=%9.3f",joyX,joyY,joyThrottle,joyHat,numJoyStickJogsSent,numJoyStickJoggingOKs,deltaX,deltaY,deltaZ,vel));  
    }    
  } //else {
    //log.debug(String.format("doJoyStickJogging(); called too soon, numJoyStickJogsSent=%d vs %d=numJoggingOKs",numJoyStickJogsSent,numJoyStickJoggingOKs));
  //}  
}
/**************************************************************************************************************/
void writeJoyJog(String s){
    ports[grblIndex].write(s.replace(" ",""));
    log.debug(s.replace(" ","").length()+" "+s.replace("\n",""));
}
/**************************************************************************************************************/
int[] parseJoy(String s){
  String[] parts=s.split(",");
  //log.debug("parts is "+parts.length+" long");  
  int[] outs;
  if(6==parts.length){
    outs = new int[5];
    for(int ii=0;ii<5;ii++){
      outs[ii]=Integer.decode("0x"+parts[ii+1]);
    } 
    if(  (false==gotJoyPriors)
       &&(5 == parts.length)
      ){
      priorJoyX=outs[0];
      priorJoyY=outs[1];
      priorJoyR=outs[2];
      priorJoyT=outs[3];
      priorJoyS=outs[4];
      gotJoyPriors=true;
      //log.debug("gotJoyPriors");
    } 
  } else {
    outs=new int[1];
  }     
  return outs;
}
/**************************************************************************************************************/
void initGrblSettings(){
  /**/logNCon("cme@","initGrblSettings",0);
  /* a note on how I set the ../data/user_gui_palette.png per 
   * http://www.lagers.org.uk/g4p/guides/g04-colorschemes.html     and    http://www.lagers.org.uk/g4p/guides/g05-colorschemes.html
   * The reasons for the palette 9 choices are lost to history 
   * Palette 10 is green but with the text full black 
   * palette 11 is cyan  but with the text full black
   * palette 12 is blue  but with the text full black
   */
  grblSettings = new String[grblSettingIndices.length];
  for(int ii=0;ii<grblSettingIndices.length;ii++){
    mGrblSettings.put(String.format("G%d",grblSettingIndices[ii]),grblSettingTexts[ii]);    
  }  
  //log.info("length of alarms="+alarms.length);
  //log.info("length of grblSettingTexts="+grblSettingTexts.length);
  //log.info("length of errors="+errors.length);
  //for(Map.Entry<String, String> entry : mGrblSettings.entrySet()){
  //  logNCon(String.format("$%-4s : %-50s",entry.getKey(),entry.getValue()),"initGrblSettings",0);
  //}  
}
/**************************************************************************************************************/
void fileSelected(File selection) {
  if (selection == null) {
    logNCon("Window was closed or the user hit cancel.","fileSelected",0);
  } else {
    logNCon("User selected " + selection.getAbsolutePath(),"fileSelected",1);
    fid=selection.getAbsolutePath();
    textfield2.setText(fid);
  }
}
/**************************************************************************************************************/
void timeNSay(String s){
  float timeElapsedInSeconds = Duration.between(appStart,Instant.now()).toMillis()/1000.;
  logNCon(String.format("%8.3f %s",timeElapsedInSeconds,s),"timeNSay",0);
}  
/**************************************************************************************************************/
/* send to the log file and to the console, a string what was pushed to the port */
void logNConPort(String s,String method,int index){
  msg="port.wrote("+s+")";
  logNCon(msg,method,index);
  log.debug(msg);
}  
/**************************************************************************************************************/
/* send to the log file and to the console, a string what was pushed to the port */
void logNCon(String s,String method, int index){
  println(s);
  log.debug(String.format("%s %2d %s",method,index,s));
}  
/**************************************************************************************************************/
void hashtagParams2Console(){
 for(int ii=0;ii<paramNames.length;ii++){
    if(10==ii)logNCon(String.format("%s (%9.3f,%9.3f,%9.3f) lastProbeGood=%s\n"        ,paramNames[ii],gParams[ii][0],gParams[ii][1],gParams[ii][2],(lastProbeGood?"true":"false")),"hashtagParams2Console",0);
    else 
    if(9==ii) logNCon(String.format("%s (                    %9.3f)",paramNames[ii],gParams[ii][0]                              ),"hashtagParams2Console",1);
    else      logNCon(String.format("%s (%9.3f,%9.3f,%9.3f)"        ,paramNames[ii],gParams[ii][0],gParams[ii][1],gParams[ii][2]),"hashtagParams2Console",2);
  }
}

/**************************************************************************************************************/

void openSerialPorts(boolean sayAllComPortNames){  
  //if (ports != null) port.stop();
  portNames = Serial.list();
  serialThisNames = new String [portNames.length];
  ports           = new Serial [portNames.length];
  portsBusy       = new boolean[portNames.length];
  logNCon("portNames has "+portNames.length+" member"+(1<portNames.length?"s":""),"openSerialPort",0);
  if(sayAllComPortNames){
    //printArray(portNames);
    for(int ii=0;ii<portNames.length;ii++){
      logNCon(portNames[ii],"OpenSerialPort",1);
    }  
  }  
  int numPortsChecked=0;
  for(int ii=0;ii<portNames.length;ii++){
    //log.debug("doing portNames["+ii+"]="+portNames[ii]);
    //Map<String,String> props = Serial.getProperties(portNames[ii]);
    //log.debug("doing portNames["+ii+"]="+portNames[ii]+" which has "+props.size()+" properties");
    //for(Map.Entry<String, String> entry : props.entrySet()) {
    //  log.debug(String.format("OSP %8s key=%-20s  val=%20s",portNames[ii],entry.getKey(),entry.getValue()));
    //}
    if(knownGoodGrblComPort.equals(portNames[ii])){
      String matcher=portNames[ii];
      for(int jj=ii;jj>0;jj--){
        portNames[ii]=portNames[ii-1];
      }  
      portNames[0]=matcher;
    }
  }  
  for(int ii=0;ii<portNames.length;ii++){
    //log.debug("instancing Serial interface on port "+portNames[ii]);
    try {
      ports[ii] = new Serial(this, portNames[ii], 115200);
      ports[ii].bufferUntil('\n');
      serialThisNames[ii]=String.format("%s",ports[ii]);
      //log.debug("         setting serialThisNames["+ii+"]="+serialThisNames[ii]); 
      numPortsChecked+=1;
      portsBusy[ii]=false;
    } catch (RuntimeException re){
      if(re.getMessage().contains("Port busy"))logNCon("unable to attempt Grbl handshake on port=="+portNames[ii]+"   Port is busy","openSerialPort",1);
      portsBusy[ii]=true;
    }
  } 
  if(0==numPortsChecked)logNCon("\nwas unable to attempt handshake on any COM port\n","openSerialPort",5);
}

/**************************************************************************************************************/

void grblParams2Console(){
  /**/logNCon("grblSettings.length="+grblSettings.length,"grblParams2Console",0);
  float homePullOff=0;
  for(int ii=0;ii<grblSettings.length;ii++){
    if(null==grblSettings[ii])grblSettings[ii]=" ";
    //logNCon(String.format("grblSettingIndices[%2d]=%3d grblSettings[%2d]=%s which is %2d long",ii,grblSettingIndices[ii],ii,grblSettings[ii],grblSettings[ii].length()),"grblParams2Console",1);
    //if(120==grblSettingIndices[ii])textfield4.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    //if(121==grblSettingIndices[ii])textfield5.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    //if(122==grblSettingIndices[ii])textfield6.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    if(120==grblSettingIndices[ii])textfield4.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-2));/* to give 1 digit right of the decimal */
    if(121==grblSettingIndices[ii])textfield5.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-2));/* to give 1 digit right of the decimal */
    if(122==grblSettingIndices[ii])textfield6.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-2));/* to give 1 digit right of the decimal */
    try {
      //logNCon("try top","grblParams2Console",1);
      String[] words = grblSettings[ii].split(" ");
      //logNCon("words is "+words.length+" long");
      if(110==grblSettingIndices[ii]){
        maxFeedRates[0]=Float.valueOf(words[0]);
        textfield3.setText(String.format("%4.0f",maxFeedRates[0]));
      }  
      if(111==grblSettingIndices[ii]){
        maxFeedRates[1]=Float.valueOf(words[0]);
        textfield10.setText(String.format("%4.0f",maxFeedRates[1]));
      }  
      if(112==grblSettingIndices[ii]){
        maxFeedRates[2]=Float.valueOf(words[0]);
        textfield11.setText(String.format("%4.0f",maxFeedRates[2]));
      }  
      if( 27==grblSettingIndices[ii])homePullOff=Float.valueOf(words[0]);  
      if(130==grblSettingIndices[ii])homes2WorkAllPositive[0]=Float.valueOf(words[0])-homePullOff;
      if(131==grblSettingIndices[ii])homes2WorkAllPositive[1]=Float.valueOf(words[0])-homePullOff;
      if(132==grblSettingIndices[ii])homes2WorkAllPositive[2]=Float.valueOf(words[0])-homePullOff;
 
      //logNCon("try bot");
    } catch (NumberFormatException nfe) {
      logNCon("NumberFormatException: " + nfe.getMessage(),"grblParams2Console",2);
      System.err.println("NumberFormatException: " + nfe.getMessage());
    }
    logNCon(String.format("%2d %-5s = %-9s  %s",
      ii,
      String.format("$%d",grblSettingIndices[ii]),
      String.format("%"+(grblSettings[ii].contains(".")?"9":"5")+"s",grblSettings[ii]), /* this allows 25000 for spindle speed */
      mGrblSettings.get(String.format("G%d",grblSettingIndices[ii]))
    ),"grblParams2Console",3);
    //logNCon(String.format("@endOf grblSettings loop %d of %d",ii,grblSettings.length),"grblParams2Console",4);
  }
  //wcoOffsetPostHome[0]=grblSettings[31]-grblSettings[18];
  log.debug(String.format("homes2WorkAllPositive=(%9.3f,%9.3f%9.3f)",homes2WorkAllPositive[0],homes2WorkAllPositive[1],homes2WorkAllPositive[2]));
  //logNCon("@endOf grblParams2Console()","grblParams2Console",5);
}
/**************************************************************************************************************/
/**************************************************************************************************************/
void initGUI(){
  
  createGUI();
  for(int ii=0;ii<40;ii++){
    labelPreTexts  [ii]="";
    labelPriorTexts[ii]="";
  }

  /* default font for the sketch set to Monospaced 20 */
  Font font0=new Font("Monospaced", Font.PLAIN, 16);
  Font font1=new Font("Monospaced", Font.PLAIN, 30);
  Font font2=new Font("Monospaced", Font.PLAIN, 60);
   
  label17.setVisible(false);

  button19.setFont(font2);
  button19.setTextBold();
  button14.setFont(font2);
  button14.setTextBold();
  button39.setFont(font1);
  //button39.setTextBold();

  //button24.setFont(font0);
  button34.setFont(font0);
  button35.setFont(font0);
  button36.setFont(font0);
  button37.setFont(font0);
  button45.setFont(font0);
  button46.setFont(font0);

  label2.setFont(font1);
  label10.setFont(font1);
  label11.setFont(font1);
  
  label14.setFont(font0);
  label30.setFont(font0);
  label23.setFont(font0);
  label24.setFont(font0);
  label25.setFont(font0);
  label28.setFont(font0);
  
  label2.setTextBold();
  label10.setTextBold();
  label11.setTextBold();
  
  label7.setTextBold();
  label8.setTextBold();
  label9.setTextBold();

  label17.setTextBold();
  label4.setFont(font0);
  
  label4 .setVisible(false);
  label19.setVisible(false);
  //log.debug("label4 made not visible by initialization");

  label1 .setText(String.format("W%dXYZ:",activeWCO));
  label5 .setText(String.format("(%11.3f," ,jogStepSizes[0]));
  label12.setText(String.format( "%11.3f," ,jogStepSizes[1]));
  label13.setText(String.format( "%11.3f )",jogStepSizes[2]));
   
  //textfield12.setNumeric(1,6,1); /* the textfield associated with the work coordinate system (WCO) can be only values from 1 to 6, default=1 */
  
  textarea1.setFont(font0);
 
}
/**************************************************************************************************************/
void doGuiLabels(){
  /* I'm not proud of this section... I would have preferred to access the labels as indexed instances of the label class
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
    } else 
    if(  (!priorActiveDrawnState.equals("Home"))
       &&(activeState.equals("Idle"))               /* record the delta between MPOS and WCO */
    ){
      
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
  /* when I tried simply setting the labelPreTexts[19] every joyStickSerialEvent, the joystick serial silently crashed 
   * Using the joyThrottle variable from within the less frequently cycled draw thread seems to allow 
   * the Draw thread, and the joystick serial thread to co-exist 
   */
  //labelPreTexts [19]=String.format("Joy Throttle %4.0f",100.*joyThrottle);
  if(!labelPreTexts [19].equals(labelPriorTexts[19])){
     label19.setText(    labelPreTexts[19]);
     labelPriorTexts[19]=labelPreTexts[19];
  }
  //if(!labelPreTexts [20].equals(labelPriorTexts[20])){
  //   label20.setText(    labelPreTexts[20]);
  //  labelPriorTexts[20]=labelPreTexts[20];
  //}
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
}  
/**************************************************************************************************************/
