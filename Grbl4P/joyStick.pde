/************************************************************************************************************************************/
class JoyStick { 
  /* this being not -1 will be the boolean for is-a-joystick-present */
  int portIndex;
  
  float   joyY;       /* outside the dead-zone, is mapped to -1.0 for full back, 0.0 for center, 1.0 for full forward */ 
  float   joyX;       /* outside the dead-zone, is mapped to -1.0 for full left, 0.0 for center, 1.0 for full right */
  /* joystick Throttle is mapped Logarithmically because the use profile is to want control over speed to be finely
   * modifyable at low speeds, when moving to achieve tool-bit touch on a surface.   The intermediate speed range has
   * little utility. 
   */
  float   joyThrottle;/* has no dead-zone.         mapped to 0.01 for full back to 1.0 for full forward.  */
  float   joyRotate;  /* not currently used by Grbl4P */
  int     joyHat;  /* only positions up and down on the hat are used.   These are 0 for up and 4 for down */
  float   joyStickDeadZone;
  
  //boolean feedHold0;                /*  Trigger                            bit0    button 0 */
  ////boolean resetSlashAbort;        /*  Thumb Switch                       bit1    button 1    not connected, I hit it too much unintentionally */                                              
  //boolean auxPowerOff;              /*  Near Button Left of Hat            bit2    button 2 */
  //boolean auxPowerOn;               /*  Near Button Right of Hat           bit3    button 3 */
  //boolean feedHold1;                /*  Far Button Left of Hat             bit4    button 4 */
  //boolean cycleStartSlashResume;    /*  Far Button Right of Hat            bit5    button 5 */
  //boolean motorsDisable;            /*  Lower Far Button on Base           bit6    button 6 */
  //boolean motorsEnable;             /*  Upper Far Button on Base           bit7    button 7 */
  //boolean spindleOff;               /*  Lower Mid-Distance Button on Base  bit8    button 8 */
  //boolean spindleOne;               /*  Upper Mid-Distance Button on Base  bit9    button 9 */
  //boolean coolantSlashLaserDisable; /*  Lower Near Button on Base          bit10   button 10 */
  //boolean coolantSlashLaserEnable;  /*  Upper Near Button on Base          bit11   button 11 */
  /* joystick hat is recieved as part of the buttons integer.  
   * Hat has bits 12,13,14,15 encoded as after shifting right 12 bits ie    >>12
   *    8   hat centered
   *    0   hat Up
   *    1   hat UpRight
   *    2   hat Right
   *    3   hat DownRight
   *    4   hat Down
   *    5   hat DownLeft
   *    6   hat Left
   *    7   hat UpLeft
   */
  
  boolean amJoyStickJogging;
  int     numJoyStickJogsSent;
  int     numJoyStickJoggingOKs;
  boolean gotJoyPriors;
  boolean[] joyStickButtons;
  int priorJoyX;
  int priorJoyY;
  int priorJoyR; /* R for rotate (twist of the handle) */
  int priorJoyT; /* T for throttle, the slider at the rear of the joystick */
  int priorJoyS; /* S for switches (includes all 12 and the hat) */
  int priorJoyHat;
  boolean joyUpdateHasBeenHandled;
  int disableXButtonIndex;
  int disableYButtonIndex;
  int throttleXandYButtonIndex;
  int lockCurrentStateButtonIndex;
  float xResidue;
  int xResponseState;
  int yResponseState;
  boolean responseStatesAreSticky;
  int priorXResponseState;
  int priorYResponseState;
  boolean priorResponseStatesWereSticky;
  
