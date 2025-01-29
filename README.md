# Grbl4P

Gcode Sender for GRBL and GrblHAL

GUI interface to GRBL V1.1 and GrblHAL CNC control using Java under the Processing 4 framework.   Java because of the large programmer base and multiplatform support.   This sender works on windows, generic linux, and Raspberry PIs.   Procedssing because of the extensive plugin (such as the G4P controls) and hardware interfaces(such as RPI GPIO and boofCV)   

All code provided is java, using only the Processing 4 included IDE.
All GUI controls are from the Processing G4P Library, and were created with the G4P GUI Builder tool.

File streaming is Implemented with the grbl recommended buffer-stuffing streamer protocol, same function as the grbl provided streaming.py

App opens a serial interface to each of the available USB ports, and recognizes the "hello" from the grbl arduino UNO, or GrblHAL (tested only on the RP2040).

Choise of Processing as my programming framework has proved out as having been a good choise. The IDE framework has been easy to work with on both both button-label-textfield GUI (present GitHub project), and for interactive 3D rendering (not this gitHub project).  It also supports logging, and several drawing extensions I used for creating patent drawings.   The IDE supports javadocs, and has been helpful in debugging those typing errors.   More pernitious errors have been aided by extendive debug logging.   And most gratifying is that super extensions, like Peter Abeles'  boofCV Processing3 port functions nicely even in a Raspberry PI.  

Autocorrection for non-orthogonal X and Y axies.   Added new feature which can be activated by uncommenting, and entering a non-zero value for angleYDiffersFromXOrthogonality in \Grbl4P\Data\Grbl4P.config     Grbl4P will then tweek X to add or subract appropriately when Y is changed.  Added a label to the GUI to show how the orthogonality of X vs Y is reflected in the config.

![Image of Grbl4P GUI](https://github.com/TPMoyer/Grbl4P/blob/master/Grbl4P_Panel.png)

Grbl homepage is at https://github.com/gnea/grbl/wiki
