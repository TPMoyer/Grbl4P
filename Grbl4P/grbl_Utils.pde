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

/* this relies on the asyncronous SerialEvent() to set the seeGrbl boolean */
void openSerialPort(boolean sayAllComPortNames){  
  if (port != null) port.stop();
  String[] portNames = Serial.list();
  logNCon("portNames has "+portNames.length+" member"+(1<portNames.length?"s":""),"openSerialPort",0);
  if(sayAllComPortNames)printArray(portNames);
  float waitDuration=5.0;
  int numPortsChecked=0;
  for(int ii=0;ii<portNames.length;ii++){
    if(knownGoodGrblComPort.equals(portNames[ii])){
      String matcher=portNames[ii];
      for(int jj=ii;jj>0;jj--){
        portNames[ii]=portNames[ii-1];
      }  
      portNames[0]=matcher;
    }
  }   
  for(int ii=0;ii<portNames.length;ii++){
    portName=portNames[ii];
    Instant comSeekStart = Instant.now();
    boolean portConnectedOk=false;
    try {
      port = new Serial(this, portNames[ii], 115200);
      port.bufferUntil('\n');
//      portConnectedOk=true;
      numPortsChecked+=1;
    } catch (RuntimeException re){
      if(re.getMessage().contains("Port busy"))logNCon("unable to attempt Grbl handshake on port=="+portNames[ii]+"   Port is busy","openSerialPort",1);
    }
//    if(portConnectedOk){
//      while(  (!seeGrbl)
//            &&(waitDuration>Duration.between(comSeekStart,Instant.now()).toMillis()/1000.)
//      ){
//      logNCon(String.format("%8.3f waiting for response from %s",Duration.between(comSeekStart,Instant.now()).toMillis()/1000.,portNames[ii]),"openSerialPort",2); 
//      try{
//        Thread.sleep(1000);  limit console output to 1hz 
//      } catch(InterruptedException e){
//        System.out.logNCon("sleep failed","openSerialPort",3);
//      }
//    }     
//    if(seeGrbl){      
//      break;
//    } else 
//    if(portConnectedOk)
//      port.stop();
//      logNCon(String.format("no response from %s after %.0f seconds.",portNames[ii],waitDuration),"openSerialPort",4);
//    }  
  } 
  if(0==numPortsChecked)logNCon("\nwas unable to attempt handshake on any COM port\n","openSerialPort",5);
//  if(!seeGrbl){
//    logNCon("\n\nInitialization failed.\nCould not connect to Grbl on any COM port.\n\n","openSerialPort",6);
//    System.exit(1);
//  }
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

  button24.setFont(font0);
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

  label1 .setText(String.format("W%dXYZ:",currentWCO));
  label5 .setText(String.format("(%11.3f," ,jogStepSizes[0]));
  label12.setText(String.format( "%11.3f," ,jogStepSizes[1]));
  label13.setText(String.format( "%11.3f )",jogStepSizes[2]));
   
  textfield12.setNumeric(1,6,1); /* the textfield associated with the work coordinate system (WCO) can be only values from 1 to 6, default=1 */    
 
}
/**************************************************************************************************************/
