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

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:653085:
  /* X- jog */
  //println("button1 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%.0f\n",-1.0*+stepSizes[0],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button1:653085:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:541532:
  /* X+ jog */
  //println("button2 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 X%.3f F%.0f\n",stepSizes[0],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button2:541532:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:849549:
  /* reset X */
  //println("button3 - GButton >> GEvent." + event + " @ " + millis());  
  portMsg="G10 P0 L20 X0\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button3:849549:

public void button4_click1(GButton source, GEvent event) { //_CODE_:button4:326908:
  /* reset Y */
  //println("button4 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Y0\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button4:326908:

public void button5_click1(GButton source, GEvent event) { //_CODE_:button5:269750:
  /* reset Z */
  //println("button5 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Z0\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button5:269750:

public void custom_slider1_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider1:731371:
  //println("custom_slider1 - GCustomSlider >> GEvent." + event + " @ " + millis());
  //println("integer value:" + custom_slider1.getValueI() + " float value:" + custom_slider1.getValueF());
  println("xStepSlider "+custom_slider1.getValueF()+" math.pow(10.,val)="+Math.pow(10.,custom_slider1.getValueF()));
  stepSizes[0]=(float)Math.pow(10.,custom_slider1.getValueF());
  label5.setText(String.format("(%7.1f  ,",stepSizes[0]));
  label5.setTextBold();
} //_CODE_:custom_slider1:731371:

public void custom_slider2_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider2:754596:
  //println("custom_slider2 - GCustomSlider >> GEvent." + event + " @ " + millis());
  stepSizes[1]=(float)Math.pow(10.,custom_slider2.getValueF());
  label5.setText(String.format("(%7.1f  ,%7.1f  ,%7.1f  )",stepSizes[0],stepSizes[1],stepSizes[2]));
  label5.setTextBold();
} //_CODE_:custom_slider2:754596:

public void custom_slider3_change1(GCustomSlider source, GEvent event) { //_CODE_:custom_slider3:427145:
  //println("custom_slider3 - GCustomSlider >> GEvent." + event + " @ " + millis());
  stepSizes[2]=(float)Math.pow(10.,custom_slider3.getValueF());
  label5.setText(String.format("(%7.1f  ,%7.1f  ,%7.1f  )",stepSizes[0],stepSizes[1],stepSizes[2]));
  label5.setTextBold();
} //_CODE_:custom_slider3:427145:

public void button6_click1(GButton source, GEvent event) { //_CODE_:button6:927949:
  //println("button6 - GButton >> GEvent." + event + " @ " + millis());
  /* kill alarm lock */
  port.write("$X\n");
} //_CODE_:button6:927949:

public void button7_click1(GButton source, GEvent event) { //_CODE_:button7:608905:
  /* RESET */
  //println("button7 - GButton >> GEvent." + event + " @ " + millis());
  //port.write(String.valueOf((char) 24));
  portCode=0x18; /* ctrl-x */
  port.write(portCode);
  println("port.wrote("+portCode+")");
} //_CODE_:button7:608905:

