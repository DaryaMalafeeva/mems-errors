function Q = rpy2q(RPY) % euler angles to quaternion conversion  
 Q = zeros(4,1);
 sr = sin(0.5*RPY(1)); cr = cos(0.5*RPY(1));
 sp = sin(0.5*RPY(2)); cp = cos(0.5*RPY(2));
 sy = sin(0.5*RPY(3)); cy = cos(0.5*RPY(3));
 
 Q(1) = cr*cp*cy + sr*sp*sy;
 Q(2) = sr*cp*cy - cr*sp*sy;
 Q(3) = cr*sp*cy + sr*cp*sy;
 Q(4) = cr*cp*sy - sr*sp*cy;
 
 