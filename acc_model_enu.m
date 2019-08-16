clear all
close all
clc
N = 2000; % number of points

% memory allocation
C_rpy_ned = zeros(3,3);
ya_rpy = zeros(3,N);
RPY_new = zeros(N,3);
err_RPY = zeros(N,3);
M_rpy = zeros(3,N);
A_rpy = zeros(3,N);
ym_rpy = zeros(3,N);
ym_rp0 = zeros();
Azimuth_magn = zeros(1,N);
err_Azimuth = zeros(1,N);
Azimuth = zeros(1,N);
ym_enu = zeros(3,N);

% true roll, pitch, yaw angles
R = (rand(N,1)*2*pi - pi)* 165/180; % random limited angles 
%R = ones(N,1)*deg2rad(180);        % constant angles
%R = zeros(N,1);                    % zero angles

P = (rand(N,1)*pi - pi/2)* 75/90; 
%P = ones(N,1)*deg2rad(90);
%P = zeros(N,1);

Y = (rand(N,1)*2*pi - pi)* 165/180; 
%Y = ones(N,1)*deg2rad(180);
%Y = zeros(N,1);

RPY = [R P Y]; % angles matrix
M_enu = [0; 11; -8] * 1e-6 * 1; % vector of the true value of the magnetic field 

% imu parameters from its datasheet 
s_m = eye(3,3)+ diag([ 1/10; 1/10; 1/10]) * 1;
b_m = [1 ; 1; 1]* 1e-6 * 1;
sigma_m = 0.6 * 1e-6 * 1;
b_a = [0.06; -0.06; 0.08] * 1;
mis_a = [0 -0.02 0.02;
         -0.02 0 0.02;
         0.02 -0.02 0] * 1;
m_a = diag([-0.03; 0.03; -0.03]) * 1;
Density = 300 * 1e-6;
BW = 218.1;
sigma = Density*sqrt(BW) * 1;

acc_parameters  = struct('b_a', b_a, 'mis_a', mis_a, 'm_a', m_a, 'sigma', sigma);
magn_parameters = struct('s_m', s_m, 'b_m', b_m, 'sigma_m', sigma_m);

% calculations
for i = 1:N
  %C_rpy_enu(1:3,1:3) = rpy2mat(RPY(i,1:3)');
  Quat_rpy_enu = rpy2q(RPY(i,1:3)'); % true angles to quaternion convertion
  C_rpy_enu(1:3,1:3) = q2mat(Quat_rpy_enu); % quaternion to matrix convertion
  
  A_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' *[0; 0; -1]; % true acceleration vector
  M_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' * M_enu;     % true magnetic field vector
  
  Azimuth(i) = Y(i);                              % true azimuth angle
   
  ya_rpy(1:3,i)= acc_meas(A_rpy(1:3,i), acc_parameters); % accelerometer error model application 
  ym_rpy(1:3,i) = m_meas(M_rpy(1:3,i), magn_parameters); % magnetometer error model application 
  
  %RPY_new1 = angle_calc(A_rpy(1:3,i)); % angles calculating by true accelaration vector 
  RPY_new1 = angle_calc(ya_rpy(1:3,i)); % angles calculating by accelerometer measurements 
  RPY_new(i,1:3)= RPY_new1;
  
  % debug
  % RPY_new1 = RPY(i,1:3);
  % RPY_new(i,1:3)= RPY(i,1:3);

  %C_rpy_enu(1:3,1:3) = rpy2mat([R(i); P(i); 0]);
  %C_rpy_enu(1:3,1:3) = rpy2mat([RPY_new1(1:2)'; 0]);
  
  Quat_rpy_enu_new = rpy2q([RPY_new1(1:2)'; 0]); % measured angles to quaternion convertion
  C_rpy_enu_new(1:3,1:3) = q2mat(Quat_rpy_enu_new); 
  
  ym_enu(1:3,i) = C_rpy_enu_new(1:3,1:3) * ym_rpy(1:3,i); % magnetometer measurements convertion from OCS to LCS
  %ym_enu(1:3,i) = C_rpy_enu_new(1:3,1:3) * M_rpy(1:3,i);
  Azimuth_magn(i) = atan2(ym_enu(1,i),ym_enu(2,i)); % azimuth angle calculation
 
  err_RPY(i,1:3) = RPY(i,1:3) - RPY_new(i,1:3); % angles errors calculation
  err_Azimuth(i) = Azimuth_magn(i) -  Azimuth(i); 
  
  % angles correction 
  if err_RPY(i,1) > pi
    err_RPY(i,1) = 2*pi - err_RPY(i,1);
  elseif err_RPY(i,1) < -pi
    err_RPY(i,1) = 2*pi + err_RPY(i,1);
  end
  if err_Azimuth(i) > pi
    err_Azimuth(i) = 2*pi - err_Azimuth(i);
  elseif err_Azimuth(i) < -pi
    err_Azimuth(i) = 2*pi + err_Azimuth(i);
  end
end

% rad2deg
err_PPY_deg = err_RPY*180/pi;
err_Azimuth_deg = err_Azimuth*180/pi;

% plotting

% roll error vs roll & pitch
figure
plot3(R*180/pi, P*180/pi, err_PPY_deg(:,1), '.')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:30:90));
title('roll error vs roll & pitch')
grid on
xlabel('roll, deg')
ylabel('pitch, deg')
zlabel('roll error, deg')
grid on

% pitch error vs roll & pitch
figure
plot3(R*180/pi, P*180/pi, err_PPY_deg(:,2), '.')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:90:90));
title('pitch error vs roll & pitch')
xlabel('roll, deg')
ylabel('pitch, deg')
zlabel('pitch error, deg')
grid on

% to plot the following dependencies correctly you must set one of the
% angles by zeros 

% azimuth error vs roll & pitch
figure
plot3(R*180/pi, P*180/pi, err_Azimuth_deg, '.')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:30:90));
title('azimuth error vs roll & pitch ')
xlabel('roll, deg')
ylabel('pitch, deg')
zlabel('azimuth error, deg')
grid on

% azimuth error vs roll & azimuth
figure
plot3(R*180/pi, Y*180/pi, err_Azimuth_deg, '.')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-180:90:180));
title('azimuth error vs roll & azimuth ')
xlabel('roll, deg')
ylabel('azimuth, deg')
zlabel('azimuth error, deg')
grid on

% azimuth error vs pitch & azimuth
figure
plot3(P*180/pi, Y*180/pi, err_Azimuth_deg, '.')
ax = gca;
set(ax,'xtick',(-90:30:90));
set(ax,'ytick',(-180:90:180));
title('azimuth error vs pitch & azimuth')
xlabel('pitch, deg')
ylabel('azimuth, deg')
zlabel('azimuth error')
grid on

