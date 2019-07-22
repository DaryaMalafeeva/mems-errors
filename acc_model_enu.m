clear all
close all
clc
N = 1000;
%��������� ������ ������
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

% ������������ ��������� �����
%R = (rand(N,1)*2*pi - pi)* 17/18;
%R = ones(N,1)*deg2rad(180);
R = zeros(N,1);

%P = (rand(N,1)*pi - pi/2);
%P = (rand(N,1)*pi - pi/2)* 8/9;
P = ones(N,1)*deg2rad(90);
%P = zeros(N,1);

%Y = (rand(N,1)*2*pi - pi);
Y = zeros(N,1);
%Y = (rand(N,1)*2*pi - pi)* 17/18;
%Y = ones(N,1)*deg2rad(0);

RPY = [R P Y];

% ������������ ���������� ���������� ������
M_enu = [0; 11; -8]*1e-6 * 1;
%��������� ������ ��������� ������������
Sm = eye(3,3)+ diag([ 1/10; 1/10; 1/10])*1;
bm = [1 ; 1; 1]* 1e-6 *1;
sigma_m = 0.6 * 1e-6 *1;
%��������� ������ ��������� �������������
ba = [0.06; -0.06; 0.08] *1;
mis_a = [0 -0.02 0.02;
        -0.02 0 0.02;
        0.02 -0.02 0] *1;
m_a = diag([-0.03; 0.03; -0.03]) *1;
Density = 300*1e-6;
BW = 218.1;
sigma = Density*sqrt(BW)*1;
for i = 1:N
  % ������������ ������� �������������� ��������� ��� ��������� �����
  %C_rpy_enu(1:3,1:3) = rpy2mat(RPY(i,1:3)');
  Quat_rpy_enu = rpy2q(RPY(i,1:3)');
  C_rpy_enu(1:3,1:3) = q2mat(Quat_rpy_enu);
  
  % ������������ �������� �������� Aenu = 0;0;-1 
  A_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' *[0;
    0;
    -1];
  M_rpy(1:3,i) = C_rpy_enu(1:3,1:3)' * M_enu;
  
  Azimuth(i) = Y(i);
  
  % ���������� ������ ��������� ��������������
  % ��� ��������� ��������� �������������� � �������������  
   ya_rpy(1:3,i)= acc_meas(A_rpy(1:3,i),m_a, mis_a, ba, sigma);  
   
   % ���������� ������ ��������� �������������
   % ��� ��������� ��������� ������������� � �������������  
   ym_rpy(1:3,i) = m_meas(M_rpy(1:3,i), Sm, bm, sigma_m);
  
  % ������ ����� �� ���������� �������������� � �������������
  %RPY_new1 = angle_calc_enu(A_rpy(1:3,i));
  RPY_new1 = angle_calc(ya_rpy(1:3,i));
  RPY_new(i,1:3)= RPY_new1;
  
    % debug
%    RPY_new1 = RPY(i,1:3);
%    RPY_new(i,1:3)= RPY(i,1:3);
  
  % ������ ���������� ������� �� ���������� ������������
  %C_rpy_enu(1:3,1:3) = rpy2mat([R(i); P(i); 0]);
  %C_rpy_enu(1:3,1:3) = rpy2mat([RPY_new1(1:2)'; 0]);
  
  Quat_rpy_enu = rpy2q([RPY_new1(1:2)'; 0]);
  C_rpy_enu(1:3,1:3) = q2mat(Quat_rpy_enu);
  
  ym_enu(1:3,i) = C_rpy_enu(1:3,1:3) * ym_rpy(1:3,i);
  %ym_enu(1:3,i) = C_rpy_enu(1:3,1:3) * M_rpy(1:3,i);
  Azimuth_magn(i) = atan2(ym_enu(1,i),ym_enu(2,i));
  
   % ���������� ������ ��������� ����� RPY � �������
  err_RPY(i,1:3) = RPY(i,1:3) - RPY_new(i,1:3);
  err_Azimuth(i) = Azimuth_magn(i) -  Azimuth(i);
  
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

% ������ ������ ���������� ����� � ��������
 err_PPY_deg = err_RPY*180/pi;
 err_Azimuth_deg = err_Azimuth*180/pi;

%������� ������������ �������������� �� ������ ����� R,P
figure
plot3(R*180/pi, P*180/pi, err_PPY_deg(:,1), '.k')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:30:90));
title('������ ������ ���� �����')
grid on
xlabel('����, ����')
ylabel('������, ����')
zlabel('������ �����, ����')
grid on
% 
figure
plot3(R*180/pi, P*180/pi, err_PPY_deg(:,2), '.k')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:90:90));
title('������ ������ ���� �������')
xlabel('����, ����')
ylabel('������, ����')
zlabel('������ �������, ����')
grid on

%������� ������������ ������������ �� ������ ���� Y
figure
plot3(R*180/pi, P*180/pi, err_Azimuth_deg, '.k')
ax = gca;
set(ax,'xtick',(-180:90:180));
set(ax,'ytick',(-90:30:90));
title('������ ������ ������� ')
xlabel('����, ����')
ylabel('������, ����')
zlabel('������ �������, ����')
grid on

% figure
% plot3(R*180/pi, Y*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% set(ax,'xtick',(-180:90:180));
% set(ax,'ytick',(-180:90:180));
% title('������ ������ ������� ')
% xlabel('����, ����')
% ylabel('������, ����')
% zlabel('������ �������, ����')
% grid on
% 
% figure
% plot3(P*180/pi, Y*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% set(ax,'xtick',(-90:30:90));
% set(ax,'ytick',(-180:90:180));
% title('������ ������ ������� ')
% xlabel('������, ����')
% ylabel('������, ����')
% zlabel('������ �������, ����')
% grid on

%������� ������������ ������������� � ������������ �� ������ ���� Y
% figure
% plot3(R*180/pi, P*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% set(ax,'xtick',(-180:90:180));
% set(ax,'ytick',(-90:30:90));
% title('������ ������ ������� ')
% xlabel('����, ����')
% ylabel('������, ����')
% zlabel('������ �������, ����')
% grid on

% figure
% plot3(R*180/pi, Y*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% set(ax,'xtick',(-180:90:180));
% set(ax,'ytick',(-180:90:180));
% title('������ ������ ������� ')
% xlabel('����, ����')
% ylabel('������, ����')
% zlabel('������ �������, ����')
% grid on

% figure
% plot3(P*180/pi, Y*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% set(ax,'xtick',(-90:30:90));
% set(ax,'ytick',(-180:90:180));
% title('������ ������ ������� ')
% xlabel('������, ����')
% ylabel('������, ����')
% zlabel('������ �������, ����')
% grid on


% figure
% plot(Y*180/pi, err_Azimuth_deg, '.k')
% ax = gca;
% title('������ ������ ������� ')
% xlabel('������, ����')
% ylabel('������ �������, ����')
% grid on