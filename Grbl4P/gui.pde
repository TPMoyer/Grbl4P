/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void button22_click1(GButton source, GEvent event) { //_CODE_:button22:773336:
  /* toggle button for verbose output */
  //logNCon("button22 - GButton >> GEvent." + event + " @ " + millis());
  verboseOutput=!verboseOutput;
  button22.setText("go2 "+(verboseOutput ?"sparse ":"verbose ")+"output");
} //_CODE_:button22:773336:

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:294684:
  /* X- jog */
  //logNCon("button1 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%1.0f\n",-1.0*jogStepSizes[0],maxFeedRates[0]);
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button1_click1",0);
} //_CODE_:button1:294684:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:538427:
  /* X+ jog */
  //logNCon("button2 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%1.0f\n",jogStepSizes[0],maxFeedRates[0]);
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button2_click1",0);
} //_CODE_:button2:538427:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:814160:
  /* reset X */
  //logNCon("button3 - GButton >> GEvent." + event + " @ " + millis());  
  portMsg="G10 P"+activeWCO+" L20 X0\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button3_click1",0);
  idleCount=0;
  delay(100);
} //_CODE_:button3:814160:

public void button4_click1(GButton source, GEvent event) { //_CODE_:button4:900152:
  /* reset Y */
  //logNCon("button4 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P"+activeWCO+" L20 Y0\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button4_click1",0);
  idleCount=0;
  delay(100);
} //_CODE_:button4:900152:

public void button5_click1(GButton source, GEvent event) { //_CODE_:button5:671405:
  /* reset Z */
  //logNCon("button5 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P"+activeWCO+" L20 Z0\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button5_click1",0);
  idleCount=0;
  delay(100);
} //_CODE_:button5:671405:

public void button6_click1(GButton source, GEvent event) { //_CODE_:button6:996513:
  //logNCon("button6 - GButton >> GEvent." + event + " @ " + millis());
  /* kill alarm lock */
  portMsg="$X\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button6_click1 (Kill Alarm Lock)",0);
 } //_CODE_:button6:996513:

public void button7_click1(GButton source, GEvent event) { //_CODE_:button7:509439:
  /* RESET */
  //logNCon("button7 - GButton >> GEvent." + event + " @ " + millis());
  portCode=0x18; /* ctrl-x */
  ports[grblIndex].write(portCode);
  logNConPort(portMsg+" which is 0x18 for reset.  ","button7_click1",0);
  
} //_CODE_:button7:509439:

public void button8_click1(GButton source, GEvent event) { //_CODE_:button8:961071:
  /* Y+ jog */
  //logNCon("button8 - GButton >> GEvent." + event + " @ " + millis());
  if(0.0==angleYOffOrthogoality){
    portMsg=String.format("$J=G91 Y%.3f F%1.0f\n",jogStepSizes[1],maxFeedRates[1]);
  } else {
    portMsg=String.format("$J=G91 X%.3f Y%.3f F%1.0f\n",(sinAngleYOffOrthogonality*jogStepSizes[1]),jogStepSizes[1],maxFeedRates[1]);
  }  
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button8_click1",0);
} //_CODE_:button8:961071:

public void button9_click1(GButton source, GEvent event) { //_CODE_:button9:924782:
  /* Y- jog */
  //logNCon("button9 - GButton >> GEvent." + event + " @ " + millis());
  if(0.0==angleYOffOrthogoality){
    portMsg=String.format("$J=G91 Y%.3f F%1.0f\n",-1.0*jogStepSizes[1],maxFeedRates[1]);
  } else {
    portMsg=String.format("$J=G91 X%.3f Y%.3f F%1.0f\n",(-1.0*sinAngleYOffOrthogonality*jogStepSizes[1]),-1.0*jogStepSizes[1],maxFeedRates[1]);
  }  
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button9_click1",0);
} //_CODE_:button9:924782:

public void button10_click1(GButton source, GEvent event) { //_CODE_:button10:565302:
  /* Z+ jog */
  //logNCon("button10 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%1.0f\n",jogStepSizes[2],maxFeedRates[2]);
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button10_click1",0);
} //_CODE_:button10:565302:

public void button11_click1(GButton source, GEvent event) { //_CODE_:button11:943670:
    /* Z- jog */
  //logNCon("button11 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%1.0f\n",-1.0*jogStepSizes[2],maxFeedRates[2]);
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button11_click1",0);
} //_CODE_:button11:943670:

public void button12_click1(GButton source, GEvent event) { //_CODE_:button12:882627:
    /* Jog Cancel */
  //logNCon("button12 - GButton >> GEvent." + event + " @ " + millis(),"button12_click1",1);
  portCode=0x85;
  ports[grblIndex].write(portCode);
  logNConPort(portCode+" which is 0x85 for Jog Cancel.  ","button12_click1",0);
} //_CODE_:button12:882627:

public void button13_click1(GButton source, GEvent event) { //_CODE_:button13:667400:
  /* $C which is  "Check GCode Mode   no actual movement"  */
  //logNCon("button13 - GButton >> GEvent." + event + " @ " + millis(),"button13_click1",1);  
  if(!checkGCodeMode){
    /* this initilization is a bit slow, so do not set the verboseLogging boolean to true untill after the logger is on line */
    initAuxiliarry1Log4j();
  }
  checkGCodeMode=!checkGCodeMode;
  label17.setVisible(checkGCodeMode);    
  portMsg=String.format("$C\n");
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button13_click1",0);
  button29.setText((checkGCodeMode?"Check":"Run")+" File");
  
  //button29.setTextBold();
} //_CODE_:button13:667400:

