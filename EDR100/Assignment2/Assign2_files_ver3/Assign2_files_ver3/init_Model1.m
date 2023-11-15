% Init script for Simulation model 1
% EDR100 "Electric Drive Systems", Sep 2022.
% University West, Trollhättan, Sweden
% Written by Stefan Skoog

clear all;  % Erase all parameters from workspace


%% Define global names
global h            % Stepsize [s] for all other blocks
global N_sim        % Number of computational steps required to complete the simulation of the cycle [-] for all other blocks
global t_end;


%% Environmental Constants for all blocks
g           = 9.81;        % Gravitation constant (m/s²)
rho         = 1.225;       % Air density (kg/m³)
alpha = -0.07               % drriving angle (rad)

%% Drive cycle
% You may select another mat-file to import, or run another m-file.
%  Workspace must contain the drive cycle data in the format:
%  t = time in s
%  v = speed in m/s
%  V = speed in km/h
load('WLTC_cycle');   % Load mat-file called "WLTC_cycle", contining, t,v,V
load('NEDC_cycle.mat')  % Load mat-file called "NEDC_cycle", contining, t_nedc,v_nedc
load('drive_cycle_self.mat') % Load mat-file called "drive_cycle_self", contining, t2,v2,V2
% Dummy data here, replace with your own data!
% t = [0 1 2 3 4 5 6 7 8 9]
% v = [0 0 0 1 1 1 1 1 0 0]


%% User parameters (customize your vehicle here)
m_v = 1700;                % Vehicle total mass (kg)
d_wheel = 0.648;           % Effective diameter (m)
rotating_mass = 0;         % Equivalent inertia (wheels, shafts) as percentage of total vehicle mass
A_f = 2.3;                 % Vehicle frontal area (m²)
c_d = 0.28;                % Drag coefficienct (-)
c_r = 9.0/1000;            % Wheel rolling friction coefficient (-)

%% Transmission (configure your gearbox here)
gear_ratio = 8;           
eta_gear = 0.98;           % Efficiency of gearbox. One percent per gear stage as a rule of thumb.
P_aux_gear = 0;            % Idle losses in gearbox (pumps, clutches, actuators...)



%% Parameters conversion, do not change!
mt2m_f      = rotating_mass/100;	% The user made the input in [%]
r_wheel     = d_wheel/2;	% The user specified the diameter, not the radius

% Assign values to global parameters
h = 1.0; % Time steps in drive cycle simulation
t_end = t(end); % End of simulation. Drive cycle must be loaded before this row!


% End of File