public void button8_click1(GButton source, GEvent event) { //_CODE_:button8:664568:
  /* Y+ jog */
  //println("button8 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Y%.3f F%.0f\n",stepSizes[1],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button8:664568:

public void button9_click1(GButton source, GEvent event) { //_CODE_:button9:236642:
  /* Y- jog */
  //println("button9 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Y%.3f F%.0f\n",-1.0*+stepSizes[1],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button9:236642:

public void button10_click1(GButton source, GEvent event) { //_CODE_:button10:378925:
  /* Z+ jog */
  //println("button10 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%.0f\n",-1.0*+stepSizes[2],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button10:378925:

public void button11_click1(GButton source, GEvent event) { //_CODE_:button11:673670:
  /* Z- jog */
  //println("button11 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$J=G91 Z%.3f F%.0f\n",-1.0*+stepSizes[2],maxFeedRate);
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button11:673670:

public void button12_click1(GButton source, GEvent event) { //_CODE_:button12:601621:
  /* Jog Cancel */
  //println("button12 - GButton >> GEvent." + event + " @ " + millis());
  portCode=0x85;
  port.write(portCode);
  println("port.wrote("+portCode+")");
} //_CODE_:button12:601621:

public void button13_click1(GButton source, GEvent event) { //_CODE_:button13:786516:
  //println("button13 - GButton >> GEvent." + event + " @ " + millis());
  checkGCodeMode=!checkGCodeMode;
  portMsg=String.format("$C\n");
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
  button29.setText((checkGCodeMode?"Check":"Run")+" File");
  button29.setTextBold();
} //_CODE_:button13:786516:

public void button14_click1(GButton source, GEvent event) { //_CODE_:button14:417929:
  /* Home X */
  //println("button14 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HX\n");
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button14:417929:

public void button15_click1(GButton source, GEvent event) { //_CODE_:button15:360194:
  /* Home Y */
  //println("button15 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HY\n");
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button15:360194:

public void button16_click1(GButton source, GEvent event) { //_CODE_:button16:405407:
  /* Home Z */
  //println("button16 - GButton >> GEvent." + event + " @ " + millis());
  portMsg=String.format("$HZ\n");
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button16:405407:

public void button17_click1(GButton source, GEvent event) { //_CODE_:button17:224353:
 /* sticky */
  println("button17 - GButton >> GEvent." + event + " @ " + millis());
  button17.setText(custom_slider1.isStickToTicks()?"Varies":"Sticky");
  custom_slider1.setStickToTicks(!custom_slider1.isStickToTicks());
  custom_slider2.setStickToTicks(!custom_slider2.isStickToTicks());
  custom_slider3.setStickToTicks(!custom_slider3.isStickToTicks());
} //_CODE_:button17:224353:

public void button18_click1(GButton source, GEvent event) { //_CODE_:button18:951794:
  /* $G  GCode parser state */
  //println("button18 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$G\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");

} //_CODE_:button18:951794:

public void button19_click1(GButton source, GEvent event) { //_CODE_:button19:736051:
  /* hold    feed hold  */
  //println("button19 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="!";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button19:736051:

public void button20_click1(GButton source, GEvent event) { //_CODE_:button20:371256:
  /* cycle start */
  //println("button20 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="~";
  port.write(portMsg);
  println("port.wrote("+portMsg+")");
} //_CODE_:button20:371256:

public void button21_click1(GButton source, GEvent event) { //_CODE_:button21:369637:
  println("button21 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:button21:369637:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:textfield1:837995:
  //println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
  String extra = " event fired at " + millis() / 1000.0 + "s";
  switch(event) {
    case CHANGED:
      //println("CHANGED " + extra);
      break;
    case SELECTION_CHANGED:
      //println("SELECTION_CHANGED " + extra);
      break;
    case LOST_FOCUS:
      //println("LOST_FOCUS " + extra);
      break;
    case GETS_FOCUS:
      //println("GETS_FOCUS " + extra);
      break;
    case ENTERED:
      //println("ENTERED " + extra);
      String sin=textfield1.getText();
      //println("textfield1 text=|"+sin+"|");
      portMsg=sin+"\n";
      port.write(portMsg);
      //println("port.wrote("+portMsg+")");
      textfield1.setText("");
      break;
    default:
      println("UNKNOWN " + extra);
  }
} //_CODE_:textfield1:837995:

public void button22_click1(GButton source, GEvent event) { //_CODE_:button22:670967:
  /* toggle button for verbose output */
  //println("button22 - GButton >> GEvent." + event + " @ " + millis());
  verboseOutput=!verboseOutput;
  button22.setText((verboseOutput ?"halt ":"resume ")+"verbose output");
  
} //_CODE_:button22:670967:

public void button23_click1(GButton source, GEvent event) { //_CODE_:button23:614895:
  /* $# to console    get the eprom stored G54-G59 et al */
  //println("button23 - GButton >> GEvent." + event + " @ " + millis());
  hashtagParams2Console();
} //_CODE_:button23:614895:

public void button24_click1(GButton source, GEvent event) { //_CODE_:button24:303378:
  /* SetX 871 */
  //println("button24 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 X"+homes2WorkAllPositive[0]+"\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button24:303378:

public void button25_click1(GButton source, GEvent event) { //_CODE_:button25:392326:
  /* $$ get settings  */
  //println("button25 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$$\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button25:392326:

public void button26_click1(GButton source, GEvent event) { //_CODE_:button26:411504:
  /* $I version and options modified in config.h */
  //println("button26 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="$I\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button26:411504:

public void button27_click1(GButton source, GEvent event) { //_CODE_:button27:403511:
  /* GoTo 861.5 */
  //println("button27 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 X"+homes2WorkAllPositive[0]+" F500\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")"); 
} //_CODE_:button27:403511:

public void button28_click1(GButton source, GEvent event) { //_CODE_:button28:596942:
  /* Select File */
  //println("button28 - GButton >> GEvent." + event + " @ " + millis());
  selectInput("Select a file to process:", "fileSelected");
} //_CODE_:button28:596942:

public void button29_click1(GButton source, GEvent event) { //_CODE_:button29:590713:
  /* Run File  or  Check File */
  //println("button29 - GButton >> GEvent." + event + " @ " + millis());
  if(streaming) label22.setText("Allready streaming.  Multiple requests not allowed.");
  else{
    streaming=true;
    numOKs=0;
    numErrors=0;
    numRowsConfirmedProcessed=0;
    String fid=textfield2.getText();
    println("about to start streaming with checkGCodeMode="+(checkGCodeMode?"true ":"false")+" on fid="+fid);
    try {
      br = Files.newBufferedReader(Paths.get(fid)); 
    } catch (IOException e) {
       System.err.format("IOException: %s%n", e);
    }
  }  
  bufferedReaderSet=true;
  //timeNSay("got to end of button29_click1");
} //_CODE_:button29:590713:

public void textfield2_change1(GTextField source, GEvent event) { //_CODE_:textfield2:315386:
  /* file.   This will be a passive receptor of the text, no action taken upon enter */
  //println("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield2:315386:

public void textfield3_change1(GTextField source, GEvent event) { //_CODE_:textfield3:313703:
  /* set feed */
  //println("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
  String extra = " event fired at " + millis() / 1000.0 + "s";
  switch(event) {
    case CHANGED:
      //println("CHANGED " + extra);
      break;
    case SELECTION_CHANGED:
      //println("SELECTION_CHANGED " + extra);
      break;
    case LOST_FOCUS:
      //println("LOST_FOCUS " + extra);
      break;
    case GETS_FOCUS:
      //println("GETS_FOCUS " + extra);
      break;
    case ENTERED:
      //println("ENTERED " + extra);
      try {
        maxFeedRate=Integer.parseInt(textfield3.getText().trim());
        println("amaxFeedRate="+maxFeedRate +" from textfield3.getText()="+textfield3.getText());
      } catch (NumberFormatException nfe) {
        println("AAAAHHHhhhhhhh only number in this field.   NumberFormatException: " + nfe.getMessage());
        println("maxFeedRate is "+maxFeedRate);   
        textfield3.setText("");
      }
      break;
    default:
      println("UNKNOWN " + extra);
  }
} //_CODE_:textfield3:313703:

public void textfield4_change1(GTextField source, GEvent event) { //_CODE_:textfield4:223714:
  /* X acceleration */
  //intln("textfield4 - GTextField >> GEvent." + event + " @ " + millis());
  switch(event) {
    case CHANGED:
      //println("CHANGED " + extra);
      break;
    case SELECTION_CHANGED:
      //println("SELECTION_CHANGED ");
      break;
    case LOST_FOCUS:
      //println("LOST_FOCUS ");
      break;
    case GETS_FOCUS:
      //println("GETS_FOCUS ");
      break;
    case ENTERED:
      //println("ENTERED ");
       try {
        portMsg="$120="+Integer.parseInt(textfield4.getText())+"\n";
        port.write(portMsg);
        println("port.wrote("+portMsg+")");
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }  
      break;
    default:
      println("UNKNOWN ");
  }
} //_CODE_:textfield4:223714:

public void textfield5_change1(GTextField source, GEvent event) { //_CODE_:textfield5:311645:
 /* Y acceleration */
 //println("textfield5 - GTextField >> GEvent." + event + " @ " + millis());
 switch(event) {
    case CHANGED:
      //println("CHANGED " + extra);
      break;
    case SELECTION_CHANGED:
      //println("SELECTION_CHANGED ");
      break;
    case LOST_FOCUS:
      //println("LOST_FOCUS ");
      break;
    case GETS_FOCUS:
      //println("GETS_FOCUS ");
      break;
    case ENTERED:
      //println("ENTERED ");
       try {
        portMsg="$121="+Integer.parseInt(textfield5.getText())+"\n";
        port.write(portMsg);
        //println("port.wrote("+portMsg+")");
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }  
      break;
    default:
      println("UNKNOWN ");
  }
} //_CODE_:textfield5:311645:

public void textfield6_change1(GTextField source, GEvent event) { //_CODE_:textfield6:941190:
 /* Z acceleration */
 //println("textfield6 - GTextField >> GEvent." + event + " @ " + millis());
  switch(event) {
    case CHANGED:
      //println("CHANGED " + extra);
      break;
    case SELECTION_CHANGED:
      //println("SELECTION_CHANGED ");
      break;
    case LOST_FOCUS:
      //println("LOST_FOCUS ");
      break;
    case GETS_FOCUS:
      //println("GETS_FOCUS ");
      break;
    case ENTERED:
      //println("ENTERED ");
       try {
        portMsg="$122="+Integer.parseInt(textfield6.getText())+"\n";
        port.write(portMsg);
        //println("port.wrote("+portMsg+")");
      } catch (NumberFormatException nfe) {
        System.err.println("NumberFormatException: " + nfe.getMessage());
      }  
      break;
    default:
      println("UNKNOWN ");
  } 
} //_CODE_:textfield6:941190:

public void button30_click1(GButton source, GEvent event) { //_CODE_:button30:207565:
  /* SetX 871 */
  //println("button30 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Y"+homes2WorkAllPositive[1]+"\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button30:207565:

public void button31_click1(GButton source, GEvent event) { //_CODE_:button31:540275:
  /* GoTo 861.5 */
  //println("button31 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 Y"+homes2WorkAllPositive[1]+" F500\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")"); 
} //_CODE_:button31:540275:

public void button32_click1(GButton source, GEvent event) { //_CODE_:button32:681510:
  /* SetX 871 */
  //println("button32 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G10 P0 L20 Z"+homes2WorkAllPositive[2]+"\n";
  port.write(portMsg);
  //println("port.wrote("+portMsg+")");
} //_CODE_:button32:681510:

public void button33_click1(GButton source, GEvent event) { //_CODE_:button33:543489:
  /* GoTo 861.5 */
  //println("button33 - GButton >> GEvent." + event + " @ " + millis());
  portMsg="G1 Z"+homes2WorkAllPositive[2]+" F500\n";
  port.write(portMsg);
  println("port.wrote("+portMsg+")"); 
} //_CODE_:button33:543489:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  GButton.useRoundCorners(false);
  surface.setTitle("GRBL Gui");
  button1 = new GButton(this, 10, 130, 40, 40);
  button1.setText("X-");
  button1.setTextBold();
  button1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  button2 = new GButton(this, 110, 130, 40, 40);
  button2.setText("X+");
  button2.setTextBold();
  button2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button2.addEventHandler(this, "button2_click1");
  label1 = new GLabel(this, 10, 240, 80, 30);
  label1.setText("W XYZ:");
  label1.setOpaque(false);
  button3 = new GButton(this, 140, 310, 100, 30);
  button3.setText("Reset X");
  button3.setLocalColorScheme(GCScheme.SCHEME_9);
  button3.addEventHandler(this, "button3_click1");
  label2 = new GLabel(this, 80, 240, 210, 30);
  label2.setText("(-1234.123,");
  label2.setLocalColorScheme(GCScheme.SCHEME_9);
  label2.setOpaque(false);
  label3 = new GLabel(this, 0, 0, 260, 30);
  label3.setText("Active State:");
  label3.setTextBold();
  label3.setLocalColorScheme(GCScheme.SCHEME_9);
  label3.setOpaque(false);
  button4 = new GButton(this, 320, 310, 100, 30);
  button4.setText("Reset Y");
  button4.setLocalColorScheme(GCScheme.SCHEME_9);
  button4.addEventHandler(this, "button4_click1");
  button5 = new GButton(this, 510, 310, 100, 30);
  button5.setText("Reset Z");
  button5.setLocalColorScheme(GCScheme.SCHEME_9);
  button5.addEventHandler(this, "button5_click1");
  label4 = new GLabel(this, 10, 350, 70, 30);
  label4.setText("Jog:");
  label4.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  label4.setOpaque(false);
  label5 = new GLabel(this, 130, 350, 180, 30);
  label5.setText("(    1.0    ,");
  label5.setTextBold();
  label5.setLocalColorScheme(GCScheme.SCHEME_9);
  label5.setOpaque(false);
  custom_slider1 = new GCustomSlider(this, 130, 390, 100, 30, "green_red20px");
  custom_slider1.setLimits(0.0, -1.0, 3.0);
  custom_slider1.setNbrTicks(5);
  custom_slider1.setStickToTicks(true);
  custom_slider1.setShowTicks(true);
  custom_slider1.setNumberFormat(G4P.DECIMAL, 2);
  custom_slider1.setOpaque(false);
  custom_slider1.addEventHandler(this, "custom_slider1_change1");
  custom_slider2 = new GCustomSlider(this, 320, 390, 100, 30, "green_red20px");
  custom_slider2.setLimits(0.0, -1.0, 3.0);
  custom_slider2.setNbrTicks(5);
  custom_slider2.setStickToTicks(true);
  custom_slider2.setShowTicks(true);
  custom_slider2.setNumberFormat(G4P.DECIMAL, 2);
  custom_slider2.setOpaque(false);
  custom_slider2.addEventHandler(this, "custom_slider2_change1");
  custom_slider3 = new GCustomSlider(this, 510, 390, 100, 30, "green_red20px");
  custom_slider3.setLimits(0.0, -1.0, 3.0);
  custom_slider3.setNbrTicks(5);
  custom_slider3.setStickToTicks(true);
  custom_slider3.setShowTicks(true);
  custom_slider3.setNumberFormat(G4P.DECIMAL, 2);
  custom_slider3.setOpaque(false);
  custom_slider3.addEventHandler(this, "custom_slider3_change1");
  button6 = new GButton(this, 300, 80, 200, 30);
  button6.setText("Kill Alarm Lock");
  button6.setTextBold();
  button6.addEventHandler(this, "button6_click1");
  button7 = new GButton(this, 300, 120, 200, 30);
  button7.setText("Reset Grbl");
  button7.setTextBold();
  button7.addEventHandler(this, "button7_click1");
  button8 = new GButton(this, 60, 80, 40, 40);
  button8.setText("Y+");
  button8.setTextBold();
  button8.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button8.addEventHandler(this, "button8_click1");
  button9 = new GButton(this, 60, 180, 40, 40);
  button9.setText("Y-");
  button9.setTextBold();
  button9.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button9.addEventHandler(this, "button9_click1");
  button10 = new GButton(this, 190, 110, 40, 40);
  button10.setText("Z+");
  button10.setTextBold();
  button10.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button10.addEventHandler(this, "button10_click1");
  button11 = new GButton(this, 190, 160, 40, 40);
  button11.setText("Z-");
  button11.setTextBold();
  button11.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button11.addEventHandler(this, "button11_click1");
  label6 = new GLabel(this, 10, 280, 100, 20);
  label6.setText("M XYZ:");
  label6.setOpaque(false);
  label7 = new GLabel(this, 120, 280, 180, 30);
  label7.setText("(-1234.123  ,");
  label7.setLocalColorScheme(GCScheme.SCHEME_9);
  label7.setOpaque(false);
  label8 = new GLabel(this, 312, 280, 190, 30);
  label8.setText("-1234.123  ,");
  label8.setLocalColorScheme(GCScheme.SCHEME_9);
  label8.setOpaque(false);
  label9 = new GLabel(this, 490, 280, 160, 30);
  label9.setText("-1234.123)");
  label9.setLocalColorScheme(GCScheme.SCHEME_9);
  label9.setOpaque(false);
  label10 = new GLabel(this, 280, 240, 190, 30);
  label10.setText("-1234.123,");
  label10.setLocalColorScheme(GCScheme.SCHEME_9);
  label10.setOpaque(false);
  label11 = new GLabel(this, 450, 240, 200, 30);
  label11.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label11.setText("-1234.123)");
  label11.setLocalColorScheme(GCScheme.SCHEME_9);
  label11.setOpaque(false);
  label12 = new GLabel(this, 320, 350, 190, 30);
  label12.setText("    1.0    ,");
  label12.setTextBold();
  label12.setLocalColorScheme(GCScheme.SCHEME_9);
  label12.setOpaque(false);
  label13 = new GLabel(this, 510, 350, 140, 30);
  label13.setText("    1.0  )");
  label13.setTextBold();
  label13.setLocalColorScheme(GCScheme.SCHEME_9);
  label13.setOpaque(false);
  button12 = new GButton(this, 520, 120, 140, 30);
  button12.setText("Jog Cancel");
  button12.setTextBold();
  button12.addEventHandler(this, "button12_click1");
  button13 = new GButton(this, 440, 160, 60, 30);
  button13.setText("$C");
  button13.setTextBold();
  button13.addEventHandler(this, "button13_click1");
  button14 = new GButton(this, 110, 430, 130, 30);
  button14.setText("Home X");
  button14.setTextBold();
  button14.addEventHandler(this, "button14_click1");
  button15 = new GButton(this, 310, 430, 130, 30);
  button15.setText("Home Y");
  button15.setTextBold();
  button15.addEventHandler(this, "button15_click1");
  button16 = new GButton(this, 500, 430, 130, 30);
  button16.setText("Home Z");
  button16.setTextBold();
  button16.addEventHandler(this, "button16_click1");
  label14 = new GLabel(this, 280, 0, 80, 30);
  label14.setText("last message");
  label14.setLocalColorScheme(GCScheme.SCHEME_9);
  label14.setOpaque(false);
  label15 = new GLabel(this, 360, 0, 530, 30);
  label15.setText("grbl has not yet output any msg");
  label15.setTextItalic();
  label15.setLocalColorScheme(GCScheme.SCHEME_9);
  label15.setOpaque(false);
  label16 = new GLabel(this, 690, 240, 70, 30);
  label16.setText("Feed:");
  label16.setOpaque(false);
  label17 = new GLabel(this, 780, 240, 90, 30);
  label17.setText("500");
  label17.setTextBold();
  label17.setLocalColorScheme(GCScheme.SCHEME_9);
  label17.setOpaque(false);
  label18 = new GLabel(this, 690, 280, 110, 30);
  label18.setText("Spindle:");
  label18.setOpaque(false);
  label19 = new GLabel(this, 790, 280, 90, 30);
  label19.setText("  0");
  label19.setTextBold();
  label19.setLocalColorScheme(GCScheme.SCHEME_9);
  label19.setOpaque(false);
  label20 = new GLabel(this, 690, 320, 80, 30);
  label20.setText("Laser:");
  label20.setOpaque(false);
  label21 = new GLabel(this, 790, 320, 80, 30);
  label21.setText("OFF");
  label21.setTextBold();
  label21.setLocalColorScheme(GCScheme.SCHEME_9);
  label21.setOpaque(false);
  button17 = new GButton(this, 10, 390, 97, 30);
  button17.setText("Sticky");
  button17.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button17.addEventHandler(this, "button17_click1");
  label22 = new GLabel(this, 0, 30, 900, 50);
  label22.setText(" ");
  label22.setTextBold();
  label22.setLocalColorScheme(GCScheme.RED_SCHEME);
  label22.setOpaque(false);
  button18 = new GButton(this, 300, 160, 60, 30);
  button18.setText("$G");
  button18.setTextBold();
  button18.addEventHandler(this, "button18_click1");
  label23 = new GLabel(this, 136, 470, 80, 20);
  label23.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label23.setText("X Limit Off");
  label23.setLocalColorScheme(GCScheme.SCHEME_9);
  label23.setOpaque(false);
  label24 = new GLabel(this, 330, 470, 80, 20);
  label24.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label24.setText("Y Limit Off");
  label24.setLocalColorScheme(GCScheme.SCHEME_9);
  label24.setOpaque(false);
  label25 = new GLabel(this, 520, 470, 80, 20);
  label25.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label25.setText("Z Limit Off");
  label25.setLocalColorScheme(GCScheme.SCHEME_9);
  label25.setOpaque(false);
  label26 = new GLabel(this, 690, 360, 80, 20);
  label26.setText("Probe Off");
  label26.setLocalColorScheme(GCScheme.SCHEME_9);
  label26.setOpaque(false);
  label27 = new GLabel(this, 790, 360, 80, 20);
  label27.setText("Door Closed");
  label27.setLocalColorScheme(GCScheme.SCHEME_9);
  label27.setOpaque(false);
  button19 = new GButton(this, 680, 60, 210, 160);
  button19.setText("HOLD");
  button19.setTextBold();
  button19.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  button19.addEventHandler(this, "button19_click1");
  button20 = new GButton(this, 440, 200, 60, 30);
  button20.setText("~");
  button20.setTextBold();
  button20.addEventHandler(this, "button20_click1");
  button21 = new GButton(this, 520, 80, 140, 30);
  button21.setText("Home");
  button21.setTextBold();
  button21.addEventHandler(this, "button21_click1");
  textfield1 = new GTextField(this, 80, 660, 810, 30, G4P.SCROLLBARS_NONE);
  textfield1.setOpaque(true);
  textfield1.addEventHandler(this, "textfield1_change1");
  label28 = new GLabel(this, 10, 660, 80, 20);
  label28.setText("Command:");
  label28.setOpaque(false);
  button22 = new GButton(this, 10, 700, 290, 30);
  button22.setText("still initializing");
  button22.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button22.addEventHandler(this, "button22_click1");
  button23 = new GButton(this, 300, 200, 60, 30);
  button23.setText("$#");
  button23.setTextBold();
  button23.addEventHandler(this, "button23_click1");
  button24 = new GButton(this, 100, 540, 150, 30);
  button24.setText("SetX");
  button24.setTextBold();
  button24.addEventHandler(this, "button24_click1");
  button25 = new GButton(this, 370, 160, 60, 30);
  button25.setText("$$");
  button25.setTextBold();
  button25.addEventHandler(this, "button25_click1");
  button26 = new GButton(this, 370, 200, 60, 30);
  button26.setText("$I");
  button26.setTextBold();
  button26.addEventHandler(this, "button26_click1");
  button27 = new GButton(this, 100, 580, 150, 30);
  button27.setText("GoTo");
  button27.setTextBold();
  button27.addEventHandler(this, "button27_click1");
  button28 = new GButton(this, 750, 500, 141, 30);
  button28.setText("Select File");
  button28.setTextBold();
  button28.addEventHandler(this, "button28_click1");
  label30 = new GLabel(this, 10, 620, 80, 20);
  label30.setText("File:");
  label30.setOpaque(false);
  button29 = new GButton(this, 750, 540, 141, 30);
  button29.setText("Run File");
  button29.setTextBold();
  button29.addEventHandler(this, "button29_click1");
  textfield2 = new GTextField(this, 80, 620, 810, 30, G4P.SCROLLBARS_NONE);
  textfield2.setOpaque(true);
  textfield2.addEventHandler(this, "textfield2_change1");
  label29 = new GLabel(this, 690, 440, 120, 30);
  label29.setText("Set Feed:");
  label29.setOpaque(false);
  textfield3 = new GTextField(this, 810, 440, 70, 30, G4P.SCROLLBARS_NONE);
  textfield3.setText(" ");
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  label31 = new GLabel(this, 110, 500, 80, 30);
  label31.setText("Accel:");
  label31.setOpaque(false);
  textfield4 = new GTextField(this, 190, 500, 40, 30, G4P.SCROLLBARS_NONE);
  textfield4.setOpaque(true);
  textfield4.addEventHandler(this, "textfield4_change1");
  label32 = new GLabel(this, 310, 500, 80, 30);
  label32.setText("Accel:");
  label32.setOpaque(false);
  textfield5 = new GTextField(this, 390, 500, 40, 30, G4P.SCROLLBARS_NONE);
  textfield5.setOpaque(true);
  textfield5.addEventHandler(this, "textfield5_change1");
  label33 = new GLabel(this, 500, 500, 80, 30);
  label33.setText("Accel:");
  label33.setOpaque(false);
  textfield6 = new GTextField(this, 580, 500, 40, 30, G4P.SCROLLBARS_NONE);
  textfield6.setOpaque(true);
  textfield6.addEventHandler(this, "textfield6_change1");
  button30 = new GButton(this, 300, 540, 150, 30);
  button30.setText("SetY");
  button30.addEventHandler(this, "button30_click1");
  button31 = new GButton(this, 300, 580, 150, 30);
  button31.setText("GoTo");
  button31.addEventHandler(this, "button31_click1");
  button32 = new GButton(this, 490, 540, 150, 30);
  button32.setText("SetZ");
  button32.addEventHandler(this, "button32_click1");
  button33 = new GButton(this, 490, 580, 150, 30);
  button33.setText("GoTo");
  button33.addEventHandler(this, "button33_click1");
}

// Variable declarations 
// autogenerated do not edit
GButton button1; 
GButton button2; 
GLabel label1; 
GButton button3; 
GLabel label2; 
GLabel label3; 
GButton button4; 
GButton button5; 
GLabel label4; 
GLabel label5; 
GCustomSlider custom_slider1; 
GCustomSlider custom_slider2; 
GCustomSlider custom_slider3; 
GButton button6; 
GButton button7; 
GButton button8; 
GButton button9; 
GButton button10; 
GButton button11; 
GLabel label6; 
GLabel label7; 
GLabel label8; 
GLabel label9; 
GLabel label10; 
GLabel label11; 
GLabel label12; 
GLabel label13; 
GButton button12; 
GButton button13; 
GButton button14; 
GButton button15; 
GButton button16; 
GLabel label14; 
GLabel label15; 
GLabel label16; 
GLabel label17; 
GLabel label18; 
GLabel label19; 
GLabel label20; 
GLabel label21; 
GButton button17; 
GLabel label22; 
GButton button18; 
GLabel label23; 
GLabel label24; 
GLabel label25; 
GLabel label26; 
GLabel label27; 
GButton button19; 
GButton button20; 
GButton button21; 
GTextField textfield1; 
GLabel label28; 
GButton button22; 
GButton button23; 
GButton button24; 
GButton button25; 
GButton button26; 
GButton button27; 
GButton button28; 
GLabel label30; 
GButton button29; 
GTextField textfield2; 
GLabel label29; 
GTextField textfield3; 
GLabel label31; 
GTextField textfield4; 
GLabel label32; 
GTextField textfield5; 
GLabel label33; 
GTextField textfield6; 
GButton button30; 
GButton button31; 
GButton button32; 
GButton button33; 
