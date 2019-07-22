function dCdQk = inc(q_ecef_rpy, A_rpy)
  

    dCdq1 = 2* [ q_ecef_rpy(1) -q_ecef_rpy(4) q_ecef_rpy(3);
        q_ecef_rpy(4) q_ecef_rpy(1) -q_ecef_rpy(2);
        -q_ecef_rpy(3) q_ecef_rpy(2) q_ecef_rpy(1)] * A_rpy;
    
    dCdq2 = 2* [ q_ecef_rpy(2) q_ecef_rpy(3) q_ecef_rpy(4);
       q_ecef_rpy(3) -q_ecef_rpy(2) -q_ecef_rpy(1);
        -q_ecef_rpy(4) q_ecef_rpy(1) -q_ecef_rpy(2)] * A_rpy;
    
    dCdq3 = 2* [ -q_ecef_rpy(3) q_ecef_rpy(2) q_ecef_rpy(1);
        q_ecef_rpy(2) q_ecef_rpy(3) q_ecef_rpy(4);
        -q_ecef_rpy(1) q_ecef_rpy(4) q_ecef_rpy(3)] * A_rpy;
    
    dCdq4 = 2* [ -q_ecef_rpy(4) -q_ecef_rpy(1) q_ecef_rpy(2);
        q_ecef_rpy(1) -q_ecef_rpy(4) q_ecef_rpy(3);
        q_ecef_rpy(2) q_ecef_rpy(3) q_ecef_rpy(4)] * A_rpy;
    
    dCdQk = [ dCdq1 dCdq2 dCdq3 dCdq4];
end