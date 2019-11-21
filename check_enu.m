% % y - positive around yaw axis (screw-positive)
% % check
% rpy = [0; 0; pi/2]
% rpy2enu = rpy2mat(rpy);
% R_rpy = [1;0;0];
% R_enu = rpy2enu*R_rpy
% P_rpy = [0;1;0];
% P_enu = rpy2enu*P_rpy
% Y_rpy = [0;0;1];
% Y_enu = rpy2enu*Y_rpy

% % p - positive around pitch axis (screw-positive)
% % check
% rpy = [0; pi/2; 0]
% rpy2enu = rpy2mat(rpy);
% R_rpy = [1;0;0];
% R_enu = rpy2enu*R_rpy
% P_rpy = [0;1;0];
% P_enu = rpy2enu*P_rpy
% Y_rpy = [0;0;1];
% Y_enu = rpy2enu*Y_rpy

% % yp - positive around yaw and pitch axis (screw-positive)
% % check
% rpy = [0; pi/2; pi/2]
% rpy2enu = rpy2mat(rpy);
% R_rpy = [1;0;0];
% R_enu = rpy2enu*R_rpy
% P_rpy = [0;1;0];
% P_enu = rpy2enu*P_rpy
% Y_rpy = [0;0;1];
% Y_enu = rpy2enu*Y_rpy

% ypr - positive around yaw and pitch axis, negative around roll axis (screw-positive)
% check
rpy = [-pi/2; pi/2; pi/2]
rpy2enu = rpy2mat(rpy);
R_rpy = [1;0;0];
R_enu = rpy2enu*R_rpy
P_rpy = [0;1;0];
P_enu = rpy2enu*P_rpy
Y_rpy = [0;0;1];
Y_enu = rpy2enu*Y_rpy

% checked!