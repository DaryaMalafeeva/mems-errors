function ya_rpy = acc_meas(A_rpy, acc_parameters)

  ya_rpy = (eye(3,3) + acc_parameters.m_a + acc_parameters.mis_a)* A_rpy(1:3,1) + acc_parameters.b_a + acc_parameters.sigma_a * randn(3,1);
  
end