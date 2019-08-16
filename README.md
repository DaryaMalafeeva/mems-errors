# mems-errors
Script may be useful for developers who works on inertial navigation (or smth else) using  mems accelerometeres and magnitometeres:
What's that?
You take needed parameters for mems accelerometer (Initial Tolerance, Cross-Axis Sensitivity, Zero-G Initial Calibration Tolerance, Noise Power Spectral Density) and magnetometer(Zero-G Initial Calibration Tolerance, Sensitivity Scale Factor,..) from its datasheet, put them to this script and get the angles errors. 
///

As you'll see, angles errors depends on every angle at the same time. 
