# mems-errors
This script (acc_model_enu.m) can be useful for developers who works on inertial navigation (or something else using  mems-accelerometeres and mems-magnitometeres).

What's that?  

You take required parameters for mems accelerometer (Initial Tolerance, Cross-Axis Sensitivity, Zero-G Initial Calibration Tolerance, Noise Power Spectral Density) and magnetometer (Zero-G Initial Calibration Tolerance, Sensitivity Scale Factor,...) from its datasheet, fill them into this script and get the angles errors.
We used ENU coordiate system as LCS (local coordinate system) and RPY as body frame coordinates.
Here is the result for low-cost IMU MPU9250 and for ADIS16488A. Main script is acc_model_enu.m 
