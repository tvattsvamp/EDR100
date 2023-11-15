% Init script for Simulation model 3 (third lecture/assignment)
% EDR100 "Electric Drive Systems", October 2022.
% University West, Trollhättan, Sweden
% Written by Stefan Skoog

% Student instruction:
% Read through the init file and try to get an understanding of what each
% line means for the Simulink model.
% Find the areas where you can, and are supposed to make changes.

%clear all;  % Erase all parameters from workspace


%% Define global names (do not change)
global h            % Stepsize [s] for all other blocks
global N_sim        % Number of computational steps required to complete the simulation of the cycle [-] for all other blocks
global t_end;

% Electric machine parameters
global w_EM_upper;   % Absolutely max speed for EM (rad/s)
global w_EM_max;     % Speed vector where max torque is mapped (rad/s)
global T_EM_max;     % Max torque vector (Nm)
global w_EM;         % Speed points of EM data maps (rad/s)
global T_EM;         % Torque points of EM data maps (Nm)
global Loss_EM_map;  % Total EM losses map (W)
global PF_EM_map;    % Power factor map (-)
global Uph_EM_map;   % Phase voltage map (U RMS)
global Iph_EM_map;   % Phase current map (I RMS)

%% Environmental Constants for all blocks
g           = 9.81;        % Gravitation constant (m/s²)
rho         = 1.225;       % Air density (kg/m³)


%% Drive cycle (load your drive cycle data here)
% You may select another mat-file to inport, or run another m-file.
%  Workspace must contain the drive cycle data in the format:
%  t = time in s
%  v = speed in m/s
%  V = speed in km/h
load('WLTC_cycle');   % Load mat-file called "WLTC_cycle", contining, t,v,V


%% Load Electric Machine data
% Import relevant parameters from MotorCAD variables loaded into workspace
import_MotorCAD('Nissan_Leaf_Sample_Data');  % This file is exported directly from MotorCAD
% Electric Machine model
EM_scaling = 1;             % Scale EM up or down. I.e. 2 makes the torque capability twice as big
EM_inertia = 0;             % Inertia of all moving parts of EM. Set to 0 for EDR100 course.
P_aux_EM = 0;               % Idle losses in EM (cooling, pumps, safety systems). Set to 0 for EDR100 course.


%% User parameters (customize your vehicle here)
m_v = 1700;                % Vehicle total mass (kg)
d_wheel = 2.101/pi*0.97;   % Tire unloaded circumference to effective diameter (m)
rotating_mass = 0;         % Equivalent inertia (wheels, shafts) as percentage of total vehicle mass
A_f = 2.3;                 % Vehicle frontal area (m²)
c_d = 0.28;                % Drag coefficienct (-)
c_r = 9.0/1000;            % Wheel rolling friction coefficient (-)


%% Transmission (configure your gearbox here)

%gear_ratio = 8;           % lowest 3.6 highest 9.3 default 8
gear_ratio = 3.6:0.1:9.3;  % testing all gear ratios between 3.6 and 9.3 with 0.1 incraments.
eta_gear = 0.98;           % Efficiency of gearbox. One percent per gear stage as a rule of thumb.
P_aux_gear = 0;            % Idle losses in gearbox (pumps, clutches, actuators...)


%% Parameters conversion (do not change)
mt2m_f      = rotating_mass/100;	% The user made the input in [%]
r_wheel     = d_wheel/2;	% The user specified the diameter, not the radius

% Convert EM parameters
T_EM_max   = EM_scaling * T_EM_max;    % Scale max EM torque limit
Iph_EM_map = EM_scaling * Iph_EM_map;  % Scale output EM current
T_EM       = EM_scaling * T_EM;        % Scale the torque vector, and all maps will be scaled accordingly

% Assign values to global parameters
h = 1.0; % Time steps in drive cycle simulation
t_end = t(end); % End of simulation. Drive cycle must be loaded before this row!


%% Support functions (do not change)

% Function for importing data from MotorCAD data file
% Make sure parameters are declared as GLOBAL before running this function
% The function will convert all input data to Meshgrid format, so that Simulink
%   original lookup-table functions can be used
function import_MotorCAD(fileName)
    global w_EM;         % Speed points of EM data maps (rad/s)
    global T_EM;         % Torque points of EM data maps (Nm)
    global Loss_EM_map;  % Total EM losses map
    global PF_EM_map;    % Power factor map
    global Uph_EM_map;   % Phase voltage map
    global Iph_EM_map;   % Phase current map
    global w_EM_max;     % Speed vector where max torque is mapped (rad/s)
    global T_EM_max;     % Max torque vector (Nm)
    global w_EM_upper;   % Absolutely max speed for EM (rad/s)

    
    load(fileName);  % This file is exported directly from MotorCAD
    % Import relevant parameters from MotorCAD variables loaded into workspace
    w_EM_raw = Speed * 2*pi/60; % Speed from MotorCAD is rpm, convert to rad/s
    T_EM_raw = Shaft_Torque;
    Loss_EM_data = Total_Loss;
    PF_EM_data = Power_Factor;
    Uph_EM_data = Voltage_Phase_RMS;
    Iph_EM_data = Stator_Current_Phase_RMS;
    
    % Figure out max torque from MotorCAD data
    T_EM_max = T_EM_raw(:,1);
    w_EM_max = w_EM_raw(:,end);  % Pick out the corresponding speed indeces from Torque max operation
    w_EM_upper = max(max(w_EM_raw)); 
    
    % Create monotonically increasing vectors from speed and torque
    nx=150; % Number of speed steps
    ny=200; % Number of torque steps
    x0 = min(min(w_EM_raw));  x1 = max(max(w_EM_raw)); 
    y0 = min(min(T_EM_raw));  y1 = max(max(T_EM_raw)); 
    w_EM = linspace(x0,x1,nx)';
    T_EM = linspace(y0,y1,ny);
    [X,Y]=meshgrid(w_EM,T_EM);
    
    % Create scattered interpolant as a middle-step to achieve meshgrid data
    % This will create warnings, which is ok, hide warnings!
    w = warning(); % Get current warning settings
    warning('off','all');  % Disable all warnings
    interPmethod = 'linear';
    extrapMethod = 'none';  % Important not to extrapolate!
    F_loss = scatteredInterpolant(w_EM_raw(:), T_EM_raw(:), Loss_EM_data(:), interPmethod, extrapMethod);
    F_PF   = scatteredInterpolant(w_EM_raw(:), T_EM_raw(:), PF_EM_data(:),   interPmethod, extrapMethod);
    F_U    = scatteredInterpolant(w_EM_raw(:), T_EM_raw(:), Uph_EM_data(:),  interPmethod, extrapMethod);
    F_I    = scatteredInterpolant(w_EM_raw(:), T_EM_raw(:), Iph_EM_data(:),  interPmethod, extrapMethod);
    % Convert back maps to meshgrid format
    Loss_EM_map = F_loss(X,Y);
    PF_EM_map   = F_PF(X,Y);
    Uph_EM_map  = F_U(X,Y);
    Iph_EM_map  = F_I(X,Y);
    warning(w); % Re-set warnings as before
    
end


% End of File