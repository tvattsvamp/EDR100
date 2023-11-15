% Solutions to Assignment 1, EDR100 HT2022
% Stefan Skoog
% Based on a unicuycle model of the car
% Each calculation of forces on the unicycle is put into a Matlab function
% (sub-routine) at the end of this file.

% Clear consol window
clc

% Clear workspace variables
clear all

%% Define environmental parameters
% Let Matlab know that these variables can be used in sub-routines within this M-file and this workspace
global rho Af cd cr mv g wr    

rho = 1.225;    % (kg/m^3)
Af  = 2.3;       % (m^2)
cd  = 0.28;      % (-)
cr  = 0.009;     % (-) or (kg/kg)
mv  = 1700;      % (kg)
g   = 9.81;       % (m/s^2)
wr  = 0.324;     % (m)   Effective wheel radius


%% Operating points
% Assign either scalar (single values) as in example, or
% in arrays as in other example. The script will run with either. But all
% arrays (v,a,alpha) MUST be same length!

% Speed in km/h
%V = 25;  % <-- Single operating point
V = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180];
v = V./3.6;  % Convert all speeds from km/h to m/s

% Acceleration in m/s^2
a = 0;    % Example with single value
%a = [0 0 0 0 2.5 1.0 0 0];

% Road slope in rad
alpha = 0;   % Example with single value
%alpha = [0 0 0 0 0 0 0.31 0.07];


% The command 'fprintf' is a fancy way of printing numbers with very
% specific formatting. E.g. '%.1f' means "floating point number rounded to
% 1 decimal point". See 'doc fprintf' in Matlab consol for more help.
fprintf('Answers to Assignment 1, EDR100\n');

% Run for-loop through all operating point. Use length of 'v' array and use
% letter 'k' as counter

for k=1:length(v)
    fprintf('\n--- Scenario %i ---\n',k );
    fprintf('  V = %.1f km/h \t a = %.1f m/s^2 \t alpha = %.2f rad\n',V(k),a(k),alpha(k) );
    fprintf('  F_acc = %.1f N\n',Facc(a(k)) );
    fprintf('  F_a   = %.1f N\n',Fa(v(k)) );
    fprintf('  F_r   = %.1f N\n',Fr(alpha(k)) );
    fprintf('  F_g   = %.1f N\n',Fg(alpha(k)) );
    fprintf('  F_t   = %.1f N\n',Ft(a(k),v(k),alpha(k)) );
    fprintf('  T_w   = %.1f Nm\n',Tw(a(k),v(k),alpha(k)) );
    fprintf('  P_t   = %.1f W\n',Pt(a(k),v(k),alpha(k)) );
end



% Calculate total traction force needed (N)
function f = Ft(a,v,alpha)
    f = Facc(a) + Fa(v) + Fr(alpha) + Fg(alpha);
end

% Calculate total traction power needed (W)
function p = Pt(a,v,alpha)
    p = v.*Ft(a,v,alpha);
end

% Calculate total torque needed on driving wheels (Nm)
function T = Tw(a,v,alpha)
    global wr
    T = wr.*Ft(a,v,alpha);
end

% Calculate aerodynamic friction force (N)
function f = Fa(v)
    global rho Af cd
    f = 0.5*rho*Af*cd*v.^2;
end

% Calculate rolling friction (N)
function f = Fr(alpha)
    global rho cr mv g
    f = cr*mv*g*cos(alpha);
end

% Calculate slope force (N)
function f = Fg(alpha)
    global mv g
    f = mv*g*sin(alpha);
end

% Calculate inertia/acceleration force (N)
function f = Facc(a)
    global mv
    f = mv*a;
end


% EOF