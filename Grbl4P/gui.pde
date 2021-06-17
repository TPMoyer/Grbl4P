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
  button22.setText((verboseOutput ?"halt ":"provide ")+"verbose output");
} //_CODE_:button22:773336:

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:294684:
  /* X- jog */
  //logNCon("button1 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%.0f\n",-1.0*jogStepSizes[0],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button1:294684:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:538427:
  /* X+ jog */
  //logNCon("button2 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%.0f\n",jogStepSizes[0],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button2:538427:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:814160:
  /* reset X */
  //logNCon("button3 - GButton >> GEvent." + event + " @ " + millis());  
  portMsg="G10 P0 L20 X0\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button3:814160:

public void button4_click1(GButton source, GEvent event) { //_CODE_:button4:900152:
  /* reset Y */
  //logNCon("button4 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Y0\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button4:900152:

public void button5_click1(GButton source, GEvent event) { //_CODE_:button5:671405:
  /* reset Z */
  //logNCon("button5 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Z0\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button5:671405:

public void button6_click1(GButton source, GEvent event) { //_CODE_:button6:996513:
  //logNCon("button6 - GButton >> GEvent." + event + " @ " + millis());
  /* kill alarm lock */
  portMsg="$X\n";
  port.write(portMsg);
  logNConPort(portMsg);
 } //_CODE_:button6:996513:

public void button7_click1(GButton source, GEvent event) { //_CODE_:button7:509439:
  /* RESET */
  //logNCon("button7 - GButton >> GEvent." + event + " @ " + millis());
  portCode=0x18; /* ctrl-x */
  port.write(portCode);
  logNConPort(portMsg+" which is 0x18 for reset");
  
} //_CODE_:button7:509439:

public void button8_click1(GButton source, GEvent event) { //_CODE_:button8:961071:
  /* Y+ jog */
  //logNCon("button8 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Y%.3f F%.0f\n",jogStepSizes[1],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button8:961071:

public void button9_click1(GButton source, GEvent event) { //_CODE_:button9:924782:
  /* Y- jog */
  //logNCon("button9 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Y%.3f F%.0f\n",-1.0*jogStepSizes[1],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button9:924782:

public void button10_click1(GButton source, GEvent event) { //_CODE_:button10:565302:
  /* Z+ jog */
  //logNCon("button10 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%.0f\n",jogStepSizes[2],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button10:565302:

public void button11_click1(GButton source, GEvent event) { //_CODE_:button11:943670:
    /* Z- jog */
  //logNCon("button11 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%.0f\n",-1.0*jogStepSizes[2],maxFeedRate);
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button11:943670:

public void button12_click1(GButton source, GEvent event) { //_CODE_:button12:882627:
    /* Jog Cancel */
  //logNCon("button12 - GButton >> GEvent." + event + " @ " + millis());
  portCode=0x85;
  port.write(portCode);
  logNConPort(portCode+" which is 0x85 for Jog Cancel");
} //_CODE_:button12:882627:

public void button13_click1(GButton source, GEvent event) { //_CODE_:button13:667400:
  /* $C which is  "Check GCode Mode   no actual movement"  */
  //logNCon("button13 - GButton >> GEvent." + event + " @ " + millis());
  checkGCodeMode=!checkGCodeMode;
  label17.setVisible(checkGCodeMode);    
  portMsg=String.format("$C\n");
  port.write(portMsg);
  logNConPort(portMsg);
  button29.setText((checkGCodeMode?"Check":"Run")+" File");
  button29.setTextBold();
} //_CODE_:button13:667400:

public void button14_click1(GButton source, GEvent event) { //_CODE_:button14:592098:
  /* Home X */
  //logNCon("button14 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HX\n");
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button14:592098:

public void button15_click1(GButton source, GEvent event) { //_CODE_:button15:495811:
  /* Home Y */
  //logNCon("button15 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HY\n");
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button15:495811:

public void button16_click1(GButton source, GEvent event) { //_CODE_:button16:216127:
  /* Home Z */
  //logNCon("button16 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HZ\n");
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button16:216127:

public void button17_click1(GButton source, GEvent event) { //_CODE_:button17:359874:
  /* sticky */
  logNCon("button17 - GButton >> GEvent." + event + " @ " + millis());
  button17.setText("Jog Sliders:"+(custom_slider1.isStickToTicks()?"any value":" Decades"));
  custom_slider1.setStickToTicks(!custom_slider1.isStickToTicks());
  custom_slider2.setStickToTicks(!custom_slider2.isStickToTicks());
  custom_slider3.setStickToTicks(!custom_slider3.isStickToTicks());
  if(custom_slider1.isStickToTicks()){
    /* change the text to reflect the now "stuck to decades" jog sizes */
    jogStepSizes[0]=(float)Math.pow(10.,custom_slider1.getValueF());
    label5.setText(String.format("(%11.3f,",jogStepSizes[0]));
    jogStepSizes[1]=(float)Math.pow(10.,custom_slider2.getValueF());
    label12.setText(String.format("%11.3f,",jogStepSizes[1]));
    jogStepSizes[2]=(float)Math.pow(10.,custom_slider3.getValueF());
    label13.setText(String.format("%11.3f )",jogStepSizes[2]));
  }
} //_CODE_:button17:359874:

public void button18_click1(GButton source, GEvent event) { //_CODE_:button18:443664:
  /* $G  GCode parser state */
  //logNCon("button18 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$G\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button18:443664:

public void button19_click1(GButton source, GEvent event) { //_CODE_:button19:588848:
  /* hold    feed hold  */
  //logNCon("button19 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="!";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button19:588848:

public void button20_click1(GButton source, GEvent event) { //_CODE_:button20:572445:
  /* cycle start */
  //logNCon("button20 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="~";
  port.write(portMsg);
} //_CODE_:button20:572445:

public void button21_click1(GButton source, GEvent event) { //_CODE_:button21:387580:
  logNCon("button21 - GButton >> GEvent." + event + " @ " + millis());
  log.debug("hit button21 which is Home");
  portMsg="$H\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button21:387580:

public void button23_click1(GButton source, GEvent event) { //_CODE_:button23:769832:
  /* $# to console    get the eprom stored G54-G59 et al */
  //logNCon("button23 - GButton >> GEvent." + event + " @ " + millis());
  hashtagParams2Console();
} //_CODE_:button23:769832:

public void button24_click1(GButton source, GEvent event) { //_CODE_:button24:237649:
  /* SetX 871 */
  //logNCon("button24 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 X"+homes2WorkAllPositive[0]+"\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button24:237649:

public void button25_click1(GButton source, GEvent event) { //_CODE_:button25:326749:
  /* $$ get settings  */
  //logNCon("button25 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$$\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button25:326749:

public void button26_click1(GButton source, GEvent event) { //_CODE_:button26:780178:
  /* $I version and options modified in config.h */
  //logNCon("button26 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$I\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button26:780178:

public void button27_click1(GButton source, GEvent event) { //_CODE_:button27:497951:
  /* GoTo 861.5 */
  //logNCon("button27 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 X"+homes2WorkAllPositive[0]+" F500\n";
  port.write(portMsg);
  logNConPort(portMsg); 
} //_CODE_:button27:497951:

public void button28_click1(GButton source, GEvent event) { //_CODE_:button28:479591:
  /* Select File */
  //logNCon("button28 - GButton >> GEvent." + event + " @ " + millis());
  selectInput("Select a file to process:", "fileSelected");
} //_CODE_:button28:479591:

public void button29_click1(GButton source, GEvent event) { //_CODE_:button29:780174:
  /* Run File  or  Check File */
  //logNCon("button29 - GButton >> GEvent." + event + " @ " + millis());
  if(streaming) { 
    label22.setText("Allready streaming.  Multiple requests not allowed.");
  } else{
    streaming=true;
    numOKs=0;
    numErrors=0;
    numRowsConfirmedProcessed=0;
    String fid=textfield2.getText();
    logNCon("about to start streaming with checkGCodeMode="+(checkGCodeMode?"true ":"false")+" on fid="+fid);
    numRows=0;
    rowCounter=0;
    try {
      br = Files.newBufferedReader(Paths.get(fid));    
      while(br.readLine() != null){
        rowCounter++;
      }
      numRows=rowCounter;
      logNCon("numRows ="+numRows);
      br.close();
      br = Files.newBufferedReader(Paths.get(fid)); 
    } catch (IOException e) {
       System.err.format("IOException: %s%n", e);
    }
    rowCounter=0;
  }  
  bufferedReaderSet=true;
} //_CODE_:button29:780174:

public void button30_click1(GButton source, GEvent event) { //_CODE_:button30:567279:
  /* SetX 871 */
  //logNCon("button30 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Y"+homes2WorkAllPositive[1]+"\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button30:567279:

public void button31_click1(GButton source, GEvent event) { //_CODE_:button31:294771:
  /* GoTo 861.5 */
  //logNCon("button31 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 Y"+homes2WorkAllPositive[1]+" F500\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button31:294771:

public void button32_click1(GButton source, GEvent event) { //_CODE_:button32:675398:
  /* SetX 871 */
  //logNCon("button32 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Z"+homes2WorkAllPositive[2]+"\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button32:675398:

public void button33_click1(GButton source, GEvent event) { //_CODE_:button33:449443:
    /* GoTo 861.5 */
  //logNCon("button33 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 Z"+homes2WorkAllPositive[2]+" F500\n";
  port.write(portMsg);
  logNConPort(portMsg);
} //_CODE_:button33:449443:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:textfield1:453045:
  //logNCon("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield1:453045:

public void textfield2_change1(GTextField source, GEvent event) { //_CODE_:textfield2:310946:
  logNCon("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield2:310946:

public void textfield3_change1(GTextField source, GEvent event) { //_CODE_:textfield3:836285:
  logNCon("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield3:836285:

public void textfield4_change1(GTextField source, GEvent event) { //_CODE_:textfield4:484938:
  logNCon("textfield4 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield4:484938:

public void textfield5_change1(GTextField source, GEvent event) { //_CODE_:textfield5:314240:
  logNCon("textfield5 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield5:314240:

public void textfield6_change1(GTextField source, GEvent event) { //_CODE_:textfield6:773759:
  logNCon("textfield6 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield6:773759:

public void custom_slider1_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider1:458552:
  jogStepSizes[0]=(float)Math.pow(10.,custom_slider1.getValueF());
  label5.setText(String.format("(%11.3f,",jogStepSizes[0]));
} //_CODE_:custom_slider1:458552:

public void custom_slider2_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider2:439288:
  jogStepSizes[1]=(float)Math.pow(10.,custom_slider2.getValueF());
  label12.setText(String.format("%11.3f,",jogStepSizes[1]));
} //_CODE_:custom_slider2:439288:

public void custom_slider3_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider3:534603:
  jogStepSizes[2]=(float)Math.pow(10.,custom_slider3.getValueF());
  label13.setText(String.format("%11.3f )",jogStepSizes[2]));
} //_CODE_:custom_slider3:534603:

public void button34_click1(GButton source, GEvent event) { //_CODE_:button34:642288:

} //_CODE_:button34:642288:

public void button35_click1(GButton source, GEvent event) { //_CODE_:button35:779492:

} //_CODE_:button35:779492:

public void button36_click1(GButton source, GEvent event) { //_CODE_:button36:585904:

} //_CODE_:button36:585904:

public void button37_click1(GButton source, GEvent event) { //_CODE_:button37:731526:

} //_CODE_:button37:731526:

public void button38_click1(GButton source, GEvent event) { //_CODE_:button38:722903:
  if(individualHomesEnabled){
    button38.setText("Individual axis homing");
    button14.setVisible(false);
    button15.setVisible(false);
    button16.setVisible(false);    
  } else {
    button38.setText("Individual Home Disable");
    button14.setVisible(true);
    button15.setVisible(true);
    button16.setVisible(true);
  }
  individualHomesEnabled=!individualHomesEnabled;
} //_CODE_:button38:722903:

public void button39_click1(GButton source, GEvent event) { //_CODE_:button39:521786:
  System.exit(1);
} //_CODE_:button39:521786:

public void textfield7_change1(GTextField source, GEvent event) { //_CODE_:textfield7:368417:
  logNCon("textfield7 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield7:368417:

public void textfield8_change1(GTextField source, GEvent event) { //_CODE_:textfield8:301063:
  logNCon("textfield8 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield8:301063:

public void textfield9_change1(GTextField source, GEvent event) { //_CODE_:textfield9:718169:
  logNCon("textfield9 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield9:718169:

public void button40_click1(GButton source, GEvent event) { //_CODE_:button40:921130:
  logNCon("button40 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:button40:921130:

public void button41_click1(GButton source, GEvent event) { //_CODE_:button41:878589:
  logNCon("button41 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:button41:878589:

public void button42_click1(GButton source, GEvent event) { //_CODE_:button42:497621:
  logNCon("button42 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:button42:497621:

public void button43_click1(GButton source, GEvent event) { //_CODE_:button43:434828:
  logNCon("button43 - GButton >> GEvent." + event + " @ " + millis());
  String msg=textfield1.getText()+"\n";
  port.write(msg);
  logNConPort(msg);
} //_CODE_:button43:434828:

public void button44_click1(GButton source, GEvent event) { //_CODE_:button44:520328:
  //logNCon("button44 - GButton >> GEvent." + event + " @ " + millis());
  String msg="G10 P0 L20 X0 Y0 Z0 \n";
  port.write(msg);
  logNConPort(msg);
} //_CODE_:button44:520328:



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
  button22 = new GButton(this, 10, 800, 290, 30);
  button22.setText("Still Initializing");
  button22.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button22.addEventHandler(this, "button22_click1");
  button1 = new GButton(this, 10, 129, 40, 40);
  button1.setText("X-");
  button1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  button2 = new GButton(this, 110, 130, 40, 40);
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
  button8 = new GButton(this, 60, 80, 40, 40);
  button8.setText("Y+");
  button8.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button8.addEventHandler(this, "button8_click1");
  button9 = new GButton(this, 60, 184, 40, 40);
  button9.setText("Y-");
  button9.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button9.addEventHandler(this, "button9_click1");
  button10 = new GButton(this, 190, 110, 40, 40);
  button10.setText("Z+");
  button10.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button10.addEventHandler(this, "button10_click1");
  button11 = new GButton(this, 190, 160, 40, 40);
  button11.setText("Z-");
  button11.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button11.addEventHandler(this, "button11_click1");
  button12 = new GButton(this, 520, 120, 140, 30);
  button12.setText("Jog Cancel");
  button12.addEventHandler(this, "button12_click1");
  button13 = new GButton(this, 440, 160, 60, 30);
  button13.setText("$C");
  button13.addEventHandler(this, "button13_click1");
  button14 = new GButton(this, 151, 543, 130, 30);
  button14.setText("Home X");
  button14.setLocalColorScheme(GCScheme.SCHEME_9);
  button14.addEventHandler(this, "button14_click1");
  button15 = new GButton(this, 328, 540, 130, 30);
  button15.setText("Home Y");
  button15.setLocalColorScheme(GCScheme.SCHEME_9);
  button15.addEventHandler(this, "button15_click1");
  button16 = new GButton(this, 513, 541, 130, 30);
  button16.setText("Home Z");
  button16.setLocalColorScheme(GCScheme.SCHEME_9);
  button16.addEventHandler(this, "button16_click1");
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
  button24 = new GButton(this, 129, 642, 160, 30);
  button24.setText("Set X");
  button24.addEventHandler(this, "button24_click1");
  button25 = new GButton(this, 368, 160, 60, 30);
  button25.setText("$$");
  button25.addEventHandler(this, "button25_click1");
  button26 = new GButton(this, 370, 200, 60, 30);
  button26.setText("$I");
  button26.addEventHandler(this, "button26_click1");
  button27 = new GButton(this, 127, 679, 162, 30);
  button27.setText("GoTo X");
  button27.addEventHandler(this, "button27_click1");
  button28 = new GButton(this, 750, 641, 141, 30);
  button28.setText("Select File");
  button28.addEventHandler(this, "button28_click1");
  button29 = new GButton(this, 750, 678, 141, 30);
  button29.setText("Run File");
  button29.addEventHandler(this, "button29_click1");
  button30 = new GButton(this, 318, 642, 150, 30);
  button30.setText("Set Y");
  button30.addEventHandler(this, "button30_click1");
  button31 = new GButton(this, 317, 679, 150, 30);
  button31.setText("GoTo Y");
  button31.addEventHandler(this, "button31_click1");
  button32 = new GButton(this, 496, 642, 150, 30);
  button32.setText("Set Z");
  button32.addEventHandler(this, "button32_click1");
  button33 = new GButton(this, 497, 679, 150, 30);
  button33.setText("GoTo Z");
  button33.addEventHandler(this, "button33_click1");
  label1 = new GLabel(this, 10, 240, 80, 20);
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
  label14 = new GLabel(this, 241, 1, 133, 30);
  label14.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label14.setText("last message");
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
  label20 = new GLabel(this, 680, 300, 210, 30);
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
  label24 = new GLabel(this, 328, 571, 130, 20);
  label24.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label24.setText("Y Limit: Off");
  label24.setLocalColorScheme(GCScheme.SCHEME_9);
  label24.setOpaque(false);
  label25 = new GLabel(this, 513, 571, 130, 19);
  label25.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label25.setText("Z Limit: Off");
  label25.setLocalColorScheme(GCScheme.SCHEME_9);
  label25.setOpaque(false);
  label26 = new GLabel(this, 680, 330, 210, 30);
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
  textfield3 = new GTextField(this, 822, 434, 68, 30, G4P.SCROLLBARS_NONE);
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  textfield4 = new GTextField(this, 228, 606, 60, 30, G4P.SCROLLBARS_NONE);
  textfield4.setOpaque(true);
  textfield4.addEventHandler(this, "textfield4_change1");
  textfield5 = new GTextField(this, 409, 606, 60, 30, G4P.SCROLLBARS_NONE);
  textfield5.setOpaque(true);
  textfield5.addEventHandler(this, "textfield5_change1");
  textfield6 = new GTextField(this, 586, 606, 60, 30, G4P.SCROLLBARS_NONE);
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
  button34 = new GButton(this, 129, 606, 101, 30);
  button34.setText("Set Accel");
  button34.setLocalColorScheme(GCScheme.SCHEME_9);
  button34.addEventHandler(this, "button34_click1");
  button35 = new GButton(this, 317, 606, 96, 30);
  button35.setText("Set Accel");
  button35.setLocalColorScheme(GCScheme.SCHEME_9);
  button35.addEventHandler(this, "button35_click1");
  button36 = new GButton(this, 496, 606, 93, 30);
  button36.setText("Set Accel");
  button36.setLocalColorScheme(GCScheme.SCHEME_9);
  button36.addEventHandler(this, "button36_click1");
  button37 = new GButton(this, 732, 434, 89, 30);
  button37.setText("Set Feed");
  button37.setLocalColorScheme(GCScheme.SCHEME_9);
  button37.addEventHandler(this, "button37_click1");
  button38 = new GButton(this, 4, 539, 145, 55);
  button38.setText("Individual axis homing");
  button38.setLocalColorScheme(GCScheme.SCHEME_9);
  button38.addEventHandler(this, "button38_click1");
  button39 = new GButton(this, 752, 798, 141, 44);
  button39.setText("Exit");
  button39.setLocalColorScheme(GCScheme.SCHEME_9);
  button39.addEventHandler(this, "button39_click1");
  label17 = new GLabel(this, 520, 162, 140, 30);
  label17.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label17.setText("No Motion");
  label17.setLocalColorScheme(GCScheme.RED_SCHEME);
  label17.setOpaque(true);
  textfield7 = new GTextField(this, 126, 420, 154, 30, G4P.SCROLLBARS_NONE);
  textfield7.setOpaque(true);
  textfield7.addEventHandler(this, "textfield7_change1");
  textfield8 = new GTextField(this, 305, 420, 154, 30, G4P.SCROLLBARS_NONE);
  textfield8.setOpaque(true);
  textfield8.addEventHandler(this, "textfield8_change1");
  textfield9 = new GTextField(this, 490, 420, 154, 30, G4P.SCROLLBARS_NONE);
  textfield9.setOpaque(true);
  textfield9.addEventHandler(this, "textfield9_change1");
  button40 = new GButton(this, 126, 455, 154, 30);
  button40.setText("Set X Jog");
  button40.setLocalColorScheme(GCScheme.SCHEME_9);
  button40.addEventHandler(this, "button40_click1");
  button41 = new GButton(this, 302, 455, 154, 30);
  button41.setText("Set Y Jog");
  button41.setLocalColorScheme(GCScheme.SCHEME_9);
  button41.addEventHandler(this, "button41_click1");
  button42 = new GButton(this, 490, 455, 154, 30);
  button42.setText("Set Z Jog");
  button42.setLocalColorScheme(GCScheme.SCHEME_9);
  button42.addEventHandler(this, "button42_click1");
  button43 = new GButton(this, 334, 798, 219, 30);
  button43.setText("Execute Command");
  button43.addEventHandler(this, "button43_click1");
  button44 = new GButton(this, 1, 314, 126, 30);
  button44.setText("Reset XYZ");
  button44.setLocalColorScheme(GCScheme.SCHEME_9);
  button44.addEventHandler(this, "button44_click1");
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
GButton button14; 
GButton button15; 
GButton button16; 
GButton button17; 
GButton button18; 
GButton button19; 
GButton button20; 
GButton button21; 
GButton button23; 
GButton button24; 
GButton button25; 
GButton button26; 
GButton button27; 
GButton button28; 
GButton button29; 
GButton button30; 
GButton button31; 
GButton button32; 
GButton button33; 
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
GButton button38; 
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
