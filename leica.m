clear all; close all; clc;

N = 10;

R = (rand(N,1)*2*pi - pi);
P = (rand(N,1)*pi - pi/2);
Y = (rand(N,1)*2*pi - pi);

RPY = [ R P Y];

L_rpy = [ rand(N,1) rand(N,1) rand(N,1)]';

X1_ecef = randn(N,1);
Y1_ecef = randn(N,1);
Z1_ecef = randn(N,1);

XYZ_1 = [ X1_ecef Y1_ecef Z1_ecef]';

for i = 1:N
C_rpy_ecef = rpy2mat(RPY(i,1:3)');

XYZ_2 = XYZ_1 - C_rpy_ecef * L_rpy;

% теперь рассчитаем угол наклона
TILT(i) = asin(sin(R(i)) * sin(P(i)));

% видимо надо добавить расчет азимута?
% AZIMUTH(i) = 

% зададим точность оценки углов ( 3d attitude error)
attitude_error = (1.014 + 1.498)/ 2; % два теста - я взяла среднее

end
% теперь надо для разных углов крена рассчитывать из этих углов координаты
% for j = 1: length(R)
%     X_new(j) = L * sin(AZIMUTH(j) * sin(TILT(j));
%     Y_new(j) = L * sin(AZIMUTH(j) * cos(TILT(j));
%     Z_new(j) = L * cos(AZIMUTH(j));
% end
%     

