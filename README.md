# Grbl4P

Processing3 GRBL GUI

GUI interface to GRBL V1.1 CNC control using Processing 3.    Newly added support for running X,Y,and Z motion control with a Logitec 3D Pro joystick on my Raspberry Pi CNC.    This uses a second arduino uno with a USB Host Shield as the joystick interface. Arduino code is in the seperate grbl project LE3DP_4_Grbl4P.

The motivation for the creation of Grbl4P was a desire to have an easily extendable front end gui panel within a framework which enables
easy ententions with java and/or scala.   The joystick near-real-time input from an analog device is the first implementation of this kind of control.   Force feedback is next on my list. 

All code provided is java, using only the Processing 3 included IDE.
All GUI controls are from the Processing G4P Library, and were created with the G4P GUI Builder tool.

File streaming is Implemented with the grbl recommended buffer-stuffing streamer protocol, same function as the grbl provided streaming.py

App opens a serial interface to each of the available USB ports, and recognizes the "hello" from the grbl arduino UNO, and the optional second UNO with the USB Host Shield.

Choise of Processing3 as my programming framework has proved out as having been a good choise. The IDE framework has been easy to work with on both both button-label-textfield GUI (present GitHub project), and for interactive 3D rendering (not this gitHub project).  It also supports logging, and several drawing extensions I used for creating patent drawings.   The IDE supports javadocs, and has been helpful in debugging those typing errors.   More pernitious errors have been aided by extendive debug logging.   And most gratifying is that super extensions, like Peter Abeles'  boofCV Processing3 port functions nicely even in a Raspberry PI.  

Updated the joystick interface for a Logitech extreme 3D pro running with Grbl4P running on a Raspberry Pi, with the USB joystick connects to a USBHos Shield on a second arduino. This allows buttons on the joystick base to disable X or disable Y or cause the XY motion to be proportional to the Throttle.   Clicking the trigger while one of the base buttons is active causes the control to be "sticky" and not reset when the button is releases.   

Autocorrection for non-orthogonal X and Y axies.   Added new feature which can be activated by uncommenting, and entering a non-zero value for angleYDiffersFromXOrthogonality in \Grbl4P\Data\Grbl4P.config     Grbl4P will then tweek X to add or subract appropriately when Y is changed.  Added a label to the GUI to show how the orthogonality of X vs Y is reflected in the config.

![Image of Grbl4P GUI](https://github.com/TPMoyer/Grbl4P/blob/master/Grbl4P_Panel.png)

Grbl homepage is at https://github.com/gnea/grbl/wiki
