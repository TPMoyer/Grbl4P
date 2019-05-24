void timeNSay(String s){
  float timeElapsedInSeconds = Duration.between(appStart,Instant.now()).toMillis()/1000.;
  println(String.format("%8.3f %s",timeElapsedInSeconds,s));
}  


/* this relies on the asyncronous SerialEvent() to set the seeGrbl boolean */
void openSerialPort(boolean sayAllComPortNames){  
  if (port != null) port.stop();
  String[] portNames = Serial.list();
  println("portNames has "+portNames.length+" member"+(1<portNames.length?"s":""));
  if(sayAllComPortNames)printArray(portNames);
  float waitDuration=5.0;
  int numPortsChecked=0;
  int startAt=0;
  for(int ii=0;ii<portNames.length;ii++)if(knownGoodGrblComPort.equals(portNames[ii]))startAt=ii;  
  for(int ii=startAt;ii<portNames.length;ii++){
    portName=portNames[ii];
    Instant comSeekStart = Instant.now();
    boolean portConnectedOk=false;
    try {
      port = new Serial(this, portNames[ii], 115200);
      port.bufferUntil('\n');
      portConnectedOk=true;
      numPortsChecked+=1;
    } catch (RuntimeException re){
      if(re.getMessage().contains("Port busy"))println("unable to attempt Grbl handshake on port=="+portNames[ii]+"   Port is busy");
    }
    if(portConnectedOk){
      while(  (!seeGrbl)
            &&(waitDuration>Duration.between(comSeekStart,Instant.now()).toMillis()/1000.)
      ){
      println(String.format("%8.3f waiting for response from %s",Duration.between(comSeekStart,Instant.now()).toMillis()/1000.,portNames[ii])); 
      try{
        Thread.sleep(1000); /* limit console output to 1hz */
      } catch(InterruptedException e){
        System.out.println("sleep failed");
      }
    }     
    if(seeGrbl){      
      break;
    } else 
    if(portConnectedOk)
      port.stop();
      println(String.format("no response from %s after %.0f seconds.",portNames[ii],waitDuration));
    }  
  } 
  if(0==numPortsChecked)println("\nwas unable to attempt handshake on any COM port\n");
  if(!seeGrbl){
    println("\n\nInitialization failed.\nCould not connect to Grbl on any COM port.\n\n");
    System.exit(1);
  }  
} 

void hashtagParams2Console(){
 for(int ii=0;ii<paramNames.length;ii++){
    if(10==ii)println(String.format("%s (%9.3f,%9.3f,%9.3f) lastProbeGood=%s\n"        ,paramNames[ii],gParams[ii][0],gParams[ii][1],gParams[ii][2],(lastProbeGood?"true":"false")));
    else 
    if(9==ii) println(String.format("%s (                    %9.3f)",paramNames[ii],gParams[ii][0]                              ));
    else      println(String.format("%s (%9.3f,%9.3f,%9.3f)"        ,paramNames[ii],gParams[ii][0],gParams[ii][1],gParams[ii][2]));
  }
}  
void grblParams2Console(){
  //println("in grblParams2Console");
  float homePullOff=0;
  for(int ii=0;ii<grblSettings.length;ii++){
    if(120==grblSettingIndices[ii])textfield4.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    if(121==grblSettingIndices[ii])textfield5.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    if(122==grblSettingIndices[ii])textfield6.setText(grblSettings[ii].substring(0,grblSettings[ii].length()-4));
    try {
      if(  (  (110==grblSettingIndices[ii])
            ||(111==grblSettingIndices[ii])
            ||(112==grblSettingIndices[ii])
           )       
         &&(minMaxFeedRate>Float.valueOf(grblSettings[ii]))
        ){
        minMaxFeedRate=Float.valueOf(grblSettings[ii]);  
      }
      if( 27==grblSettingIndices[ii])homePullOff=Float.valueOf(grblSettings[ii]);
      if(130==grblSettingIndices[ii])homes2WorkAllPositive[0]=Float.valueOf(grblSettings[ii])-homePullOff;
      if(131==grblSettingIndices[ii])homes2WorkAllPositive[1]=Float.valueOf(grblSettings[ii])-homePullOff;
      if(132==grblSettingIndices[ii])homes2WorkAllPositive[2]=Float.valueOf(grblSettings[ii])-homePullOff;
    } catch (NumberFormatException nfe) {
      System.err.println("NumberFormatException: " + nfe.getMessage());
    }
    println(String.format("%-5s = %-9s  %s",
      String.format("$%d",grblSettingIndices[ii]),
      String.format("%"+(grblSettings[ii].contains(".")?"9":"5")+"s",grblSettings[ii]), /* this allows 25000 for spindle speed */
      mGrblSettings.get(String.format("G%d",grblSettingIndices[ii]))
    ));  
  }
  maxFeedRate=minMaxFeedRate;
  textfield3.setText(String.format("%4.0f",minMaxFeedRate));
  button24.setText(String.format("SetX %6.1f",homes2WorkAllPositive[0]-homePullOff));
  button27.setText(String.format("GoTo %6.1f",homes2WorkAllPositive[0]-homePullOff));
  button30.setText(String.format("SetX %6.1f",homes2WorkAllPositive[1]-homePullOff));
  button31.setText(String.format("GoTo %6.1f",homes2WorkAllPositive[1]-homePullOff));
  button32.setText(String.format("SetX %6.1f",homes2WorkAllPositive[2]-homePullOff));
  button33.setText(String.format("GoTo %6.1f",homes2WorkAllPositive[2]-homePullOff));
}  
void initGrblSettings(){
  grblSettings = new String[grblSettingIndices.length];
  for(int ii=0;ii<grblSettingIndices.length;ii++){
    mGrblSettings.put(String.format("G%d",grblSettingIndices[ii]),grblSettingTexts[ii]);    
  }  
  //for(Map.Entry<String, String> entry : mGrblSettings.entrySet()){
  //  println(String.format("$%-4s : %-50s",entry.getKey(),entry.getValue()));
  //}  
}

