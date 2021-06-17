/***************************************************************************************************************/
String getNMEA_MTK_checksum(String s){
  int checksum = 0;
  for(int ii = 0; ii < s.length(); ii++) {
    checksum = checksum ^ s.charAt(ii);
  }
  //log.debug("checksum in decimal ="+checksum+" cheksum in MTK required Hex="+Integer.toHexString(checksum) );
  return(Integer.toHexString(checksum).toUpperCase());
}
/**************************************************************************************************************/
void formatXYZ(){
  log.debug(
    String.format(
      "\n xyz0=(%16.6f,%16.6f,%16.6f)\n xyz1=(%16.6f,%16.6f,%16.6f)\ndelta=(%16.6f,%16.6f,%16.6f)",
      xyz0[0],
      xyz0[1],
      xyz0[2],
      xyz1[0],
      xyz1[1],
      xyz1[2],
      xyz1[0]-xyz0[0],
      xyz1[1]-xyz0[1],
      xyz1[2]-xyz0[2]
    )
  );
}  
/**************************************************************************************************************/
void checkWSG84CalculationNumbers(){
  log.debug(String.format("                   wsg84A =       %18.9f",wsg84A));
  log.debug(String.format("                   wsg84B =       %18.9f",wsg84B));
  log.debug(String.format("                   wsg84F =              %17.15f",wsg84F));
  log.debug(String.format("            wsg84ASquared = %16.1f",wsg84ASquared));
  log.debug(String.format("            wsg84BSquared = %16.1f",wsg84BSquared));
  log.debug(String.format("wsg84BSquaredOverASquared =             %15.12f",wsg84BSquaredOverASquared));
  log.debug(String.format(" oneOneHundredthArcSecond =             %15.12f",oneOneHundredthArcSecond));
  
  /* and a couple of unit tests */
  unitTest(   0.,   0.,1000.); /* at equator, on prime maridian: atlantic ocean south of Ghana, west of Gabon */
  unitTest(   0.,   0.,   0.); /* at equator, on prime maridian: atlantic ocean south of Ghana, west of Gabon */
  unitTest(  45., -70.,   0.); /* Somerset County, Maine USA */
  unitTest(  45., -70.,1000.); /* Somerset County, Maine USA */
  unitTest(   0.,  90.,   0.); /* Indian ocean, west of Indonesia */
  unitTest(   0., -90.,   0.); /* Pacific ocean, south of Guatamala, west of Equador */
  unitTest(   0., 180.,   0.); /* Pacific ocean, north of Fiji, west of Baker Island */
  unitTest(  45.,   0.,   0.); /* Puynormand France */
  unitTest(  89.,   0.,   0.); /* near north pole */
}
/**************************************************************************************************************/
void unitTest(double lat,double lon,double alt){
  log.debug("\n\n\n");
  xyz0=wgs84XYZfromLatLonAlt(lat,lon,alt);
  log.debug("\n");
  xyz1=wgs84XYZfromLatLonAlt(lat+oneOneHundredthArcSecond,lon                         ,alt);            
  formatXYZ();
  double dx=xyz1[0]-xyz0[0];
  double dy=xyz1[1]-xyz0[1];
  double dz=xyz1[2]-xyz0[2];
  log.debug(String.format("precision(N-S)=%5.3f",Math.sqrt( (dx*dx)+(dy*dy)+(dz*dz))));
  log.debug("\n");
  xyz1=wgs84XYZfromLatLonAlt(lat                         ,lon+oneOneHundredthArcSecond,alt);
  formatXYZ();  
  dx=xyz1[0]-xyz0[0];
  dy=xyz1[1]-xyz0[1];
  dz=xyz1[2]-xyz0[2];
  log.debug(String.format("precision(E-W)=%5.3f",Math.sqrt( (dx*dx)+(dy*dy)+(dz*dz))));
}
/**************************************************************************************************************/
double[] wgs84XYZfromLatLonAlt(double latIn,double lonIn, double altIn){
  //log.debug(String.format("got %15.9f %15.9f %8.3f",latIn,lonIn,altIn));
  double lat=Math.toRadians(latIn);
  double lon=Math.toRadians(lonIn);
  double cosPhi    = Math.cos(lat);/* North-South */
  double sinPhi    = Math.sin(lat);/* North-South */
  double cosLambda = Math.cos(lon);/* East-West   */
  double sinLambda = Math.sin(lon);/* East-West   */
  double n= wsg84ASquared/Math.sqrt(wsg84ASquared*cosPhi*cosPhi + wsg84BSquared*sinPhi*sinPhi);
  double nAlt=n+altIn;
  //log.debug(String.format("wgs\nlat=%12.9f cosPhi    = %14.12f sinPhi    = %15.12f\nlon=%12.9f cosLambda =%15.12f sinLambda = %15.12f alt=%6.1f n=%15.12f nAlt=%15.12f",lat,cosPhi,sinPhi,lon,cosLambda,sinLambda,altIn,n,nAlt));  
  double[] xyz=new double[3];
  xyz[0] = nAlt*cosPhi*cosLambda;
  xyz[1] = nAlt*cosPhi*sinLambda;
  xyz[2] = (wsg84BSquaredOverASquared*n+altitude)*sinPhi;  
  return xyz;   
}
/**************************************************************************************************************/
void initializeGPS(){  
  gpsInitialized=true;
  //portConnectedOk=true;
  //numPortsChecked+=1;
  log.debug("going for initialization. Ask for firmware version, and will then try to push setup parameters");
  /* The 605 is GPS firmware version query */
  portMsg="PMTK605";
  serialMTKPush(portMsg);    
  //Turn on the basic GGA and RMC info (what you typically want)
  //portMsg="PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
  
  // Turn on just minimum info (RMC only, latitude and longitude, no altitude):
  //portMsg="PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
  ///*               0 1 2 3 4 5                    17 18          */
  //portMsg="PMTK314,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"; /* this would pull only the GPS latitude, longitude, and elevation */
  
  /* warning about these next couple... 
   * bump up your milliSecondsBetweenReadings to 1000 or higher (variable instanced in GSP4P.pde near line 67)  
   * The CHN is a particularl time hog
   *
   * Turn on all known responses everything (know yea this:  not all of it is parsed!)
   */
  //portMsg="PMTK314,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1"; /* position 17 is the undocumented support of GPZDA, in case you need a satellite derived time metric */
  
  /* Go sniffing for any of the other channels which might have something.  
   * As of 2021/05/15 no no additional undocumented functions beyond the GPZDA previously found by others 
   */
  ///*               0 1 2 3 4 5                    17 18          */
  //portMsg="PMTK314,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"; 
  
  /*  0 GS   GLL     Geographic Position Latitude Longitude     no speed, no altitude
   *  1 GS   RMC     Recommended Minimum Specific GNSS Sentence     Latitude, longitude, speed, but no altitude
   *  2 GS   VTG  *  Course and Speed over Ground
   *  3 GS   GGA  *  GPS Fix Data
   *  4 GS   GSA  *  DOPS and Active Satellites   (DOP is Dilution Of Precision)
   *  5 GS   GSV  *  Satellites in view          This outputs one row per satellite
   * 17 GS   ZDA     Date Time Year and Local Time Zone Offset
   * 18 PMTK CHN     list of 32 integers       This is quite slow requiring > 0.5 sec to acqure/send 
   */
   
  /* My app is for ground position specification (land survey).
   * Will be trying for best-can-do measurement of Latitude, Longitude, and Elevation
   * Tactics expected to include 
   *     1) taking readings over extended time periods 
   *     2) censoring readings
   *          a) based on numbers of satellites visible.   First observed dependency, more is better, 3 is crap.
   *          b) pure math (time series regression:  Is new reading outside extablished expected range?)
   *          c) Are satellites aligned?    Geometry of intersecting spheres.  
   *          d) local weather conditions.  Time of flight said to vary due to atmosphere density vagaries.
   * want GGA every reading.
   * Grab VTG every 5'th iteration to be able to figure out if am on the move, and should reset accumulators.
   * Grab GSA every 5'th iteration (gives HDOP & VDOP) in case I figure out how to use the DOP's
   * Grab GSV every 5'th iteration  in case I can figure out filters based on excluding readings wherein multiple satellites are aligned
   */      
  /*               0 1 2 3 4 5                    17 18          */
  portMsg="PMTK314,0,0,5,1,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0";
  portMsg="PMTK314,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1";
  serialMTKPush(portMsg);
  
  portMsg=String.format("PMTK220,%d",milliSecondsBetweenReadings);
  serialMTKPush(portMsg);
  /* the unit response to a time which is too short is
   *        FATAL ERROR   initial setup or response Hz not successfull
   * bump up your milliSecondsBetweenReadings to 1000 or higher (variable instanced in GSP4P.pde near line 67)  
   */       
}  
/**************************************************************************************************************/
/* this relies on the Processing asyncronous SerialEvent() to set the seeGPS boolean */
void openSerialPort(boolean sayAllComPortNames){  
  initGPSstarted=true;
  if (port != null) port.stop();
  String[] portNames = Serial.list();
  println("portNames has "+portNames.length+" member"+(1<portNames.length?"s":""));

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
  if(sayAllComPortNames) {
    printArray(portNames);
    for(int ii=0;ii<portNames.length;ii++){
      log.debug(String.format("portNames[%2d]=%s",ii,portNames[ii]));
    }  
  }  
  for(int ii=0;ii<portNames.length;ii++){
    Instant portStart=Instant.now();
    try {     
      log.debug("efforting "+portNames[ii]);
      port = new Serial(this, portNames[ii], 9600);
      port.bufferUntil('\n');
      log.debug(String.format("bufferUntil(<CR>) returned at %7.3f",Duration.between(portStart,Instant.now()).toMillis()/1000.));
      numPortsChecked++;
    } catch (RuntimeException re){
      log.debug("catch on attempt at "+portNames[ii]);
      if(re.getMessage().contains("Port busy"))println("unable to attempt handshake on port=="+portNames[ii]+"   Port is busy");
    }
  } 
  if(0==numPortsChecked)logNCon("\nwas unable to attempt handshake on any COM port\n");
  log.debug("at end of openSerialPort");
}
/**************************************************************************************************************/
void initGUI(){  
  createGUI();
}  
/**************************************************************************************************************/