public void button17_click1(GButton source, GEvent event) { //_CODE_:button17:359874:
  /* sticky */
  //logNCon("button17 - GButton >> GEvent." + event + " @ " + millis(),"button17_click1",0);
  button17.setText("Jog Sliders:"+(custom_slider1.isStickToTicks()?"any value":" Decades"));
  custom_slider1.setStickToTicks(!custom_slider1.isStickToTicks());
  custom_slider2.setStickToTicks(!custom_slider2.isStickToTicks());
  custom_slider3.setStickToTicks(!custom_slider3.isStickToTicks());
  log.debug("ok4");
  if(custom_slider1.isStickToTicks()){
    /* change the text to reflect the now "stuck to decades" jog sizes */
    jogStepSizes[0]=(float)Math.pow(10.,custom_slider1.getValueF());
    label5.setText(String.format("(%11.3f,",jogStepSizes[0]));
    jogStepSizes[1]=(float)Math.pow(10.,custom_slider2.getValueF());
    label12.setText(String.format("%11.3f,",jogStepSizes[1]));
    jogStepSizes[2]=(float)Math.pow(10.,custom_slider3.getValueF());
    label13.setText(String.format("%11.3f )",jogStepSizes[2]));
  }
  log.debug("okA");
  //textfield7.setText("");
  //textfield8.setText("");
  //textfield9.setText("");
  //log.debug("okF");
} //_CODE_:button17:359874:

public void button18_click1(GButton source, GEvent event) { //_CODE_:button18:443664:
  /* $G  GCode parser state */
  //logNCon("button18 - GButton >> GEvent." + event + " @ " + millis(),"button18_click1",1);
  portMsg="$G\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button18_click1",0);
} //_CODE_:button18:443664:

public void button19_click1(GButton source, GEvent event) { //_CODE_:button19:588848:
  /* hold    feed hold  */
  //logNCon("button19 - GButton >> GEvent." + event + " @ " + millis(),"button19_click1",1);
  portMsg="!";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button19_click1",0);
} //_CODE_:button19:588848:

public void button20_click1(GButton source, GEvent event) { //_CODE_:button20:572445:
  /* cycle start */
  //logNCon("button20 - GButton >> GEvent." + event + " @ " + millis(),"button20_click1",1);
  portMsg="~";
  ports[grblIndex].write(portMsg);
} //_CODE_:button20:572445:

public void button21_click1(GButton source, GEvent event) { //_CODE_:button21:387580:
  logNCon("button21 - GButton >> GEvent." + event + " @ " + millis(),"button21_click1",1);
  log.debug("hit button21 which is Home");
  portMsg="$H\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button21_click1 (Home)",0);
} //_CODE_:button21:387580:

public void button23_click1(GButton source, GEvent event) { //_CODE_:button23:769832:
  /* $# to console    get the eprom stored G54-G59 et al */
  //logNCon("button23 - GButton >> GEvent." + event + " @ " + millis(),"button23_click1",0);
  portMsg="$#\n";
  ports[grblIndex].write(portMsg);
  hashtagParams2Console();
} //_CODE_:button23:769832:

public void button25_click1(GButton source, GEvent event) { //_CODE_:button25:326749:
  /* $$ get settings  */
  //logNCon("button25 - GButton >> GEvent." + event + " @ " + millis(),"button25_click1",1);
  portMsg="$$\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button25_click1",0);
} //_CODE_:button25:326749:

public void button26_click1(GButton source, GEvent event) { //_CODE_:button26:780178:
  /* $I version and options modified in config.h */
  //logNCon("button26 - GButton >> GEvent." + event + " @ " + millis(),"button26_click1",1);
  portMsg="$I\n";
  ports[grblIndex].write(portMsg);
  logNConPort(portMsg,"button26_click1",0);
} //_CODE_:button26:780178:

public void button28_click1(GButton source, GEvent event) { //_CODE_:button28:479591:
  /* Select File */
  //logNCon("button28 - GButton >> GEvent." + event + " @ " + millis(),"button27_click1",1);
  selectInput("Select a file to process:", "fileSelected");
} //_CODE_:button28:479591:

public void button29_click1(GButton source, GEvent event) { //_CODE_:button29:780174:
  /* Run File  or  Check File */
  //logNCon("button29 - GButton >> GEvent." + event + " @ " + millis(),"button29_click1",0);
  if(streaming) { 
    label22.setText("Allready streaming.  Multiple requests not allowed.");
  } else{    
    try {
      File file = new File(fid);
      if(file.exists()){
        label22.setText("");
        streaming=true;
        numStreamingOKs=0;
        numErrors=0;
        numRowsConfirmedProcessed=0;
        String fid=textfield2.getText();
        logNCon("about to start streaming with checkGCodeMode="+(checkGCodeMode?"true ":"false")+" on fid="+fid,"button29_click1",1);
        numRows=0;
        rowCounter=0;
        /* read it all the way thru to count number of rows */
        br = Files.newBufferedReader(Paths.get(fid));
        String line=null;
        while((line=br.readLine()) != null){
          line=line.trim();
          if(  (0<line.length())
            &&('('!=line.charAt(0))
            &&(';'!=line.charAt(0))
          ){
              rowCounter++;
          }
        }
        numRows=rowCounter;
        logNCon("numRows ="+numRows,"button29_click1",2);
        /* close it and set it up to be read by the SerialEvent buffer-stuffer */
        br.close();
        br = Files.newBufferedReader(Paths.get(fid)); 
        numLinesRead=0;
      } else {
        label22.setText("File does not exist");
      }  
    } catch (IOException e) {
       System.err.format("IOException: %s%n", e);
    }
    rowCounter=0;
  }  
  bufferedReaderSet=true;
} //_CODE_:button29:780174:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:textfield1:453045:
  //logNCon("textfield1 - GTextField >> GEvent." + event + " @ " + millis(),"textfield1_change1",0);
  if(event.toString().equals("ENTERED")){
    doExecuteCommand();  
  }
} //_CODE_:textfield1:453045:

