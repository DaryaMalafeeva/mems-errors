function [acc_parameters,magn_parameters,imu_name] = get_MPU9250A_parameters()
imu_name = 'MPU9250A';
% MAGNETOMETER

% cross axis sensitivity 
mis_m = zeros(3,3); % unknown

% sensitivity initial tolerance
m_m = diag([ sign(randn(1))*1/10; sign(randn(1))*1/10; sign(randn(1))*1/10]); % random sign, let it be 0.1 

% post-calibration bias
b_m = [sign(randn(1))*1 ; sign(randn(1))*1; sign(randn(1))*1]* 1e-6 * 1; % random sign, let it be 1 uT

% output noise
sigma_m = 0.6 * 1e-6 * 1;

% ACCELEROMETER

% zero-g initial calibration tolerance (bias)
b_a = [sign(randn(1))*0.06; sign(randn(1))*0.06; sign(randn(1))*0.08];

% cross axis sensitivity
mis_a = [0 sign(randn(1))*0.002 sign(randn(1))*0.002; 
         sign(randn(1))*0.002 0 sign(randn(1))*0.002; 
         sign(randn(1))*0.002 sign(randn(1))*0.002 0] * 1;

% sensitivity initial tolerance
m_a = diag([sign(randn(1))*0.03; sign(randn(1))*0.03; sign(randn(1))*0.03]) * 1;

% output noise 
Density_a = 300 * 1e-6; % noise power spectral density
BW = 218.1; % bandwidth
sigma_a = Density_a *sqrt(BW) * 1; 

acc_parameters  = struct('b_a', b_a, 'mis_a', mis_a, 'm_a', m_a, 'sigma_a', sigma_a);
magn_parameters = struct('b_m', b_m, 'mis_m', mis_m, 'm_m', m_m, 'sigma_m', sigma_m);

end