function RPY_new = angle_calc(ya_rpy)
%RPY_n = zeros();
 % ?àñ÷¸ò óãëîâ ïî èçìå?åíèÿì àêñåëå?îìåò?îâ ñ ïîã?åøíîñòÿìè
  RPY_new(1) = atan2(- (ya_rpy(2)), - (ya_rpy(3)));
  RPY_new(2) = atan2(ya_rpy(1), sqrt(((ya_rpy(2)^2)+(ya_rpy(3))^2)));

  RPY_new(3) = 0;
end