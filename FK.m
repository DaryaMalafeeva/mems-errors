clear all
clc

Tmod = 5;
T_imu = 1/10^3;
T = 1/10;
M = Tmod/T_imu;

%sigma_v = 0.1;
sigma_v = 0.001;
sigma_a = 0.001;

sigma_v_form = 1e-4;
sigma_q_form = 1e-4;
sigma_ba_form = 1e-4;

% sigma_v_form = 0;
% sigma_q_form = 0;
 sigma_ba_form = 0;

%% filter initialization

ba_est = [0; 0; 0];

V_ecef_est = [0; 0; 0];

q_ecef_rpy_est = [1; 0; 0; 0];

D_x = diag([(1)^2 * [1; 1; 1]; (0.1)^2 * [1; 1; 1; 1] ; 0* (0.1)^2 * [1; 1; 1] ]);

x = [ V_ecef_est; q_ecef_rpy_est; ba_est];

% matrix
G = diag([(sigma_v_form)^2 * [1; 1; 1]; (sigma_q_form)^2 * [1; 1; 1; 1] ; (sigma_ba_form)^2 * [1; 1; 1] ]);

H = [eye(3,3) zeros(3,7)];

% gravity vecor calculation
  
x_blh = [ deg2rad(55.7550); deg2rad(37.7082); 200];

x_lbh = [ x_blh(2); x_blh(1); x_blh(3)];

tmp = geo2ecef([x_lbh; zeros(6,1)]);

x_ecef(1:3,1) = tmp(1:3);

g_ecef = gravity2(x_ecef);

RPY(1:3,1) = deg2rad([20*1;30*1;40*0]);
kk=0;
 x_save(1:length(x),1:M) = 0;
 res(1:3,1:M/100) = 0;
for k = 2:M
    
    q_ecef_rpy_true = rpy2q(RPY(1:3,1));
    
    C_ecef_rpy_true(1:3,1:3) = q2mat(q_ecef_rpy_true);
    
    A_rpy = -C_ecef_rpy_true' * g_ecef;
    
    n_a = randn(3,1)* sigma_a;
    
    y_a = A_rpy + 0*[0.1; 0.05; -0.01] + n_a;

    %% extrapolation
   
    ba = x(8:10);
    
    V_ecef = x(1:3);
    
    q_ecef_rpy = x(4:7);
    
    C_ecef_rpy = q2mat(q_ecef_rpy);
    
    A_rpy_extr = y_a - ba;
    
    dCdQk = inc(q_ecef_rpy, A_rpy_extr);
    
    F = [ (eye(3,3)) (T_imu * dCdQk) (-T_imu * C_ecef_rpy);
        (zeros(4,3)) (eye(4,4)) (zeros(4,3));
        (zeros(3,3)) (zeros(3,4)) (eye(3,3))]; 
    
    v_ecef(1:3,1) = V_ecef + g_ecef * T_imu...
        + T_imu * C_ecef_rpy * A_rpy_extr;    
   
    D_x = F * D_x * F' + G;
    
    x = [v_ecef; q_ecef_rpy; ba]; 
    
    if (mod(k, T/T_imu) == 0)
        kk = kk+1;
        %% correction
        R_v = diag([sigma_v; sigma_v; sigma_v]).^2;
        
        n_v = randn(3,1)* sigma_v;
        
        y_srns = [0;0;0] + n_v;
        
        K = (D_x * H' * inv(H * D_x * H' + R_v));
        
        D_x = (eye(10,10) - K * H) * D_x;
      
        x = x + K * (y_srns - x(1:3)); 
        
        res(1:3,kk)=y_srns - x(1:3);
    end
     x_save(1:length(x),k) = x;
     v_ecef_save =  x_save(1,1:k);
     
end

RPY_est(1:3,1:k) = nan;
for kkk = 1:k
    RPY_est(1:3,kkk) = rad2deg(q2rpy(x_save(4:7,kkk)));
end
RPY_err = rad2deg(RPY(1:3,1))-RPY_est(1:3,end)
% попробовать убрать шум приемника
