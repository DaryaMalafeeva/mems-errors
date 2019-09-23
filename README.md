# mems-errors
This script (main.m) can be useful for developers who works on inertial navigation (or something else using  mems-accelerometeres and mems-magnitometeres):
What's that?
You take required parameters for mems accelerometer (Initial Tolerance, Cross-Axis Sensitivity, Zero-G Initial Calibration Tolerance, Noise Power Spectral Density) and magnetometer (Zero-G Initial Calibration Tolerance, Sensitivity Scale Factor,...) from its datasheet, fill them into this script and get the angles errors.
We used NED coordiate system as LCS and RPY as OCS.
Here is the result for low-cost IMU MPU9250. 

