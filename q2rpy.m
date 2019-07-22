function RPY = q2rpy(Q) % quaternion to euler angles conversion  (c)wikipedia
 RPY=zeros(3,1);
 RPY(1) = atan2( 2.0*(Q(1)*Q(2)+Q(3)*Q(4)), (1.0-2.0*(Q(2)*Q(2)+Q(3)*Q(3)) ) );
 RPY(2) = asin( 2.0*(Q(1)*Q(3)-Q(2)*Q(4))  );
 RPY(3) = atan2( 2.0*(Q(1)*Q(4)+Q(2)*Q(3)), (1.0-2.0*(Q(3)*Q(3)+Q(4)*Q(4)) ) );
  