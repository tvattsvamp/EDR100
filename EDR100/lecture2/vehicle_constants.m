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
Af = 2.3;

%   Drag coefficiant
Cd = 0.2800;


%   *-Misc-*
t = round(linspace(0,1801,1800));

%   Wheel rotaion speed (rad/s)
%Ww = v / Wr

save 'vihicle_constants.mat' m g Cr Pa Af Cd Wr t