function ya_rpy = acc_meas(A_rpy, m_a, mis_a, ba, sigma_acc)

  ya_rpy = (eye(3,3) + m_a + mis_a)* A_rpy(1:3,1) + ba + sigma_acc*randn(3,1);
  
end