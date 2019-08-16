function ym_rpy = m_meas(M_rpy,magn_parameters)
 ym_rpy = magn_parameters.s_m * M_rpy(1:3,1) + magn_parameters.b_m  + magn_parameters.sigma_m*randn(3,1);
end