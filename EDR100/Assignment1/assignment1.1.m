%   *-Variables-* 

% %Slope angle
% alpha = library.alpha;
% 
% %Vehicle speed (km/h)
% vkm = library.v;
% 
% %Acceleration of vehicle
% a = library.a;



%   *-Constants-*
   
%   Wheel radius
Wr = 0.3240;

%   Mass vehicle
m = 1700;

%   Gravitational acceleration
g = 9.81;

%   Tire friction constant
Cr = 0.009;

%   Air density
Pa = 1.225;

%   Vehicle frontal Area
Af = 3.0436;

%   Drag coefficiant
Cd = 0.2800;


%   *-Misc-*

%   Wheel rotaion speed (rad/s)
%Ww = v / Wr



%   *-Equations-*

%   Convertion from kmh to ms
v = (vkm * 1000) / 3600;

%   Aerodynamic resistance
Fa = 0.5 * Pa * Af * Cd * ((vkm * 1000) / 3600).^2;

%   Rolling friction
Fr = Cr * m * g * cos(alpha);

%   Slope resistance
Fg = g * m * sin(alpha);

%   Acceleration force
Facc = (m * a);

%   Tracktion force
Ft = Facc + (Fa + Fr + Fg)

%   Tourque Wheel
Tw = Ft * Wr

%   Requierd traction power
Pt = Ft .* ((vkm * 1000) / 3600)

save library.mat vkm a alpha Ft Tw Pt
% M = load('library.mat')
% csvwrite('Assignment1.1.csv', M)
