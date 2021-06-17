/*****************************************************************************************************************************/
void serialEvent(Serial p){ 
  //log.debug("cme@ serialEvent()");
  String s = p.readStringUntil('\n').trim();
  if(0==s.length()){
    //log.debug("serialEvent read() s.length="+s.length());
  } else {
    /**/log.debug("serialEvent read() s.length="+s.length()+" "+s);
    if(!gpsInitialized)initializeGPS();
  }  
  /* Initial peek at the stream of data which enters this method 
   * for(int ii=0;ii<s.length();ii++)println(String.format("%2d %c %3d",ii,s.charAt(ii),(int)s.charAt(ii))); 
   * That show-every-character for() has become legacy code
   */
  Instant now=Instant.now(); 
  Duration delta=Duration.between(priorInstant, now);
  StringBuilder sb = new StringBuilder();
  priorInstant=now;
  /* the $, the * and the two hex characters of the checksum are this 4 length */
  if(4<s.length()){    
    mtk3339Acknolwledged=true;
    String checkSumGot= s.substring(1+s.indexOf("*"));
    String checkSumSee= getNMEA_MTK_checksum(s.substring(1,s.indexOf("*")));
    if(1==checkSumSee.length())checkSumSee="0"+checkSumSee;
    //log.debug((checkSumGot.equals(checkSumSee)?"TRUE ":"false")+" "+s+" checkSumGot="+checkSumGot+" "+checkSumSee+" checkSumSee");
       
    if(checkSumGot.equals(checkSumSee)){
      if(s.startsWith("$GP")){
        if(!seeGPS){
          timeNSay("see GPS");
          seeGPS=true;
        }
        String[] packets=packetizer(s);
        //log.debug("number of GSGGA packets="+packets.length);
        if(s.startsWith("$GPGGA")){ 
          //log.debug("GPS Fix Data "+s);
          if(0<packets[2].length()){
            gotFix=true;
            label5.setText("have Fix");
            //log.debug(String.format("SE %d.%s   %s",delta.getSeconds(),String.format("%09d",delta.getNano()).substring(0,3),s));
            //log.debug(s);
            sb.setLength(0);
            if(!fixSeen){
              timeNSay("fix seen");  
            }
            //logDumpPackets(packets);
            String hhUTC=packets[1].substring(0,2);
            String mmUTC=packets[1].substring(2,4);
            String ssUTC=packets[1].substring(4,8);
            utc=hhUTC+":"+mmUTC+":"+ssUTC;
            //log.debug("UTC Time = "+utc);
            String deg=packets[2].substring(0,2);
            String min=packets[2].substring(2,4);
            String sec=packets[2].substring(5,7)+"."+packets[2].substring(7);
            //log.debug("deg="+deg+" min="+min+" sec="+sec);
            latitude=(packets[3].equals("N")?1.0:-1.0)*(Integer.parseInt(deg)+Integer.parseInt(min)/60.0+Double.parseDouble(sec)/3600.0);
            //log.debug(String.format("deg2n="+Integer.parseInt(deg)+" min2n="+Integer.parseInt(min)+" min2nn="+Integer.parseInt(min)/60.0+" sec2n="+Double.parseDouble(sec)+" sec2nn="+Double.parseDouble(sec)/360000.0));
            //log.debug("Latitude  "+(packets[4].charAt(0)=='0'?"":" ")+deg+"°"+min+"'"+sec+"\""+packets[3]+"  latitude="+String.format("%9.5f",latitude));
            deg=packets[4].substring((packets[4].charAt(0)=='0'?1:0),3);
            min=packets[4].substring(3,5);
            sec=packets[4].substring(6,8)+"."+packets[4].substring(8);
            //log.debug("deg="+deg+" min="+min+" sec="+sec);
            longitude=(packets[5].equals("W")?-1.0:1.0)*(Integer.parseInt(deg)+Integer.parseInt(min)/60.0+Double.parseDouble(sec)/3600.0);
            //log.debug(String.format("deg2n="+Integer.parseInt(deg)+" min2n="+Integer.parseInt(min)+" min2nn="+Integer.parseInt(min)/60.0+" sec2n="+Double.parseDouble(sec)+" sec2nn="+Double.parseDouble(sec)/360000.0));
            //log.debug("Longitude "+deg+"°"+min+"'"+sec+"\""+packets[5]+"  longitude="+String.format("%10.5f",longitude));
            String fix="Fix Not Available";
            positionFixIndicator=packets[6];
            if(packets[6].equals("1"))fix="GPS fix";
            if(packets[6].equals("2"))fix="Differential GPS fix";
            //log.debug("fix is "+fix);
            numSatellites=Integer.parseInt(packets[7]);
            label6.setText(String.format("%2d Satellites Active",numSatellites));
            //log.debug("satellites used="+numSatellites);
            //hdop=Double.parseDouble(packets[8]);
            //log.debug("HDOP="+packets[8]);
            altitude=Double.parseDouble(packets[9]);
            //log.debug("MSL Altitude="+packets[9]+" "+packets[10].toLowerCase());
            //geoidalSeparation=Double.parseDouble(packets[11]); /* Height of GeoID (mean sea level) above WGS84 ellipsoid, meter */
            //log.debug("Geoidal Separation="+packets[11]+" "+packets[12].toLowerCase());
            ageOfDiffCorr0=(0==packets[13].length())?0:Integer.parseInt(packets[13]);
            ageOfDiffCorr1=(0==packets[14].length())?0:Integer.parseInt(packets[14]);

            //log.debug("Age of Diff. Corr. ="+packets[13]+","+packets[14]);
            /* This full version pumps out all the stuff from the GGA  BUT
             * After my first pull, it seemed like the last 6 were not as useful as their names suggested 
             */
            //sb.append(
            //  String.format(
            //    "%10.5f,%9.5f,%5.1f,%2d,%s,%4.2f,%4.2f,%4.2f,%4.1f,%d,%d",                
            //    longitude,
            //    latitude,
            //    altitude,
            //    numSatellites,
            //    utc,
            //    pdop,
            //    hdop,
            //    vdop,
            //    geoidalSeparation,
            //    ageOfDiffCorr0,
            //    ageOfDiffCorr1           
            //  )  
            //);
            sb.append(
              String.format(
                "%10.5f,%9.5f,%5.1f,%2d,%s,%s,%d,%d",                
                longitude,
                latitude,
                altitude,
                numSatellites,
                utc,
                packets[6],
                ageOfDiffCorr0,
                ageOfDiffCorr1
              )  
            );
            //log.debug("2 append ok sb.length="+sb.length()+" sb="+sb);
            log1.debug(sb);
            label1.setText(String.format("%9.5f  %9.5f   %7.1fm",latitude,longitude,altitude));
            xyz0=wgs84XYZfromLatLonAlt(latitude,longitude,altitude);
            xyz1=wgs84XYZfromLatLonAlt(latitude+oneOneHundredthArcSecond,longitude                         ,altitude);
            //formatXYZ();
            double dx=xyz1[0]-xyz0[0];
            double dy=xyz1[1]-xyz0[1];
            double dz=xyz1[2]-xyz0[2];
            double precision=Math.sqrt( (dx*dx)+(dy*dy)+(dz*dz));
            label8.setText(String.format( "Latitude(N-S)=%5.3fm",precision));
            xyz1=wgs84XYZfromLatLonAlt(latitude                         ,longitude+oneOneHundredthArcSecond,altitude);
            //formatXYZ();
            dx=xyz1[0]-xyz0[0];
            dy=xyz1[1]-xyz0[1];
            dz=xyz1[2]-xyz0[2];
            precision=Math.sqrt( (dx*dx)+(dy*dy)+(dz*dz));       
            label9.setText(String.format("Longitude(E-W)=%5.3fm",precision));
            ggaSeenPriorToGsv=true;
          } else {  
            // log.debug("have no fix");
            gotFix=false;
            label5.setText("no Fix");
          }
        } else
        if(gotFix){
          if(gotFix && s.startsWith("$GPGSA")){
            /* a problem to be delt with is that GSV can report on more satellites than are active */
            //log.debug("DOPS and Active Satellites "+s);
            //logDumpPackets(packets);
            if(3 < packets[packets.length-1].length()){ 
              //log.debug(String.format("SE %d.%s   %s",delta.getSeconds(),String.format("%09d",delta.getNano()).substring(0,3),s));
              sb.setLength(0);
              //logDumpPackets(packets);
              pdop=Double.parseDouble(packets[packets.length-3]);
              hdop=Double.parseDouble(packets[packets.length-2]);
              vdop=Double.parseDouble(packets[packets.length-1]);
              log3.debug(String.format("%s,%4.2f,%4.2f,%4.2f",utc,hdop,vdop,pdop));
              //log.debug(String.format("pdop=%4.2f hdop=%4.2f vdop=%4.2f",pdop,hdop,vdop));
              /* prep up for interpreting the GSV inputs */
              for(int ii = 1;ii<100;ii++){
                activeSatelliteIDs[ii]=false; /* use the provided Id numbers, ie 0 is not used */
              }              
              int limit=3+numSatellites;
              for(int ii=3;ii<limit;ii++){
                int id=Integer.parseInt(packets[ii]);
                //log.debug(String.format("see id=%02d as active",id));
                activeSatelliteIDs[id]=true;
              }
              gsaSeenPriorToGsv=true;
            }  
          } else
          if(s.startsWith("$GPGSV")){
            //log.debug("Satellites in view, can be multiple rows, 4 or fewer per row "+s);
            //logDumpPackets(packets);
            if(  ggaSeenPriorToGsv
               &&gsaSeenPriorToGsv
              ){
              int lim=packets.length;
              //log.debug("lim="+lim);
              for(int ii=4;ii<lim;ii+=4){
                 //log.debug("going in with ii="+ii);
                 int id=Integer.parseInt(packets[ii]);
                 //log.debug(String.format("see id=%02d as active. Assigning packets[%2d] %2d %2d %2d",id,ii,ii+1,ii+2,ii+3));
                 elevations    [id]=packets[ii+1];
                 azimuths      [id]=packets[ii+2];
                 signalToNoises[id]=packets[ii+3];
              }  
              /* if we are at the end of our last GSV, dump the full 99 satellites worth to the .csv */
              if(packets[1].equals(packets[2])){
                //log.debug("am at end of last GSV in this cluster");
                sb.setLength(0);
                for(int ii=1;ii<100;ii++){
                  //log.debug(String.format("%2d %s",ii,sb));
                  //log.debug(String.format("elevations[%2d].length()=",ii,elevations[ii].length()));
                  sb.append(
                    String.format(
                      "%s,%s,%s,%s,%s",
                      (1==ii?utc:""),
                      activeSatelliteIDs[ii]?"Y":"N",
                      null==elevations     [ii]?"":elevations    [ii],
                      null==azimuths       [ii]?"":azimuths      [ii],
                      null==signalToNoises [ii]?"":signalToNoises[ii]
                    )
                  );
                }
                //log.debug(sb);
                log4.debug(sb);
              } //else {
                //log.debug("expecting another GSV before output");
              //}  
            } //else {
              //log.debug("upon startup, hit the GSV first");
            //}  
          } else
          if(s.startsWith("$GPRMC")){
            //log.debug("Recommended Minimum Specific GNSS Sentence"+s);
          } else
          /* for those using the GPS as a velocity or dead reconning app this would be key
           */
          if(s.startsWith("$GPVTG")){  
            //log.debug("Course and Speed over Ground "+s);
            //logDumpPackets(packets);
            /* per https://docs.rs-online.com/e883/0900766b8147dbed.pdf
             * these fields are
             *  0 GPVTG              message ID
             *  1 COG(T)             Course over ground(true) indegrees
             *  2 T                  fixed field: True
             *  3 COG(M)             Course over ground (magnetic), not being output
             *  4 M                  fixed field: Magnetic
             *  5 Speed              Speed over ground in knots           
             *  6 N                  Fixed field: knots           
             *  7 Speed              speed over ground in km/h
             *  8 K                  Fixed field, km/h
             *  9 positioning mode   N=noFix   A = autonomous gnss fix    D= differential gnss fix
             * 10 *                  end of data field
             *  11 checksum          Hexadecimal checksum
             * <CR><LF>              end of message
            */
            String cog=packets[1];
            String speed=packets[7];
             sb.append(
               String.format(
                 "%s,%s",                
                 cog,
                 speed       
               )  
             );
             //log.debug("2 append ok sb.length="+sb.length()+" sb="+sb);
             log2.debug(sb);
          } else
          if(s.startsWith("$GPGLL")){
            //log.debug("Geographic Position Latitude Longitude "+s);
          } else
          if(s.startsWith("$GPZDA")){
            //log.debug("Date Time Year and Local Time Zone Offset "+s);
          }else {
            log.error("recieved unhandled $GP response");
          }
        }
      } else 
      if(s.startsWith("$PMTK")){
        log.info("PMTK msg   "+s);
        String[] packets=packetizer(s);        
        //log.debug("number of PMTK packets="+packets.length);      
        if(packets[0].equals("001")){ /* this is acknowledging a command */
           mtk3339Acknolwledged=true;
           if(  (packets[1].equals("314")) 
              ||(packets[1].equals("220"))
             ){
             if(!packets[2].equals("3")){
               String msg="FATAL ERROR   setup command PMTK"+packets[1]+" not successfull";
               log.error(msg);
               println(msg);
               System.exit(1);
             } else {
               if(packets[1].equals("314")){
                 log.info("PMTK314, selection of outputs, recieved and installed");
               } else {
                 log.info("PMTK220, time delay between fix acquisitions, recieved and installed");
               }  
             }            
           } 
        } else
        if(packets[0].equals("705")){
          log.info("firmware release string="+packets[1]+"   Build_Id="+packets[2]+"    Internal_USE_1="+packets[3]+"   Internal_Use_2="+packets[4]);
        } else
        if(packets[0].equals("CHN")){
          //log.info("see channels");
        } else {
          log.error("OMG unexpected PMTK packet[0]");
          //for(int ii=0;ii<packets.length;ii++){
          //  log.debug(String.format("PMTK packets[%2d]=%s",ii,packets[ii]));
          //}
          logDumpPackets(packets);
        }    
      } else {
        log.error("OMG checksum good msg did not startWith \"$GP\" or with \"$PMTK\"");
      }
    } else {
      log.error("recieved a bad checksum in msg="+s); 
    }
  }  
  //log.debug("at end of serialEvent");
} 

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
void serialMTKPush(String s){
  /* this accepts the raw string (yes with the PMTK at the front, 
   * but without the $ at the front
   * and without the * and the checksum at the end
   */
  int len=s.length();
  byte[]  portByteArray = new byte[6+s.length()];
  String checkSum=getNMEA_MTK_checksum(s);
  portByteArray[0]='$';
  for(int ii=0;ii<len;ii++){
    portByteArray[1+ii]=(byte)s.charAt(ii);
  }  
  portByteArray[len+1]='*';
  portByteArray[len+2]=(byte)checkSum.charAt(0);
  portByteArray[len+3]=(byte)checkSum.charAt(1);
  portByteArray[len+4]=(byte)13;
  portByteArray[len+5]=(byte)10;
  //for(int ii=0;ii<6+len;ii++){
  //  log.debug(String.format("portByteArray[%3d]=%3d %c ",ii,portByteArray[ii],(char)portByteArray[ii]));
  //}
  port.write(portByteArray);
}

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
