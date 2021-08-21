/*                           0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  */ 
int [] grblSettingIndices = {0  ,1  ,2  ,3  ,4  ,5  ,6  ,10 ,11 ,12 ,13 ,20 ,21 ,22 ,23 ,24 ,25 ,26 ,27 ,30 ,31 ,32 ,100,101,102,110,111,112,120,121,122,130,131,132};
String [] grblSettingTexts = {
"Step pulse, microseconds",
"Step idle delay, milliseconds",
"Step port invert, mask",
"Direction port invert, mask",
"Step enable invert, boolean",
"Limit pins invert, boolean",
"Probe pin invert, boolean",
"Status report, mask",
"Junction deviation, mm",
"Arc tolerance, mm",
"Report inches, boolean",
"Soft limits, boolean",
"Hard limits, boolean",
"Homing cycle, boolean",
"Homing dir invert, mask",
"Homing feed, mm/min",
"Homing seek, mm/min",
"Homing debounce, milliseconds",
"Homing pull-off, mm",
"Max spindle speed, RPM",
"Min spindle speed, RPM",
"Laser mode, boolean",
"X steps/mm",
"Y steps/mm",
"Z steps/mm",
"X Max rate, mm/min",
"Y Max rate, mm/min",
"Z Max rate, mm/min",
"X Acceleration, mm/sec^2",
"Y Acceleration, mm/sec^2",
"Z Acceleration, mm/sec^2",
"X Max travel, mm",
"Y Max travel, mm",
"Z Max travel, mm"
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
"Tool number greater than max supported value."  
}; 
/* 
