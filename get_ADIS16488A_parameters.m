function [acc_parameters,magn_parameters,imu_name] = get_ADIS16488A_parameters()
imu_name = 'ADIS16488A';
%IMU PARAMETERS

% MAGNETOMETER

% initial bias error - ???????? ????? ???????????? from mGauss to T
bias_error = 15e-3 * 1e-4; % error, T
b_m = [sign(randn(1))*bias_error; 
    sign(randn(1))*bias_error; 
    sign(randn(1))*bias_error]; % random sign biases vector
 
% misalignment - axis to frame - ???????? ???? ????????????
mis_m   = deg2rad([0 sign(randn(1))*1 sign(randn(1))*1; 
    sign(randn(1))*1 0 sign(randn(1))*1; 
    sign(randn(1))*1 sign(randn(1))*1 0]) ; 

% initial sensitivity tolerance - ?????????? ??????????? ????????????
m_m = diag([ sign(randn(1))*0.02; sign(randn(1))*0.02; sign(randn(1))*0.02]) * 1; % 2% -> 0.02

% output noise
Density_m = 0.042 * 1e-6; % spectral density
BW        = 218.1; % bandwidth
sigma_m   = Density_m*sqrt(BW) * 1;

% ACCELEROMETER

% bias repeatability - ñìåùåíèå íóëåé
b_a     = [0.016; -0.016; 0.016] * 1;

% axis to axis misalignment - ïåðåêîñû îñåé 
mis_a   = deg2rad([0 -1e-3 0.035; -0.035 0 0.035; 0.35 -0.035 0]); 

% repeatability - ìàñøàòáíûå êîýôôèöèåíòû
m_a     = diag([-0.005; 0.005; -0.005]) * 1; % in %

% output noise
Density_a = 300 * 1e-6;
BW        = 218.1;
sigma_a   = Density_a * sqrt(BW) * 1;
        
acc_parameters  = struct('b_a', b_a, 'mis_a', mis_a, 'm_a', m_a, 'sigma_a', sigma_a);
magn_parameters = struct('b_m', b_m, 'mis_m', mis_m,'m_m', m_m,'sigma_m', sigma_m);


end