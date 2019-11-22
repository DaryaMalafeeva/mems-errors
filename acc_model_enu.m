clear all; close all; clc

% number of points
N = 2000; 

% memory allocation
C_rpy_ned = zeros(3,3);
ya_rpy = zeros(3,N);
RPY_new = zeros(N,3);
err_RPY = zeros(N,3);
M_rpy = zeros(3,N);
A_rpy = zeros(3,N);
ym_rpy = zeros(3,N);
Azimuth_magn = zeros(1,N);
err_Azimuth = zeros(1,N);
Azimuth = zeros(1,N);
ym_enu = zeros(3,N);

% true roll, pitch, yaw angles
% random limited angles 
R = (rand(N,1)*2*pi - pi)* 165/180;
P = (rand(N,1)*pi - pi/2)* 75/90; 
Y = (rand(N,1)*2*pi - pi)* 165/180; 

% constant angles
%R = ones(N,1)*deg2rad(180);  
%P = ones(N,1)*deg2rad(90);
%Y = ones(N,1)*deg2rad(180);

% zero angles
%R = zeros(N,1);                    
%P = zeros(N,1);
% Y = zeros(N,1);

% angles matrix
RPY = [R P Y];            

% true magnetic induction vector
M_enu = [0; 11; -8] * 1e-6 * 1;  % uT
A_enu = [0; 0; -1];  % g

%--------------------------------Choose IMU--------------------------------

[acc_parameters, magn_parameters, imu_name] = get_MPU9250A_parameters();
%[acc_parameters, magn_parameters, imu_name] = get_ADIS16488A_parameters();
%--------------------------------------------------------------------------

% calculations
for i = 1:N
  % true angles to quaternion convertion
  Quat_rpy_enu = rpy2q(RPY(i,1:3)');        
  
  % quaternion to matrix convertion
  C_rpy_enu(1:3,1:3) = q2mat(Quat_rpy_enu);               
  
  % true acceleration vector
  A_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' * A_enu; 
  
  % true magnetic field vector
  M_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' * M_enu; 
  
  % true magnetic azimuth angle
  Azimuth(i) = Y(i);                                      
  
  % accelerometer error model application 
  ya_rpy(1:3,i)= acc_meas(A_rpy(1:3,i), acc_parameters); 
  
  % magnetometer error model application 
  ym_rpy(1:3,i) = m_meas(M_rpy(1:3,i), magn_parameters); 
  
  % angles calculating by true accelaration vector 
  %RPY_new1 = angle_calc(A_rpy(1:3,i));  
  
  % angles calculating by accelerometer measurements
  RPY_new = angle_calc(ya_rpy(1:3,i));                    
  RPY_new(i,1:3)= RPY_new; 
  
  % debug
  % RPY_new1 = RPY(0000FFi,1:3);
  %RPY_new(i,1:3)= RPY(i,1:3);

  %C_rpy_enu(1:3,1:3) = rpy2mat([R(i); P(i); 0]);
  %C_rpy_enu(1:3,1:3) = rpy2mat([RPY_new1(1:2)'; 0]);
  
% % % legacy  
% % %   % measured angles to quaternion convertion
% % %   Quat_rpy_enu_new = rpy2q([RPY_new1(1:2)'; 0]);   
% % %   % q2m convertion 
% % %   C_rpy_enu_new(1:3,1:3) = q2mat(Quat_rpy_enu_new); 
% % %   
  C_rpy_enu_new(1:3,1:3) = rpy2mat([RPY_new(1:2)'; 0]); % magn to horizontal plane
  
  % magnetometer measurements convertion from body frame coordinates to horizontal
  ym_enu(1:3,i) = C_rpy_enu_new(1:3,1:3) * ym_rpy(1:3,i); 
  %ym_enu(1:3,i) = C_rpy_enu_new(1:3,1:3) * M_rpy(1:3,i);
  
  % azimuth angle calculation
  Azimuth_magn(i) = atan2(ym_enu(1,i),ym_enu(2,i));       
 
  % angles errors calculation
  err_RPY(i,1:3) = RPY(i,1:3) - RPY_new(i,1:3);           
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
title(['roll error vs roll & pitch for ' imu_name])
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
title(['pitch error vs roll & pitch for ' imu_name])
xlabel('roll, deg')
ylabel('pitch, deg')
zlabel('pitch error, deg')
grid on

% to plot the following dependencies correctly you must set one of the
% angles by zeros 

% % azimuth error vs roll & pitch
% figure
% plot3(R*180/pi, P*180/pi, err_Azimuth_deg, '.')
% ax = gca;
% set(ax,'xtick',(-180:90:180));
% set(ax,'ytick',(-90:30:90));
% title('azimuth error vs roll & pitch ')
% xlabel('roll, deg')
% ylabel('pitch, deg')
% zlabel('azimuth error, deg')
% grid on
% 
% % azimuth error vs roll & azimuth
% figure
% plot3(R*180/pi, Y*180/pi, err_Azimuth_deg, '.')
% ax = gca;
% set(ax,'xtick',(-180:90:180));
% set(ax,'ytick',(-180:90:180));
% title('azimuth error vs roll & azimuth ')
% xlabel('roll, deg')
% ylabel('azimuth, deg')
% zlabel('azimuth error, deg')
% grid on
% 
% % azimuth error vs pitch & azimuth
% figure
% plot3(P*180/pi, Y*180/pi, err_Azimuth_deg, '.')
% ax = gca;
% set(ax,'xtick',(-90:30:90));
% set(ax,'ytick',(-180:90:180));
% title('azimuth error vs pitch & azimuth')
% xlabel('pitch, deg')
% ylabel('azimuth, deg')
% zlabel('azimuth error')
% grid on
% 
