function g=gravity2(x_geo)

%% ECEF X,Y,Z TO LBh/ENU  conversion
%% (see geo2ecef code)
CONST_R_E          = 6378137;               % Earth's semimajor axis, m 
CONST_B_E          = 6356752.314;           % Earth's semiminor axis, m 
CONST_FLAT_E       = 1.0/298.257223563; % Earth flattening constant
go=9.78049; % м/с2
betta=0.005317;
alpha=0.000007;

e2 = (2- CONST_FLAT_E)* CONST_FLAT_E;
p2= x_geo(1).^2 + x_geo(2).^2;
p = sqrt(p2);
L = atan2( x_geo(2), x_geo(1));

% interation on Lat and Height 
B   = atan2( x_geo(3)./p, 0.01 );
r_N = CONST_R_E / sqrt( 1- e2* sin(B).^2);

h = p./cos(B) - r_N;

% iteration 
old_H  = -1e-9;
num    = x_geo(3)./p;

while abs(h - old_H) > 1e-4
	  old_H  = h;
	  den    =  1- e2 * r_N./(r_N+h);
	  B   = atan2(num,den);

	  r_N    = CONST_R_E./ sqrt(1- e2* sin(B).^2);
	  h      = p./cos(B)- r_N;
      %fprintf('%f  \r',old_H);
end


ae = CONST_R_E;
sinB = sin(B); % синус широты
sin2B = sin(2*B); % синус 2*широты
 
G = go*ae*ae/(ae+h)/(ae+h)*(1.+ betta*sinB*sinB + alpha*sin2B*sin2B); % м/с2

grav = [0;0;-G];

sL = sin(L);
cL = cos(L);
sB = sin(B);
cB = cos(B);
Cg2e=[-sL  -sB*cL  cL*cB;
       cL  -sB*sL  cB*sL;
       0   cB      sB];   
g=Cg2e*grav;
return
