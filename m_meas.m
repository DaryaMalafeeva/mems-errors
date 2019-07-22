function ym_rpy = m_meas(M_rpy, Sm, bm, sigma1)

 ym_rpy = Sm * M_rpy(1:3,1) + bm  + sigma1*randn(3,1);
end