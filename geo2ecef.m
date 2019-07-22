function res=geo2ecef(sv)
%% LBh/ENU TO ECEF X,Y,Z conversion
% input: [L;B;h; Ve;Vn;Vu; Ae;An;Au];
% output: [X;Y;Z; Vx;Vy;Vz; Ax;Ay;Az];
% 
    phi = sv(2); 
	lambda = sv(1); 
	h = sv(3); 
 
	a = 6378137.0000;	% earth semimajor axis in meters 
	b = 6356752.314;	% earth semiminor axis in meters	 
	%e = sqrt (1-(b/a).^2); 
    CONST_FLAT_E       = 1.0/298.257223563; % Earth flattening constant
    e2 = (2- CONST_FLAT_E)* CONST_FLAT_E;
 
	sinphi = sin(phi); 
	cosphi = cos(phi); 
	coslam = cos(lambda); 
	sinlam = sin(lambda); 
	tan2phi = (tan(phi))^2; 
	tmp = 1 - e2; 
	tmpden = sqrt( 1 + tmp*tan2phi ); 
 
	x = (a*coslam)/tmpden + h*coslam*cosphi; 
	y = (a*sinlam)/tmpden + h*sinlam*cosphi; 
	tmp2 = sqrt(1 - e2*sinphi*sinphi); 
	z = (a*tmp*sinphi)/tmp2 + h*sinphi; 
 %%%%%%%%%%%%%%%%%%%%%%%%%

sL = sin(sv(1));
cL = cos(sv(1));
sB = sin(sv(2));
cB = cos(sv(2));
Cg2e=[-sL  -sB*cL  cL*cB;
       cL  -sB*sL  cB*sL;
       0   cB      sB];

V=Cg2e*sv(4:6);
A=Cg2e*sv(7:9);
res=[x;
     y;
     z;
     V;
     A];
