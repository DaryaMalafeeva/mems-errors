function C = rpy2mat(RPY) % euler angles to quaternion conversion  
 C = zeros(3,3);
 sr = sin(RPY(1)); cr = cos(RPY(1));
 sp = sin(RPY(2)); cp = cos(RPY(2));
 sy = sin(RPY(3)); cy = cos(RPY(3));
 
 C = [cy*cp -cr*sy+sr*cy*sp   sr*sy+cr*cy*sp;
      sy*cp  cr*cy+sr*sy*sp  -sr*cy+cr*sy*sp;
      -sp      sr*cp           cr*cp];

