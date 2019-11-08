function ym_rpy = m_meas(M_rpy,magn_parameters)
 ym_rpy = (eye(3,3) + magn_parameters.m_m + magn_parameters.mis_m) * M_rpy(1:3,1) + magn_parameters.b_m  + magn_parameters.sigma_m*randn(3,1);
end

