function res=ecef2geo(sv)
%% ECEF X,Y,Z TO LBh/ENU  conversion
% input: [X;Y;Z; Vx;Vy;Vz; Ax;Ay;Az];
% output:  [L;B;h; Ve;Vn;Vu; Ae;An;Au];
% 
CONST_R_E          = 6378137;               % Earth's semimajor axis, m 
CONST_B_E          = 6356752.314;           % Earth's semiminor axis, m 
CONST_FLAT_E       = 1.0/298.257223563; % Earth flattening constant

e2 = (2- CONST_FLAT_E)* CONST_FLAT_E;
p2= sv(1).^2 + sv(2).^2;
p = sqrt(p2);
L = atan2( sv(2), sv(1));

% interation on Lat and Height 
B   = atan2( sv(3)./p, 0.01 );
r_N = CONST_R_E / sqrt( 1- e2* sin(B).^2);

h = p./cos(B) - r_N;

% iteration 
old_H  = -1e-9;
num    = sv(3)./p;

while abs(h - old_H) > 1e-4
	  old_H  = h;
	  den    =  1- e2 * r_N./(r_N+h);
	  B   = atan2(num,den);

	  r_N    = CONST_R_E./ sqrt(1- e2* sin(B).^2);
	  h      = p./cos(B)- r_N;
      %fprintf('%f  \r',old_H);
end


sL = sin(L);
cL = cos(L);
sB = sin(B);
cB = cos(B);
Cg2e=[-sL  -sB*cL  cL*cB;
       cL  -sB*sL  cB*sL;
       0   cB      sB];
   
V=Cg2e'*sv(4:6);
A=Cg2e'*sv(7:9);
res=[L;
     B;
     h;
     V;
     A];