public void textfield2_change1(GTextField source, GEvent event) { //_CODE_:textfield2:310946:
  //logNCon("textfield2 - GTextField >> GEvent." + event + " @ " + millis(),"textfield2_change1",0);
} //_CODE_:textfield2:310946:

public void textfield3_change1(GTextField source, GEvent event) { //_CODE_:textfield3:836285:
  //logNCon("textfield3 - GTextField >> GEvent." + event + " @ " + millis(),"textfield3_change1",0);
} //_CODE_:textfield3:836285:

public void textfield4_change1(GTextField source, GEvent event) { //_CODE_:textfield4:484938:
  //logNCon("textfield4 - GTextField >> GEvent." + event + " @ " + millis(),"textfield4_change1",0);
} //_CODE_:textfield4:484938:

public void textfield5_change1(GTextField source, GEvent event) { //_CODE_:textfield5:314240:
  //logNCon("textfield5 - GTextField >> GEvent." + event + " @ " + millis(),"textfield5_change1",0);
} //_CODE_:textfield5:314240:

public void textfield6_change1(GTextField source, GEvent event) { //_CODE_:textfield6:773759:
  //logNCon("textfield6 - GTextField >> GEvent." + event + " @ " + millis(),"textfield6_change1",0);
} //_CODE_:textfield6:773759:

public void custom_slider1_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider1:458552:
  jogStepSizes[0]=(float)Math.pow(10.,custom_slider1.getValueF());
  label5.setText(String.format("(%11.3f,",jogStepSizes[0]));
  textfield7.setText("");
} //_CODE_:custom_slider1:458552:

public void custom_slider2_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider2:439288:
  jogStepSizes[1]=(float)Math.pow(10.,custom_slider2.getValueF());
  label12.setText(String.format("%11.3f,",jogStepSizes[1]));
  textfield8.setText("");
} //_CODE_:custom_slider2:439288:

public void custom_slider3_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider3:534603:
  jogStepSizes[2]=(float)Math.pow(10.,custom_slider3.getValueF());
  label13.setText(String.format("%11.3f )",jogStepSizes[2]));
  textfield9.setText("");
} //_CODE_:custom_slider3:534603:

