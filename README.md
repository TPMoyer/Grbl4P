# Grbl4P
Processing3 GRBL GUI

GUI interface to GRBL V1.1 CNC control using Processing 3.

Intention was to create an easily extendable front end gui panel within a framework which enables
easy ententions with java and/or scala.  All code provided is java, using only the Processing 3 included IDE.
All GUI controls are from the Processing G4P Library, and were created with the G4P GUI Builder tool.

Did implement the grbl recommended buffer-stuffing streaming protocal, same function as the grbl provided streaming.py

At app startup, Grbl4P will cycle through the available COM ports, until it gets a grbl "hello".   The first variable
in the Grbl4P.pde is knownGoodGrblComPort.  It can be changed to whatever port you know your grbl is on, to speed up 
the initialization process by going to your correct choice first. 

Have not yet written a "3D image the tool-path" viewer.   

First application for me:
   Autofocus for a Celestron M90 telescope as part of a long-working distance 2D position encoder.
Processing has already proven it's worth, in that Peter Abeles'  boofCV Processing3 port
functions nicely within a Raspberry PI.  

[Image of Grbl4P GUI] (https://github.com/TPMoyer/Grbl4P/blob/master/README.md)

Grbl homepage is at https://github.com/gnea/grbl/wiki