void fileSelected(File selection) {
 textfield2.setText(selection.getAbsolutePath());    
 /* This showed that the display can show 63 characters with the font0 at 20 */
 //textfield2.setText("0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789");
}

void initGUI(){
  createGUI();
  
  Font font0=new Font("Monospaced", Font.PLAIN, 20);
  Font font1=new Font("Monospaced", Font.PLAIN, 30);
  Font font2=new Font("Monospaced", Font.PLAIN, 60);
  button1.setFont(font0);
  button2.setFont(font0);
  button3.setFont(font0);
  button4.setFont(font0);
  button5.setFont(font0);
  button6.setFont(font0);
  button7.setFont(font0);
  button8.setFont(font0);
  button9.setFont(font0);
  button10.setFont(font0);
  button11.setFont(font0);
  button12.setFont(font0);
  button13.setFont(font0);
  button14.setFont(font0);
  button15.setFont(font0);
  button16.setFont(font0);
  button17.setFont(font0);
  button18.setFont(font0);
  button19.setFont(font2);
  button20.setFont(font0);
  button21.setFont(font0);
  button22.setFont(font0);
  button23.setFont(font0);
  button24.setFont(font0);
  button25.setFont(font0);
  button26.setFont(font0);
  button27.setFont(font0);
  button28.setFont(font0);
  button29.setFont(font0);
  button30.setFont(font0);
  button31.setFont(font0);
  button32.setFont(font0);
  button33.setFont(font0);
  
    
  
  label1.setFont(font0);
  label2.setFont(font1);
  label3.setFont(font0);
  label4.setFont(font0);
  label5.setFont(font0);
  label6.setFont(font0);
  label7.setFont(font0);
  label8.setFont(font0);
  label9.setFont(font0);
  label10.setFont(font1);
  label11.setFont(font1);
  label12.setFont(font0);
  label13.setFont(font0);
  label29.setFont(font0);
  label31.setFont(font0);
  label32.setFont(font0);
  label33.setFont(font0);  
  
  label15.setFont(font0);  
  label16.setFont(font0);
  label17.setFont(font0);
  label18.setFont(font0);
  label19.setFont(font0);
  label20.setFont(font0);
  label21.setFont(font0);
  label22.setFont(font0);

  textfield1.setFont(font0);
  textfield2.setFont(font0);
  textfield3.setFont(font0);
  textfield4.setFont(font0);
  textfield5.setFont(font0);
  textfield6.setFont(font0);
  
}  
