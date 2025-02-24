/* help topics:
Commands
Settings
Aux ports
Axis
Control signals
Coolant
General
Homing
Jogging
Limits
Probing
Spindle
Stepper
Tool change
X-axis
Y-axis
Z-axis
*/


/* these next two were acquired from output upon    $help settings        */
int [] grblSettingIndices = {
0,  
1,  
2,  
3,  
4,  
5,  
6,  
9,  
10, 
11, 
12, 
13, 
14, 
15, 
16, 
17, 
18, 
19, 
20, 
21, 
22, 
23, 
24, 
25, 
26, 
27, 
28, 
29, 
30, 
31, 
32, 
33, 
34, 
35, 
36, 
37, 
39, 
40, 
43, 
44, 
45, 
46, 
62, 
63, 
64, 
65, 
100,
101,
102,
103,
104,
105,
106,
107,
110,
111,
112,
113,
114,
115,
116,
117,
120,
121,
122,
123,
124,
125,
126,
127,
130,
131,
132,
133,
134,
135,
136,
137,
341,
342,
343,
344,
345,
346,
370,
372,
384,
394,
398,
481,
484,
486,
539,
650,
673
};
String [] grblSettingTexts = {
"Step pulse time in microseconds, min: 2.0",
"Step idle delay in milliseconds, max: 65535",
"Step pulse invert as axismask",
"Step direction invert as axismask",
"Invert stepper enable output(s) as axismask",
"Invert limit inputs as axismask",
"Invert probe input as boolean",
"PWM Spindle as bitfield where setting bit 0 enables the rest:",
"Status report options as bitfield:",
"Junction deviation in mm",
"Arc tolerance in mm",
"Report in inches as boolean",
"Invert control inputs as bitfield:",
"Invert coolant outputs as bitfield:",
"Invert spindle signals as bitfield:",
"Pullup disable control inputs as bitfield:",
"Pullup disable limit inputs as axismask",
"Pullup disable probe input as boolean",
"Soft limits enable as boolean",
"Hard limits enable as bitfield where setting bit 0 enables the rest:",
"Homing cycle as bitfield where setting bit 0 enables the rest:",
"Homing direction invert as axismask",
"Homing locate feed rate in mm/min",
"Homing search seek rate in mm/min",
"Homing switch debounce delay in milliseconds",
"Homing switch pull-off distance in mm",
"G73 Retract distance in mm",
"Pulse delay in microseconds, max: 20",
"Maximum spindle speed in RPM",
"Minimum spindle speed in RPM",
"Mode of operation:",
"Spindle PWM frequency in Hz",
"Spindle PWM off value in percent, max: 100",
"Spindle PWM min value in percent, max: 100",
"Spindle PWM max value in percent, max: 100",
"Steppers to keep enabled as axismask",
"Enable legacy RT commands as boolean",
"Limit jog commands as boolean",
"Homing passes, range: 1 - 128",
"Axes homing, first pass as axismask",
"Axes homing, second pass as axismask",
"Axes homing, third pass as axismask",
"Sleep enable as boolean",
"Feed hold actions as bitfield:",
"Force init alarm as boolean",
"Probing feed override as boolean",
"X-axis travel resolution in step/mm",
"Y-axis travel resolution in step/mm",
"Z-axis travel resolution in step/mm",
"A-axis travel resolution in step/mm",
"B-axis travel resolution in step/mm",
"C-axis travel resolution in step/mm",
"U-axis travel resolution in step/mm",
"V-axis travel resolution in step/mm",
"X-axis maximum rate in mm/min",
"Y-axis maximum rate in mm/min",
"Z-axis maximum rate in mm/min",
"A-axis maximum rate in mm/min",
"B-axis maximum rate in mm/min",
"C-axis maximum rate in mm/min",
"U-axis maximum rate in mm/min",
"V-axis maximum rate in mm/min",
"X-axis acceleration in mm/sec^2",
"Y-axis acceleration in mm/sec^2",
"Z-axis acceleration in mm/sec^2",
"A-axis acceleration in mm/sec^2",
"B-axis acceleration in mm/sec^2",
"C-axis acceleration in mm/sec^2",
"U-axis acceleration in mm/sec^2",
"V-axis acceleration in mm/sec^2",
"X-axis maximum travel in mm",
"Y-axis maximum travel in mm",
"Z-axis maximum travel in mm",
"A-axis maximum travel in mm",
"B-axis maximum travel in mm",
"C-axis maximum travel in mm",
"U-axis maximum travel in mm",
"V-axis maximum travel in mm",
"Tool change mode:",
"Tool change probing distance in mm",
"Tool change locate feed rate in mm/min",
"Tool change search seek rate in mm/min",
"Tool change probe pull-off rate in mm/min",
"Restore position after M6 as boolean",
"Invert I/O Port inputs as bitfield:",
"Invert I/O Port outputs as bitfield:",
"Disable G92 persistence as boolean",
"Spindle on delay in s, range: 0.5 - 20",
"Planner buffer blocks, range: 30 - 1000, reboot required",
"Autoreport interval in ms, range: 100 - 1000, reboot required",
"Unlock required after E-Stop as boolean",
"Lock coordinate systems as bitfield:",
"Spindle off delay in s, range: 0.5 - 20",
"File systems options as bitfield:",
"Coolant on delay in s, range: 0.5 - 2"
};
String [] ePROM_reads_or_writes={"G10", "L20", "G28", "G30", "$", "G54", "G56", "G57", "G58", "G59"};
String [] alarms = {
"Hard limit triggered. Machine position is likely lost due to sudden and immediate halt. Re-homing is highly recommended.",
"G-code motion target exceeds machine travel. Machine position safely retained. Alarm may be unlocked.",
"Reset while in motion. Grbl cannot guarantee position. Lost steps are likely. Re-homing is highly recommended.",
"Probe fail. The probe is not in the expected initial state before starting probe cycle, where G38.2 and G38.3 is not triggered and G38.4 and G38.5 is triggered.",
"Probe fail. Probe did not contact the workpiece within the programmed travel for G38.2 and G38.4.",
"Homing fail. Reset during active homing cycle.",
"Homing fail. Safety door was opened during active homing cycle.",
"Homing fail. Cycle failed to clear limit switch when pulling off. Try increasing pull-off setting or check wiring.",
"Homing fail. Could not find limit switch within search distance. Defined as 1.5 * max_travel on search and 5 * pulloff on locate phases."
};
String [] errors = {
"G-code words consist of a letter and a value. Letter was not found.",
"Numeric value format is not valid or missing an expected value.",
"Grbl '$' system command was not recognized or supported.",
"Negative value received for an expected positive value.",
"Homing cycle is not enabled via settings.",
"Minimum step pulse time must be greater than 3usec",
"EEPROM read failed. Reset and restored to default values.",
"Grbl '$' command cannot be used unless Grbl is IDLE. Ensures smooth operation during a job.",
"G-code locked out during alarm or jog state",
"Soft limits cannot be enabled without homing also enabled.",
"Max characters per line exceeded. Line was not processed and executed.",
"(Compile Option) Grbl '$' setting value exceeds the maximum step rate supported.",
"Safety door detected as opened and door state initiated.",
"(Grbl-Mega Only) Build info or startup line exceeded EEPROM line length limit.",
"Jog target exceeds machine travel. Command ignored.",
"Jog command with no '=' or contains prohibited g-code.",
"Laser mode requires PWM output.",
"",
"",
"Unsupported or invalid g-code command found in block.",
"More than one g-code command from same modal group found in block.",
"Feed rate has not yet been set or is undefined.",
"G-code command in block requires an integer value.",
"Two G-code commands that both require the use of the XYZ axis words were detected in the block.",
"A G-code word was repeated in the block.",
"A G-code command implicitly or explicitly requires XYZ axis words in the block, but none were detected.",
"N line number value is not within the valid range of 1 - 9,999,999.",
"A G-code command was sent, but is missing some required P or L value words in the line.",
"Grbl supports six work coordinate systems G54-G59. G59.1, G59.2, and G59.3 are not supported.",
"The G53 G-code command requires either a G0 seek or G1 feed motion mode to be active. A different motion was active.",
"There are unused axis words in the block and G80 motion mode cancel is active.",
"A G2 or G3 arc was commanded but there are no XYZ axis words in the selected plane to trace the arc.",
"The motion command has an invalid target. G2, G3, and G38.2 generates this error, if the arc is impossible to generate or if the probe target is the current position.",
"A G2 or G3 arc, traced with the radius definition, had a mathematical error when computing the arc geometry. Try either breaking up the arc into semi-circles or quadrants, or redefine them with the arc offset definition.",
"A G2 or G3 arc, traced with the offset definition, is missing the IJK offset word in the selected plane to trace the arc.",
"There are unused, leftover G-code words that aren't used by any command in the block.",
"The G43.1 dynamic tool length offset command cannot apply an offset to an axis other than its configured axis. The Grbl default axis is the Z-axis.",
"Tool number greater than max supported value.",
"Value out of range.",
"G-code command not allowed when tool change is pending.",
"Spindle not running when motion commanded in CSS or spindle sync mode.",
"Plane must be ZX for threading.",
"Max. feed rate exceeded.",
"RPM out of range.",
"Only homing is allowed when a limit switch is engaged.",
"Home machine to continue.",
"ATC: current tool is not set. Set current tool with M61.",
"Value word conflict.",
"",
"Emergency stop active.",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"SD Card mount failed.",
"SD Card file open/read failed.",
"SD Card directory listing failed.",
"SD Card directory not found.",
"SD Card file empty.",
"",
"",
"",
"",
"",
"Bluetooth initalisation failed.",

}; 
/* 