  JoyStick(){
    portIndex=-1;
    joyHat=8;  /* only positions up and down on the hat are used.   These are 0 for up and 4 for down */
    joyStickDeadZone=0.15;
    amJoyStickJogging=false;
    numJoyStickJogsSent=0;
    numJoyStickJoggingOKs=0;
    gotJoyPriors=false;
    joyStickButtons = new boolean[12];
    disableXButtonIndex=-1;
    disableYButtonIndex=-1;
    throttleXandYButtonIndex=-1;
    lockCurrentStateButtonIndex=0;
    xResidue=0.0;
    xResponseState=0;
    yResponseState=0;
    responseStatesAreSticky=false;
    priorXResponseState=1;               /* set this as different from the current state so as to trigger an initial update of the gui lables used for initial debug */
    priorYResponseState=1;               /* set this as different from the current state so as to trigger an initial update of the gui lables used for initial debug */
    priorResponseStatesWereSticky=true;  /* set this as different from the current state so as to trigger an initial update of the gui lables used for initial debug */
  }
  int getPortIndex(){
    return portIndex;
  }
  void setPortIndex(int ii){
    portIndex=ii;
  }
  boolean getAmJoyStickJogging(){
    return amJoyStickJogging;
  }
  void incrementNumJoyStickJoggingOKs(){
    numJoyStickJoggingOKs++;
  }
  int setDisableXButtonIndex(int ii){
    disableXButtonIndex=ii;
    return(ii);
  }
  int setLockCurrentStateButtonIndex(int ii){
    lockCurrentStateButtonIndex=ii;
    return(ii);
  }
  int setDisableYButtonIndex(int ii){
    disableYButtonIndex=ii;
    return(ii);
  }
  int getDisableXButtonIndex(){
    return(disableXButtonIndex);
  }
  int getDisableYButtonIndex(){
    return(disableYButtonIndex);
  }
  int setThrottleXandYButtonIndex(int ii){
    throttleXandYButtonIndex=ii;
    return(ii);
  }
  int getThrottleXandYButtonIndex(){
   return(throttleXandYButtonIndex);
  }
  int getLockCurrentStateButtonIndex(){
   return(lockCurrentStateButtonIndex);
  }
  void setXResponseState(int in){
    xResponseState=in;
  }
  void setPriorXResponseState(int in){
    priorXResponseState=in;
  }
  void setYResponseState(int in){
    yResponseState=in;
  }
  void setPriorYResponseState(int in){
    priorYResponseState=in;
  }
  int getXResponseState(){
    return(xResponseState);
  }
  int getYResponseState(){
    return(yResponseState);
  }
  int getPriorXResponseState(){
    return(priorXResponseState);
  }
  int getPriorYResponseState(){
    return(priorYResponseState);
  }
  void setResponseStatesAreSticky(boolean tf){
    responseStatesAreSticky=tf;
  }
  boolean getResponseStatesAreSticky(){
    return(responseStatesAreSticky);
  }
  void setPriorResponseStatesWereSticky(boolean tf){
    priorResponseStatesWereSticky=tf;
  }
  boolean getPriorResponseStatesWereSticky(){
    return(priorResponseStatesWereSticky);
  }
  /**************************************************************************************************************/
  void joyStickSerialEvent(String s){
    //log.debug("joyStickSerialEvent s="+s);
    float mid,full,mag,dir; /* mid==midpoint of the axis responses, full==Full range of axis response, mag==magnitude scaled 0 to 1, dir==direction pos or negative 1 */
    int[] gots=parseJoy(s);
    if(5==gots.length){
      /* 0 X */
      /* 1 Y */
      /* 2 R  Rotation is currently ignored*/
      /* 3 T  Throttle */
      /* 4 S */
      full=255;
      float min=.01;
      joyThrottle=min+(1-min)*log((1+gots[3])/full)/-5.545177444; /* flip it around so full forward is 1.0, full back is 0.01 ie  1 percent of full speed  */
      /* do not modify any GUI features from within the asynchronous serial functions */ 
      labelPreTexts [19]=String.format("Joy Throttle %3.0f%%",100.*joyThrottle);
      
      mid=511.5;
      mag=Math.abs((gots[0]-mid)/mid);
      dir=(gots[0]>mid)?1.0:-1.0;
      if(mag >= joyStickDeadZone){
        joyX=dir*(mag-joyStickDeadZone)/(1.0-joyStickDeadZone);  /* scale it from 0 at the edge of the dead zone, to 1 at full */
      } else {
        joyX=0.0;
      }
      mag=Math.abs((gots[1]-mid)/mid);
      dir=(gots[1]>mid)?-1.0:1.0;
      //log.debug(String.format("mid=%6.3f gots[1]=%4d mag=%6.3f %3.0f %s",mid,gots[1],mag,dir,(mag >= joyStickDeadZone)?"true":"false"));
      if(mag >= joyStickDeadZone){
        joyY=dir*(mag-joyStickDeadZone)/(1.0-joyStickDeadZone);  /* scale it from 0 at the edge of the dead zone, to 1 at full */
      } else {
        joyY=0.0;
      }
      //log.debug(String.format("joyX=%6.3f joyY=%6.3f throttle=%5.2f percent",joyX,joyY,joyThrottle*100.));
      
      joyHat = gots[4]>>12;
      //log.debug("joyHat="+joyHat);
      
      /* a potential scheme, now abandoned */
      /* boolean feedHold0;                /*  Trigger                            bit0    button 0  */
      /* //boolean resetSlashAbort;        /*  Thumb Switch                       bit1    button 1    not connected, I hit it too much unintentionally */                                              
      /* boolean auxPowerOff;              /*  Near Button Left of Hat            bit2    button 2  */
      /* boolean auxPowerOn;               /*  Near Button Right of Hat           bit3    button 3  */
      /* boolean feedHold1;                /*  Far Button Left of Hat             bit4    button 4  */
      /* boolean cycleStartSlashResume;    /*  Far Button Right of Hat            bit5    button 5  */
      /* boolean motorsDisable;            /*  Lower Far Button on Base           bit6    button 6  */
      /* boolean motorsEnable;             /*  Upper Far Button on Base           bit7    button 7  */
      /* boolean disable joystick X        /*  Lower Mid-Distance Button on Base  bit8    button 8  */
      /* boolean disable joystick Y        /*  Upper Mid-Distance Button on Base  bit9    button 9  */
      /* boolean coolantSlashLaserDisable; /*  Lower Near Button on Base          bit10   button 10 */
      /* boolean useThrottleOnXY        ;  /*  Upper Near Button on Base          bit11   Button 11 */
      
      //String gs="0000000000000000"+Integer.toBinaryString(gots[4]);
      //gs=gs.substring(gs.length()-16);
      //log.debug("gs says gots[4]="+gots[4]+" "+gs);      
      boolean propigatableChange=false;
      int seed=2048;
      for(int ii=11;ii>=0;ii--){
        //String ss="0000000000000000"+Integer.toBinaryString(seed);
        //ss=ss.substring(ss.length()-16);
        //int a=gots[4]&seed;
        //log.debug(String.format("gots[4]=%5d=%16s seed=%s %s %d",gots[4],gs,ss,((0!=(gots[4]&seed))?"true":"false"),a));
        boolean tf=(0!=(gots[4]&seed));
        if(tf != joyStickButtons[ii]){    /* go thru the checking only if this button has changed */
          if(   tf 
             && !joyStickButtons[ii]           
            ){
            joyStickButtons[ii]=true;
            responseStatesAreSticky=(ii==lockCurrentStateButtonIndex);
            if(ii!=lockCurrentStateButtonIndex){
              propigatableChange=true;
            }
            //log.debug("");
            //log.debug(String.format("setting joyStickButton[%2d]=true and responseStatesAreSticky=%s propigatableChange=%s",ii,(responseStatesAreSticky?"true ":"false"),(propigatableChange?"true ":"false")));
          } else
          if(   !tf
             && (  !responseStatesAreSticky
                 || ii==lockCurrentStateButtonIndex
                ) 
             && joyStickButtons[ii]
            ){
            joyStickButtons[ii]=false;          
            if(ii!=lockCurrentStateButtonIndex){
              propigatableChange=true;
            }
            //log.debug("");
            //log.debug(String.format("setting joyStickButton[%2d]=false propigatableChange=%s",ii,(propigatableChange?"true ":"false")));
          } 
          // else 
          // if(   ii != disableXButtonIndex        
          //    && ii != disableYButtonIndex        
          //    && ii != throttleXandYButtonIndex   
          //    && ii != lockCurrentStateButtonIndex
          //   ){
          //   // log.debug(
          //   //   String.format(
          //   //    "ii=%2d seed=%4d %s",
          //   //    ii,
          //   //    seed,
          //   //    "don't care"
          //   // ));
          // } else  { 
          //   log.debug(
          //     String.format(
          //       "ii=%2d seed=%4d %s %s",
          //       ii,
          //       seed,
          //       joyStickButtons[ii]?"true ":"false",
          //       responseStatesAreSticky?"true ":"false"
          //   ));
          // }
        }
        // else {
        //  log.debug(
        //   //  String.format(
        //   //   "ii=%2d seed=%4d %s",
        //   //   ii,
        //   //   seed,
        //   //   "unchanged"
        //   //));  
        //}
        seed/=2; 
      }     
      if(verboseLogging){
        Long aTime= System.nanoTime();
        String hatState="";
        switch(joyHat) {
          case 8: hatState="Center";
            break;
          case 0: hatState="Up    ";
            break;
          case 1: hatState="Up Rt ";
            break;
          case 2: hatState="Rt    ";
            break;
          case 3: hatState="Dn Rt ";
            break;
          case 4: hatState="Dn    ";
            break;
          case 5: hatState="Dn Lf ";
            break;
          case 6: hatState="Lf    ";
            break;
          case 7: hatState="Up Lf ";
            break;
          default: hatState="WTF   ";
            break;
        }
        String s0=String.format("%7.3f,%5.3f,%5.3f,%3.0f,%s,%s,%s,%s,%s",
           ((aTime - time3) / 1.0e+9),
           joyX,
           joyY,
           joyThrottle*100,
           hatState,
           joyStickButtons[disableXButtonIndex        ]?"true ":"false",
           joyStickButtons[disableYButtonIndex        ]?"true ":"false",
           joyStickButtons[throttleXandYButtonIndex   ]?"true ":"false",
           joyStickButtons[lockCurrentStateButtonIndex]?"true ":"false"
        );
        log0.debug(s0);
        //log.debug(s0);
      }
      if(propigatableChange){
        if(  joyStickButtons[throttleXandYButtonIndex   ]
           ||joyStickButtons[disableXButtonIndex        ]
           ||joyStickButtons[disableYButtonIndex        ]
           ){
          responseStatesAreSticky=false;
          //log.debug("A a joystick button other than buton[lockCurrentStateButtonIndex="+lockCurrentStateButtonIndex+"] changed state, so responseStatesAreSticky=false");
        }
        if(  joyStickButtons[throttleXandYButtonIndex   ]
           && (  (1!=xResponseState)
               ||(1!=yResponseState)
              ) 
          ){
          xResponseState=1;
          yResponseState=1;
          //log.debug("C  joystick button[throttleXandYButtonIndex="+throttleXandYButtonIndex+"] && ((1!= xResponseState=="+xResponseState+") ||(1!= yResponseState=="+yResponseState+"))");
        }
        if(joyStickButtons[disableXButtonIndex]){
          xResponseState=2;
          //log.debug("D  joystick button[disableXButtonIndex="+disableXButtonIndex+"]");
        }
        if(joyStickButtons[disableYButtonIndex]){
          yResponseState=2;
          //log.debug("E  joystick button[disableYButtonIndex="+disableYButtonIndex+"]");
        }
        if(joyStickButtons[lockCurrentStateButtonIndex]){
          responseStatesAreSticky=true;
          //log.debug("F  joystick button[lockCurrentStateButtonIndex="+lockCurrentStateButtonIndex+"]");
        }
        if(    !joyStickButtons[throttleXandYButtonIndex]
            && !responseStatesAreSticky
            && (1==xResponseState) 
          ){
          xResponseState=0;
          //log.debug("G joystick !button[throttleXandYButtonIndex="+throttleXandYButtonIndex+"] && !responseStatesAreSticky && (1==xResponseState)");
        }
        if(    !joyStickButtons[throttleXandYButtonIndex]
            && !responseStatesAreSticky
            && (1==yResponseState) 
          ){
          yResponseState=0;
          //log.debug("H joystick !button[throttleXandYButtonIndex="+throttleXandYButtonIndex+"] && !responseStatesAreSticky && (1==yResponseState)");
        }
        if(   !joyStickButtons[disableXButtonIndex]
           && !responseStatesAreSticky
          ){
          if(joyStickButtons[throttleXandYButtonIndex]){
            xResponseState=1;
            //log.debug("I joystick !button[disableXButtonIndex=" +disableXButtonIndex+"] && !responseStatesAreSticky &&  button[throttleXandYButtonIndex="+throttleXandYButtonIndex +"]");
          } else {
            xResponseState=0;
            //log.debug("J joystick !button[disableXButtonIndex="+disableXButtonIndex +"] && !responseStatesAreSticky && !button[throttleXandYButtonIndex="+throttleXandYButtonIndex +"]");
          }
          //log.debug("joystick button[disableXButtonIndex="+disableXButtonIndex+"]");
          //labelPreTexts[21]="X state=2 preState="+priorXResponseState;
        }
        if(   !joyStickButtons[disableYButtonIndex]
           && !responseStatesAreSticky
          ){
          if(joyStickButtons[throttleXandYButtonIndex]){
            yResponseState=1;
            //log.debug("K joystick !button[disableYButtonIndex=" +disableYButtonIndex+"] && !responseStatesAreSticky &&  button[throttleXandYButtonIndex="+throttleXandYButtonIndex +"]");
          } else {
            yResponseState=0;
            //log.debug("L joystick !button[disableYButtonIndex="+disableYButtonIndex +"] && !responseStatesAreSticky && !button[throttleXandYButtonIndex="+throttleXandYButtonIndex +"]");
          }
          //labelPreTexts[29]="Y state=2 preState="+priorYResponseState;
        }
        // log.debug(
        //   String.format(
        //     "M %s %s %s %s xResponseState=%d yResponseState=%d responseStatesAreSticky=%s",
        //     joyStickButtons[disableXButtonIndex        ]?"true ":"false",
        //     joyStickButtons[disableYButtonIndex        ]?"true ":"false",
        //     joyStickButtons[throttleXandYButtonIndex   ]?"true ":"false",
        //     joyStickButtons[lockCurrentStateButtonIndex]?"true ":"false",
        //     xResponseState,
        //     yResponseState,
        //     responseStatesAreSticky?"true ":"false"
        // ));  
      }
    } else {  
      log.debug("got a J0Y, with gots.length not 5 s="+s);
    }
    //log.debug(
    //   String.format(
    //     "N %s %s %s %s xResponseState=%d yResponseState=%d responseStatesAreSticky=%s",
    //     joyStickButtons[disableXButtonIndex        ]?"true ":"false",
    //     joyStickButtons[disableYButtonIndex        ]?"true ":"false",
    //     joyStickButtons[throttleXandYButtonIndex   ]?"true ":"false",
    //     joyStickButtons[lockCurrentStateButtonIndex]?"true ":"false",
    //     xResponseState,
    //     yResponseState,
    //     responseStatesAreSticky?"true ":"false"
    // ));  
  }
  /**************************************************************************************************************/
  /* joyX and joyY have been censored by the serialEvent handler to ignore a deadzone */
  void doJoyStickJogging(){

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
 // 
      if(  (joyX != 0.0)
         ||(joyY != 0.0)
         ||(hatUpOrDown)
        ){
        float multiFactorX=(-1==disableXButtonIndex)?1.0:joyStickButtons[disableXButtonIndex]?0.0:1.0;
        float multiFactorY=(-1==disableYButtonIndex)?1.0:joyStickButtons[disableYButtonIndex]?0.0:1.0;   
        //log.debug(String.format("joy=(%6.3f,%6.3f) multiFactor=(%.0f,%.0f)",joyX,joyY,multiFactorX,multiFactorY));
        float timePerDraw=1.0/frameRate;
        float deltaX=0.0;
        float deltaY=0.0;
        float deltaZ=0.0;
        // 
        if(joyX != 0.0){
          deltaX=(joyStickButtons[throttleXandYButtonIndex]?joyThrottle:1.0)*multiFactorX*joyX*maxFeedRates[0]/60*timePerDraw;
        }
        if(joyY != 0.0){
          deltaY=(joyStickButtons[throttleXandYButtonIndex]?joyThrottle:1.0)*multiFactorY*joyY*maxFeedRates[1]/60*timePerDraw;
          deltaX+=xResidue;
          xResidue=deltaX-(float)Math.round(deltaX * 1000.0) / 1000.0;
        }
        if(!amJoyStickJogging){
          numJoyStickJogsSent=0;
          numJoyStickJoggingOKs=0;  
          xNonOrthogonalResidue=0.0;
        }
        if(hatUpOrDown){
          deltaZ=joyThrottle*((joyHat==0)?1.0:-1.0)*maxFeedRates[2]/60*timePerDraw;  
          //log.debug(String.format("deltaZ=%7.3f joyThrottle=%%%3.0f maxFeedRates[2]=%7.0f timePerDraw=%7.3f",deltaZ,joyThrottle*100,maxFeedRates[2],timePerDraw));
        } 
        //log.debug(String.format("vel calc sqrt(%9.3f + %9.3f + %9.3f)",(joyX*maxFeedRates[0]*joyX*maxFeedRates[0]),(joyY*maxFeedRates[1] * joyY*maxFeedRates[1]),(joyThrottle*maxFeedRates[2] * joyThrottle*maxFeedRates[2] * (hatUpOrDown?1.0:0.0))));
        double vel=Math.sqrt( (joyX*maxFeedRates[0] * joyX*maxFeedRates[0]) + (joyY*maxFeedRates[1] * joyY*maxFeedRates[1]) + (joyThrottle*maxFeedRates[2] * joyThrottle*maxFeedRates[2] * (hatUpOrDown?1.0:0.0) ));
        //log.debug(String.format("deltaY=%6.3f deltaX=%6.3f deltaX=%12.9f xResidue=%12.9f",deltaY,deltaX,deltaX,xResidue));
        // 
        amJoyStickJogging=true;
        msg="";
        if(  (0.0005 > abs(deltaY))
           &&(0.0005 < abs(deltaX))
           &&(!hatUpOrDown)
          ){
          msg=String.format("$J=G91 X%.3f F%.3f\n",deltaX,vel);          
        } else
        if(  (0.0005 > abs(deltaX))
           &&(0.0005 < abs(deltaY))
           &&(!hatUpOrDown)
          ){
          msg=String.format("$J=G91 Y%.3f F%.3f\n",deltaY,vel);
        } else
        if(  (0.0005 < abs(deltaX))
           &&(0.0005 < abs(deltaY))
           &&(!hatUpOrDown)
        ){
          msg=String.format("$J=G91 X%.3f Y%.3f F%.3f\n",deltaX,deltaY,vel);
        } else
        if(  (0.0005 > abs(deltaY))
           &&(0.0005 < abs(deltaX))
          ){  
          msg=String.format("$J=G91 X%.3f Z%.3f F%.3f\n",deltaX,deltaZ,vel);
        } else
        if(  (0.0005 > abs(deltaX))
           &&(0.0005 < abs(deltaY))
          ){ 
          msg=String.format("$J=G91 Y%.3f Z%.3f F%.3f\n",deltaY,deltaZ,vel);
        } else
        if(  (0.0005 < abs(deltaX))
           &&(0.0005 < abs(deltaY))
          ){
          msg=String.format("$J=G91 X%.3f Y%.3f Z%.3f F%.3f\n",deltaX,deltaY,deltaZ,vel);
        } else
        if(  (0.0005 > abs(deltaX))
           &&(0.0005 > abs(deltaY))
          ){
          msg=String.format("$J=G91 Z%.3f F%.3f\n",deltaZ,vel);
        }
        if(0<msg.length()){
          numJoyStickJogsSent+=1;
          writeJoyJog(msg);
          //log.debug(String.format("joyX=%6.3f joyY=%6.3f throttle=%5.2f hat=%d numJoyStickJogsSent=%d vs %d=numJoggingOKs deltas=(%7.3f,%7.3f,%7.3f) vel=%9.3f",joyX,joyY,joyThrottle,joyHat,numJoyStickJogsSent,numJoyStickJoggingOKs,deltaX,deltaY,deltaZ,vel));
        }
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
} 
/************************************************************************************************************************************/