public void button34_click1(GButton source, GEvent event) { //_CODE_:button34:642288:
  logNCon("button to set X accel. Note this is sticy, it modifies the $120 within grbl.","button34_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(120==grblSettingIndices[ii]){
      try {
         grblSettings[ii]=  textfield4.getText();
         msg="$120="+textfield4.getText()+"\n";
         ports[grblIndex].write(msg);
         logNConPort(msg,"button34_click1",3);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button34:642288:

public void button35_click1(GButton source, GEvent event) { //_CODE_:button35:779492:
  logNCon("button to set Y accel.  Note this is sticy, it modifies the $121 within grbl.","button35_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(121==grblSettingIndices[ii]){
      try {
         grblSettings[ii]=  textfield5.getText();
         msg="$121="+textfield5.getText()+"\n";
         ports[grblIndex].write(msg);
         logNConPort(msg,"button35_click1",3);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button35:779492:

public void button36_click1(GButton source, GEvent event) { //_CODE_:button36:585904:
  logNCon("button to set Z accel.  Note this is sticy, it modifies the $122 within grbl.","button36_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(122==grblSettingIndices[ii]){
      try {
         grblSettings[ii]=  textfield6.getText();
         msg="$122="+textfield6.getText()+"\n";
         ports[grblIndex].write(msg);
         logNConPort(msg,"button36_click1",3);
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button36:585904:

public void button37_click1(GButton source, GEvent event) { //_CODE_:button37:731526:
  logNCon("button to set X speed.  Note this is NOT sticy... it Does not change the grbl $110","button37_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(110==grblSettingIndices[ii]){
      try {
         maxFeedRates[0]=Float.valueOf(textfield3.getText());
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button37:731526:

public void button39_click1(GButton source, GEvent event) { //_CODE_:button39:521786:
  System.exit(1);
} //_CODE_:button39:521786:

public void textfield7_change1(GTextField source, GEvent event) { //_CODE_:textfield7:368417:
  /**/logNCon("textfield7 - GTextField >> GEvent." + event + " @ " + millis(),"textfield7_change1",0);
  log.debug("event.getDesc() = "+ event.getDesc()  );
  log.debug("event.getType() = "+ event.getType()  );
  log.debug("event.name()    = "+ event.name()     );
  log.debug("event.getClass()= "+ event.getClass() );
  String tf7=textfield7.getText();
  if(0<tf7.length()){
    log.debug("|tf7|=|"+tf7+"|");
  } else {
    log.debug("tf7 is zero length");
  }

  if(event.getDesc().startsWith("Enter")){
    fiddleXJog(
      textfield7.getText(),
      button17.getText().equals("Jog Sliders: Decades")
    );
        delay(1000);
    //log.debug("returned from fiddleXJog");
      textfield7.setText("");
    //log.debug("setText to blank frameRate="+frameRate+" 1/frameRate="+1/frameRate);
    /* without this delay, an error occurs */
    //delay(100+1000*1/frameRate);

  } 
  log.debug("ok at textfield7 end"); 
} //_CODE_:textfield7:368417:

public void textfield8_change1(GTextField source, GEvent event) { //_CODE_:textfield8:301063:
  //logNCon("textfield8 - GTextField >> GEvent." + event + " @ " + millis(),"textfield8_change1",0);
   if(event.toString().equals("ENTERED")){
    fiddleYJog(
      textfield8.getText(),
      button17.getText().equals("Jog Sliders: Decades")
    );
    textfield8.setText("");
    delay(1000);
  }  
} //_CODE_:textfield8:301063:

public void textfield9_change1(GTextField source, GEvent event) { //_CODE_:textfield9:718169:
  //logNCon("textfield9 - GTextField >> GEvent." + event + " @ " + millis(),"textfield9_change1",0);
   if(event.toString().equals("ENTERED")){
    fiddleZJog(
      textfield9.getText(),
      button17.getText().equals("Jog Sliders: Decades")
    );
    textfield9.setText("");
    delay(1000);
  }  
} //_CODE_:textfield9:718169:

public void button40_click1(GButton source, GEvent event) { //_CODE_:button40:921130:
  //logNCon("button40 - GButton >> GEvent." + event + " @ " + millis(),"button40_click1",0);
  fiddleXJog(
    textfield7.getText(),
    button17.getText().equals("Jog Sliders: Decades")
  );
} //_CODE_:button40:921130:

public void button41_click1(GButton source, GEvent event) { //_CODE_:button41:878589:
  //logNCon("button41 - GButton >> GEvent." + event + " @ " + millis(),"button41_click1",0);
  fiddleYJog(
    textfield8.getText(),
    button17.getText().equals("Jog Sliders: Decades")
  );
} //_CODE_:button41:878589:

public void button42_click1(GButton source, GEvent event) { //_CODE_:button42:497621:
  //logNCon("button42 - GButton >> GEvent." + event + " @ " + millis(),"button42_click1",0);  
  fiddleZJog(
  textfield9.getText(),
    button17.getText().equals("Jog Sliders: Decades")
  );
} //_CODE_:button42:497621:

public void button43_click1(GButton source, GEvent event) { //_CODE_:button43:434828:
  logNCon("button43 - GButton >> GEvent." + event + " @ " + millis(),"button43_click1",0);
  doExecuteCommand();
} //_CODE_:button43:434828:

public void button44_click1(GButton source, GEvent event) { //_CODE_:button44:520328:
  //logNCon("button44 - GButton >> GEvent." + event + " @ " + millis(),"button44_click1",0);
  msg="G10 P"+activeWCO+" L20 X0 Y0 Z0 \n";
  ports[grblIndex].write(msg);
  logNConPort(msg,"button43_click1",0);
} //_CODE_:button44:520328:

public void button45_click1(GButton source, GEvent event) { //_CODE_:button45:782287:
  //println("button45 - GButton >> GEvent." + event + " @ " + millis(),"button45_click1",0);
  logNCon("button to set Y speed.  Note this is NOT sticy... it Does not change the grbl $111","button45_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(111==grblSettingIndices[ii]){
      try {
         maxFeedRates[1]=Float.valueOf(textfield10.getText());
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button45:782287:

public void button46_click1(GButton source, GEvent event) { //_CODE_:button46:803781:
  //println("button46 - GButton >> GEvent." + event + " @ " + millis(),"button46_click1",0);
  logNCon("button to set Z speed.  Note this is NOT sticy... it Does not change the grbl $112","button34_click1",0);
  for(int ii=0;ii<grblSettings.length;ii++){
    if(112==grblSettingIndices[ii]){
      try {
         maxFeedRates[2]=Float.valueOf(textfield11.getText());
      } catch (NumberFormatException nfe) {
        logNCon("NumberFormatException: " + nfe.getMessage(),"button34_click1",2);
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }
    }
  }
} //_CODE_:button46:803781:

public void textfield10_change1(GTextField source, GEvent event) { //_CODE_:textfield10:580428:
  println("textfield10 - GTextField >> GEvent." + event + " @ " + millis(),"textfield10_change1",0);
} //_CODE_:textfield10:580428:

public void textfield11_change1(GTextField source, GEvent event) { //_CODE_:textfield11:439011:
  println("textfield11 - GTextField >> GEvent." + event + " @ " + millis(),"textfield11_change1",0);
} //_CODE_:textfield11:439011:

public void button14_click1(GButton source, GEvent event) { //_CODE_:button14:953898:
  //println("button14 - GButton >> GEvent." + event + " @ " + millis());
  logNCon("The Big Red Switch was pushed:  ABORT","button14_click1",0);
  msg="!";
  ports[grblIndex].write(msg);
  logNConPort(msg,"button14_click1",1);
} //_CODE_:button14:953898:

public void option1_clicked1(GOption source, GEvent event) { //_CODE_:option1:358034:
  //println("option1 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=0;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G54\n";
  ports[grblIndex].write(msg);
  logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option1",1);
} //_CODE_:option1:358034:

public void option2_clicked1(GOption source, GEvent event) { //_CODE_:option2:440953:
  //println("option2 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=1;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G55\n";
  ports[grblIndex].write(msg);
  //logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option2",1);
} //_CODE_:option2:440953:

public void option3_clicked1(GOption source, GEvent event) { //_CODE_:option3:337746:
  //println("option3 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=2;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G56\n";
  ports[grblIndex].write(msg);
  //logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option3",1);
} //_CODE_:option3:337746:

public void option4_clicked1(GOption source, GEvent event) { //_CODE_:option4:569932:
  //println("option4 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=3;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G57\n";
  ports[grblIndex].write(msg);
  //logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option4",1);
} //_CODE_:option4:569932:

public void option5_clicked1(GOption source, GEvent event) { //_CODE_:option5:494957:
  //println("option5 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=4;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G58\n";
  ports[grblIndex].write(msg);
  //logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option5",1);
} //_CODE_:option5:494957:

public void option6_clicked1(GOption source, GEvent event) { //_CODE_:option6:719768:
  //println("option6 - GOption >> GEvent." + event + " @ " + millis());
  activeWCO=5;
  labelPreTexts[1]=String.format("W%dXYZ:",activeWCO);
  msg="G59\n";
  ports[grblIndex].write(msg);
  //logNConPort("setting active WCO (World CoOrdinate system) to "+msg,"togGroup1 option6",1);
} //_CODE_:option6:719768:

public void textarea1_change1(GTextArea source, GEvent event) { //_CODE_:textarea1:703533:
  //println("textarea1 - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:textarea1:703533:

public void button15_click1(GButton source, GEvent event) { //_CODE_:button15:286484:
  //println("button15 - GButton >> GEvent." + event + " @ " + millis());  
  if(!verboseLogging){
    /* this initilization is a bit slow, so do not set the verboseLogging boolean to true untill after the logger is on line */
    initAuxiliarry0Log4j();
  }
  log.debug("post initaux");
  verboseLogging=!verboseLogging;
  button15.setText("go2 "+(verboseLogging ?"sparse ":"verbose ")+"logging");
} //_CODE_:button15:286484:

public void button16_click1(GButton source, GEvent event) { //_CODE_:button16:996990:
  //println("button16 - GButton >> GEvent." + event + " @ " + millis()+" state="+state);
  //log.debug("buton16_click1 "+event.toString());
  int state=joy0.getXResponseState();
  joy0.setResponseStatesAreSticky(true);
  switch(state) {
    case 0: 
      button16.setText("Joy X Throttle");
      button16.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
      //labelPreTexts[21]="X state=1 preState="+joy0.getPriorXResponseState();
      break;
    case 1: 
      button16.setText("Joy X Off");
      button16.setLocalColorScheme(GCScheme.RED_SCHEME);
      //labelPreTexts[21]="X state=2 preState="+joy0.getPriorXResponseState();
      break;
    case 2: 
      button16.setText("Joy X Full");
      button16.setLocalColorScheme(GCScheme.BLUE_SCHEME);
      //labelPreTexts[21]="X state=0 preState="+joy0.getPriorXResponseState();
      break;
    default: button16.setText("WTF");
      break;
  }
  //labelPreTexts[31]="responseStatesAreSticky="+(joy0.getResponseStatesAreSticky()?"true":"false");
  joy0.setXResponseState((state+1)%3);
  //joy0.setPriorXResponseState((state+1)%3);
} //_CODE_:button16:996990:

public void button24_click1(GButton source, GEvent event) { //_CODE_:button24:719710:
  //println("button24 - GButton >> GEvent." + event + " @ " + millis()+" state="+state);
  //log.debug("buton24_click1 "+event.toString());
  int state=joy0.getYResponseState();
  joy0.setResponseStatesAreSticky(true);
  switch(state) {
    case 0: 
      button24.setText("Joy Y Part");
      button24.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
      //labelPreTexts[29]="Y state=1 preState="+joy0.getPriorYResponseState();
      //labelPreTexts[31]="Sticky=true";
      break;
    case 1: 
      button24.setText("Joy Y Off");
      button24.setLocalColorScheme(GCScheme.RED_SCHEME);
      //labelPreTexts[29]="Y state=2 preState="+joy0.getPriorYResponseState();
      break;
    case 2: 
      button24.setText("Joy Y Full");
      button24.setLocalColorScheme(GCScheme.BLUE_SCHEME);
      //labelPreTexts[29]="Y state=0 preState="+joy0.getPriorYResponseState();
      break;
    default: button24.setText("WTF");
      break;
  }
  //labelPreTexts[31]="responseStatesAreSticky="+(joy0.getResponseStatesAreSticky()?"true":"false");
  joy0.setYResponseState((state+1)%3);
  //joy0.setPriorYResponseState((state+1)%3);
} //_CODE_:button24:719710:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  GButton.useRoundCorners(false);
  G4P.setDisplayFont("Monospaced", G4P.PLAIN, 20);
  G4P.setInputFont("Monospaced", G4P.PLAIN, 20);
  G4P.setSliderFont("Arial", G4P.PLAIN, 20);
  surface.setTitle("Sketch Window");
  button22 = new GButton(this, 257, 802, 240, 37);
  button22.setText("Initializing");
  button22.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button22.addEventHandler(this, "button22_click1");
  button1 = new GButton(this, 10, 130, 50, 50);
  button1.setText("X-");
  button1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  button2 = new GButton(this, 126, 130, 50, 50);
  button2.setText("X+");
  button2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button2.addEventHandler(this, "button2_click1");
  button3 = new GButton(this, 165, 314, 110, 30);
  button3.setText("Reset X");
  button3.setLocalColorScheme(GCScheme.SCHEME_9);
  button3.addEventHandler(this, "button3_click1");
  button4 = new GButton(this, 335, 314, 120, 30);
  button4.setText("Reset Y");
  button4.setLocalColorScheme(GCScheme.SCHEME_9);
  button4.addEventHandler(this, "button4_click1");
  button5 = new GButton(this, 516, 314, 120, 30);
  button5.setText("Reset Z");
  button5.setLocalColorScheme(GCScheme.SCHEME_9);
  button5.addEventHandler(this, "button5_click1");
  button6 = new GButton(this, 300, 80, 200, 30);
  button6.setText("Kill Alarm Lock");
  button6.addEventHandler(this, "button6_click1");
  button7 = new GButton(this, 299, 122, 200, 30);
  button7.setText("Reset Grbl");
  button7.addEventHandler(this, "button7_click1");
  button8 = new GButton(this, 69, 80, 50, 50);
  button8.setText("Y+");
  button8.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button8.addEventHandler(this, "button8_click1");
  button9 = new GButton(this, 67, 186, 50, 50);
  button9.setText("Y-");
  button9.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button9.addEventHandler(this, "button9_click1");
  button10 = new GButton(this, 205, 83, 60, 60);
  button10.setText("Z+");
  button10.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button10.addEventHandler(this, "button10_click1");
  button11 = new GButton(this, 205, 170, 60, 60);
  button11.setText("Z-");
  button11.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button11.addEventHandler(this, "button11_click1");
  button12 = new GButton(this, 520, 120, 140, 30);
  button12.setText("Jog Cancel");
  button12.addEventHandler(this, "button12_click1");
  button13 = new GButton(this, 440, 160, 60, 30);
  button13.setText("$C");
  button13.addEventHandler(this, "button13_click1");
  button17 = new GButton(this, 0, 363, 122, 112);
  button17.setText("Jog Sliders: Decades");
  button17.setLocalColorScheme(GCScheme.SCHEME_9);
  button17.addEventHandler(this, "button17_click1");
  button18 = new GButton(this, 300, 159, 59, 30);
  button18.setText("$G");
  button18.addEventHandler(this, "button18_click1");
  button19 = new GButton(this, 681, 79, 210, 160);
  button19.setText("HOLD");
  button19.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  button19.addEventHandler(this, "button19_click1");
  button20 = new GButton(this, 440, 200, 60, 30);
  button20.setText("~");
  button20.addEventHandler(this, "button20_click1");
  button21 = new GButton(this, 520, 80, 140, 30);
  button21.setText("Home");
  button21.addEventHandler(this, "button21_click1");
  button23 = new GButton(this, 300, 200, 60, 30);
  button23.setText("$#");
  button23.addEventHandler(this, "button23_click1");
  button25 = new GButton(this, 368, 160, 60, 30);
  button25.setText("$$");
  button25.addEventHandler(this, "button25_click1");
  button26 = new GButton(this, 370, 200, 60, 30);
  button26.setText("$I");
  button26.addEventHandler(this, "button26_click1");
  button28 = new GButton(this, 20, 652, 141, 30);
  button28.setText("Select File");
  button28.addEventHandler(this, "button28_click1");
  button29 = new GButton(this, 19, 686, 141, 30);
  button29.setText("Run File");
  button29.addEventHandler(this, "button29_click1");
  label1 = new GLabel(this, 10, 241, 80, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("W XYZ:");
  label1.setOpaque(false);
  label2 = new GLabel(this, 80, 240, 210, 30);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("-1234.123");
  label2.setLocalColorScheme(GCScheme.SCHEME_9);
  label2.setOpaque(false);
  label3 = new GLabel(this, 0, 0, 260, 30);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("Active State:");
  label3.setLocalColorScheme(GCScheme.SCHEME_9);
  label3.setOpaque(false);
  label5 = new GLabel(this, 113, 354, 180, 30);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("(  -1234.123,");
  label5.setLocalColorScheme(GCScheme.SCHEME_9);
  label5.setOpaque(false);
  label6 = new GLabel(this, 10, 280, 80, 20);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("M XYZ:");
  label6.setOpaque(false);
  label7 = new GLabel(this, 122, 280, 180, 30);
  label7.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label7.setText("(-12345.123");
  label7.setLocalColorScheme(GCScheme.SCHEME_9);
  label7.setOpaque(false);
  label8 = new GLabel(this, 303, 280, 190, 30);
  label8.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label8.setText("-12345.123,");
  label8.setLocalColorScheme(GCScheme.SCHEME_9);
  label8.setOpaque(false);
  label9 = new GLabel(this, 491, 281, 160, 30);
  label9.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label9.setText("l-12345.123 )");
  label9.setLocalColorScheme(GCScheme.SCHEME_9);
  label9.setOpaque(false);
  label10 = new GLabel(this, 272, 241, 190, 30);
  label10.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label10.setText("-12345.123,");
  label10.setLocalColorScheme(GCScheme.SCHEME_9);
  label10.setOpaque(false);
  label11 = new GLabel(this, 450, 239, 200, 30);
  label11.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label11.setText("-12345.123)");
  label11.setLocalColorScheme(GCScheme.SCHEME_9);
  label11.setOpaque(false);
  label12 = new GLabel(this, 295, 353, 190, 30);
  label12.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label12.setText(" -1234.123,");
  label12.setLocalColorScheme(GCScheme.SCHEME_9);
  label12.setOpaque(false);
  label13 = new GLabel(this, 488, 354, 169, 30);
  label13.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label13.setText(" -1234.123 )");
  label13.setLocalColorScheme(GCScheme.SCHEME_9);
  label13.setOpaque(false);
  label14 = new GLabel(this, 242, 1, 133, 30);
  label14.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label14.setText("???");
  label14.setLocalColorScheme(GCScheme.SCHEME_9);
  label14.setOpaque(false);
  label15 = new GLabel(this, 360, 0, 530, 20);
  label15.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label15.setText("GRBL has not yet output any msg");
  label15.setOpaque(false);
  label16 = new GLabel(this, 680, 240, 210, 30);
  label16.setText("   Feed:");
  label16.setOpaque(false);
  label18 = new GLabel(this, 680, 270, 210, 30);
  label18.setText("Spindle: n/a");
  label18.setOpaque(false);
  label20 = new GLabel(this, 680, 299, 210, 30);
  label20.setText("  Laser: n/a");
  label20.setOpaque(false);
  label22 = new GLabel(this, 0, 30, 900, 50);
  label22.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label22.setLocalColorScheme(GCScheme.RED_SCHEME);
  label22.setOpaque(false);
  label23 = new GLabel(this, 158, 571, 125, 20);
  label23.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label23.setText("X Limit: Off");
  label23.setLocalColorScheme(GCScheme.SCHEME_9);
  label23.setOpaque(false);
  label24 = new GLabel(this, 319, 570, 130, 20);
  label24.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label24.setText("Y Limit: Off");
  label24.setLocalColorScheme(GCScheme.SCHEME_9);
  label24.setOpaque(false);
  label25 = new GLabel(this, 489, 569, 130, 19);
  label25.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label25.setText("Z Limit: Off");
  label25.setLocalColorScheme(GCScheme.SCHEME_9);
  label25.setOpaque(false);
  label26 = new GLabel(this, 679, 330, 210, 30);
  label26.setText("  Probe: Off");
  label26.setOpaque(false);
  label27 = new GLabel(this, 680, 360, 210, 30);
  label27.setText("   Door: Closed");
  label27.setOpaque(false);
  label28 = new GLabel(this, 1, 763, 86, 20);
  label28.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label28.setText("Command:");
  label28.setOpaque(false);
  label30 = new GLabel(this, 13, 724, 80, 20);
  label30.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label30.setText("File:");
  label30.setOpaque(false);
  textfield1 = new GTextField(this, 81, 760, 813, 30, G4P.SCROLLBARS_NONE);
  textfield1.setOpaque(true);
  textfield1.addEventHandler(this, "textfield1_change1");
  textfield2 = new GTextField(this, 82, 721, 813, 30, G4P.SCROLLBARS_NONE);
  textfield2.setOpaque(true);
  textfield2.addEventHandler(this, "textfield2_change1");
  textfield3 = new GTextField(this, 214, 491, 68, 30, G4P.SCROLLBARS_NONE);
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  textfield4 = new GTextField(this, 222, 523, 60, 30, G4P.SCROLLBARS_NONE);
  textfield4.setOpaque(true);
  textfield4.addEventHandler(this, "textfield4_change1");
  textfield5 = new GTextField(this, 398, 524, 60, 30, G4P.SCROLLBARS_NONE);
  textfield5.setOpaque(true);
  textfield5.addEventHandler(this, "textfield5_change1");
  textfield6 = new GTextField(this, 583, 524, 60, 30, G4P.SCROLLBARS_NONE);
  textfield6.setOpaque(true);
  textfield6.addEventHandler(this, "textfield6_change1");
  custom_slider1 = new GCustomSlider(this, 121, 383, 163, 30, "green_red20px");
  custom_slider1.setLimits(0.0, -2.0, 4.0);
  custom_slider1.setNbrTicks(7);
  custom_slider1.setStickToTicks(true);
  custom_slider1.setShowTicks(true);
  custom_slider1.setNumberFormat(G4P.DECIMAL, 1);
  custom_slider1.setOpaque(false);
  custom_slider1.addEventHandler(this, "custom_slider1_change1");
  custom_slider2 = new GCustomSlider(this, 304, 383, 160, 30, "green_red20px");
  custom_slider2.setLimits(0.0, -2.0, 4.0);
  custom_slider2.setNbrTicks(7);
  custom_slider2.setStickToTicks(true);
  custom_slider2.setShowTicks(true);
  custom_slider2.setNumberFormat(G4P.DECIMAL, 1);
  custom_slider2.setOpaque(false);
  custom_slider2.addEventHandler(this, "custom_slider2_change1");
  custom_slider3 = new GCustomSlider(this, 491, 383, 160, 30, "green_red20px");
  custom_slider3.setLimits(0.0, -2.0, 4.0);
  custom_slider3.setNbrTicks(7);
  custom_slider3.setStickToTicks(true);
  custom_slider3.setShowTicks(true);
  custom_slider3.setNumberFormat(G4P.DECIMAL, 1);
  custom_slider3.setOpaque(false);
  custom_slider3.addEventHandler(this, "custom_slider3_change1");
  button34 = new GButton(this, 127, 524, 96, 30);
  button34.setText("Set Accel");
  button34.setLocalColorScheme(GCScheme.SCHEME_9);
  button34.addEventHandler(this, "button34_click1");
  button35 = new GButton(this, 301, 524, 96, 30);
  button35.setText("Set Accel");
  button35.setLocalColorScheme(GCScheme.SCHEME_9);
  button35.addEventHandler(this, "button35_click1");
  button36 = new GButton(this, 486, 524, 96, 30);
  button36.setText("Set Accel");
  button36.setLocalColorScheme(GCScheme.SCHEME_9);
  button36.addEventHandler(this, "button36_click1");
  button37 = new GButton(this, 127, 490, 85, 30);
  button37.setText("Set Feed");
  button37.setLocalColorScheme(GCScheme.SCHEME_9);
  button37.addEventHandler(this, "button37_click1");
  button39 = new GButton(this, 752, 798, 141, 44);
  button39.setText("Exit");
  button39.setLocalColorScheme(GCScheme.SCHEME_9);
  button39.addEventHandler(this, "button39_click1");
  label17 = new GLabel(this, 520, 162, 140, 30);
  label17.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label17.setText("No Motion");
  label17.setLocalColorScheme(GCScheme.SCHEME_14);
  label17.setOpaque(true);
  textfield7 = new GTextField(this, 126, 420, 154, 30, G4P.SCROLLBARS_NONE);
  textfield7.setOpaque(true);
  textfield7.addEventHandler(this, "textfield7_change1");
  textfield8 = new GTextField(this, 302, 419, 154, 30, G4P.SCROLLBARS_NONE);
  textfield8.setOpaque(true);
  textfield8.addEventHandler(this, "textfield8_change1");
  textfield9 = new GTextField(this, 490, 420, 154, 30, G4P.SCROLLBARS_NONE);
  textfield9.setOpaque(true);
  textfield9.addEventHandler(this, "textfield9_change1");
  button40 = new GButton(this, 127, 456, 154, 30);
  button40.setText("Set X Jog");
  button40.setLocalColorScheme(GCScheme.SCHEME_9);
  button40.addEventHandler(this, "button40_click1");
  button41 = new GButton(this, 302, 455, 154, 30);
  button41.setText("Set Y Jog");
  button41.setLocalColorScheme(GCScheme.SCHEME_9);
  button41.addEventHandler(this, "button41_click1");
  button42 = new GButton(this, 491, 454, 154, 30);
  button42.setText("Set Z Jog");
  button42.setLocalColorScheme(GCScheme.SCHEME_9);
  button42.addEventHandler(this, "button42_click1");
  button43 = new GButton(this, 30, 802, 220, 38);
  button43.setText("Execute Command");
  button43.addEventHandler(this, "button43_click1");
  button44 = new GButton(this, 1, 314, 126, 30);
  button44.setText("Reset XYZ");
  button44.setLocalColorScheme(GCScheme.SCHEME_9);
  button44.addEventHandler(this, "button44_click1");
  button45 = new GButton(this, 302, 490, 85, 30);
  button45.setText("Set Feed");
  button45.setLocalColorScheme(GCScheme.SCHEME_9);
  button45.addEventHandler(this, "button45_click1");
  button46 = new GButton(this, 486, 489, 85, 30);
  button46.setText("Set Feed");
  button46.setLocalColorScheme(GCScheme.SCHEME_9);
  button46.addEventHandler(this, "button46_click1");
  textfield10 = new GTextField(this, 389, 490, 68, 30, G4P.SCROLLBARS_NONE);
  textfield10.setOpaque(true);
  textfield10.addEventHandler(this, "textfield10_change1");
  textfield11 = new GTextField(this, 573, 489, 68, 30, G4P.SCROLLBARS_NONE);
  textfield11.setOpaque(true);
  textfield11.addEventHandler(this, "textfield11_change1");
  button14 = new GButton(this, 680, 550, 210, 160);
  button14.setText("BRS");
  button14.setLocalColorScheme(GCScheme.RED_SCHEME);
  button14.addEventHandler(this, "button14_click1");
  togGroup1 = new GToggleGroup();
  option1 = new GOption(this, 28, 514, 60, 20);
  option1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option1.setText("G54");
  option1.setOpaque(false);
  option1.addEventHandler(this, "option1_clicked1");
  option2 = new GOption(this, 28, 534, 60, 20);
  option2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option2.setText("G55");
  option2.setOpaque(false);
  option2.addEventHandler(this, "option2_clicked1");
  option3 = new GOption(this, 28, 554, 60, 20);
  option3.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option3.setText("G56");
  option3.setOpaque(false);
  option3.addEventHandler(this, "option3_clicked1");
  option4 = new GOption(this, 28, 574, 60, 20);
  option4.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option4.setText("G57");
  option4.setOpaque(false);
  option4.addEventHandler(this, "option4_clicked1");
  option5 = new GOption(this, 28, 594, 60, 20);
  option5.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option5.setText("G58");
  option5.setOpaque(false);
  option5.addEventHandler(this, "option5_clicked1");
  option6 = new GOption(this, 28, 614, 60, 20);
  option6.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option6.setText("G59");
  option6.setOpaque(false);
  option6.addEventHandler(this, "option6_clicked1");
  togGroup1.addControl(option1);
  option1.setSelected(true);
  togGroup1.addControl(option2);
  togGroup1.addControl(option3);
  togGroup1.addControl(option4);
  togGroup1.addControl(option5);
  togGroup1.addControl(option6);
  textarea1 = new GTextArea(this, 5, 480, 114, 164, G4P.SCROLLBARS_NONE);
  textarea1.setText("Work Coord");
  textarea1.setOpaque(true);
  textarea1.addEventHandler(this, "textarea1_change1");
  label4 = new GLabel(this, 519, 198, 130, 30);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("See Joystick");
  label4.setOpaque(false);
  label19 = new GLabel(this, 680, 390, 210, 30);
  label19.setText("Joy Throttle");
  label19.setOpaque(false);
  button15 = new GButton(this, 504, 801, 240, 37);
  button15.setText("go2 verbose logging");
  button15.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button15.addEventHandler(this, "button15_click1");
  button16 = new GButton(this, 680, 420, 210, 30);
  button16.setText("Joy X Full");
  button16.addEventHandler(this, "button16_click1");
  button24 = new GButton(this, 681, 454, 210, 30);
  button24.setText("Joy Y Full");
  button24.addEventHandler(this, "button24_click1");
}

// Variable declarations 
// autogenerated do not edit
GButton button22; 
GButton button1; 
GButton button2; 
GButton button3; 
GButton button4; 
GButton button5; 
GButton button6; 
GButton button7; 
GButton button8; 
GButton button9; 
GButton button10; 
GButton button11; 
GButton button12; 
GButton button13; 
GButton button17; 
GButton button18; 
GButton button19; 
GButton button20; 
GButton button21; 
GButton button23; 
GButton button25; 
GButton button26; 
GButton button28; 
GButton button29; 
GLabel label1; 
GLabel label2; 
GLabel label3; 
GLabel label5; 
GLabel label6; 
GLabel label7; 
GLabel label8; 
GLabel label9; 
GLabel label10; 
GLabel label11; 
GLabel label12; 
GLabel label13; 
GLabel label14; 
GLabel label15; 
GLabel label16; 
GLabel label18; 
GLabel label20; 
GLabel label22; 
GLabel label23; 
GLabel label24; 
GLabel label25; 
GLabel label26; 
GLabel label27; 
GLabel label28; 
GLabel label30; 
GTextField textfield1; 
GTextField textfield2; 
GTextField textfield3; 
GTextField textfield4; 
GTextField textfield5; 
GTextField textfield6; 
GCustomSlider custom_slider1; 
GCustomSlider custom_slider2; 
GCustomSlider custom_slider3; 
GButton button34; 
GButton button35; 
GButton button36; 
GButton button37; 
GButton button39; 
GLabel label17; 
GTextField textfield7; 
GTextField textfield8; 
GTextField textfield9; 
GButton button40; 
GButton button41; 
GButton button42; 
GButton button43; 
GButton button44; 
GButton button45; 
GButton button46; 
GTextField textfield10; 
GTextField textfield11; 
GButton button14; 
GToggleGroup togGroup1; 
GOption option1; 
GOption option2; 
GOption option3; 
GOption option4; 
GOption option5; 
GOption option6; 
GTextArea textarea1; 
GLabel label4; 
GLabel label19; 
GButton button15; 
GButton button16; 
GButton button24; 
