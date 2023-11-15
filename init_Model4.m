% Init script for Simulation model 4 (fourth lecture/assignment)
% EDR100 "Electric Drive Systems", November 2022.
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
load('UDDS_cycle.mat');   % Load mat-file called "WLTC_cycle", contining, t,v,V


%% Load Electric Machine data
% Import relevant parameters from MotorCAD variables loaded into workspace
import_MotorCAD('Nissan_Leaf_Sample_Data');  % This file is exported directly from MotorCAD
% Electric Machine model
EM_inertia = 0;        % Inertia of all moving parts of EM. Set to 0 for EDR100 course.
P_aux_EM = 0;          % Idle losses in EM (cooling, pumps, safety systems). Set to 0 for EDR100 course.
EM_scaling = 2;        % Scale EM up or down. I.e. 2 makes the torque capability twice as big


%% Load Power Electric Converter (PEC) data
load('IGBT_FS820_data'); % Load IGBT loss parameter file into workspace
PEC_phaseCount = 3;  % Number of EM phases.
PEC_U_DC = 400;      % (V) Supply direct voltage from battery system
PEC_Umax = PEC_U_DC; % (V) Max phase peak-to-peak voltage.
PEC_Imax = 500;      % (A) Rated max phase current in RMS
PEC_fs = 10000;      % (Hz) Switching frequency of PEC IGBTs in Hz. Normal 10 kHz
PEC_Tj = 100;        % (°C) Temperature of IGBT junctions. Normally 60-100°C
PEC_P_aux = 0;       % (W) Idle losses in EM (processor, gate drivers, cooling...)
PEC_scaling = 2;     % Scale of PEC power. 1.0 corresponds to ca 150 kW PMSM or IPM traction machine


%% Battery System (ESS) data
% Main parameters to configure by students below here
ESS_start_SOC = 80;         % (%) State of charge at beginning of simulation
ESS_cell_Qmax = 6;         % (Ah) Charge capacity of each battery cell
ESS_cells_series = 96;     % How many cells in series?
ESS_cells_parallel = 35;    % How many cells in parallel?
ESS_cell_Cvalue = 4;      % Max relative peak current (C-rate). 1-3 C for EV packs, 5-10 C for PHEV packs.
ESS_cell_R_scaling = 1;     % Scale internal resistance, nominal value 1. Value 2 means twice the internal resistance.

% ------- You will likely not need to change the battery parameters below this line ------- 
ESS_cell_Vnom = 3.65;     % (V) Nominal cell voltage
ESS_cell_Vmin = 2.70;     % (V) Lower cut-off voltage (cell protection)
ESS_cell_Vmax = 4.15;     % (V) Upper cut-off voltage (cell protection)
ESS_cell_mass = ESS_cell_Qmax*0.070/5.0;   % (kg) weight of each cell (scaled linearily with cell capacity), without other ESS support systems
ESS_cell_Emax = ESS_cell_Qmax * ESS_cell_Vnom;  % (Wh) Cell energy. Only used in this file.
ESS_cell_R10 = 0.4015*ESS_cell_R_scaling/ESS_cell_Emax;    % Cell internal 10-second resistance in Ohms, calculated from size/energy-scaled parameters.
ESS_cell_Imax =  ESS_cell_Cvalue*ESS_cell_Qmax;   % Discharge current peak
ESS_cell_Imin = -ESS_cell_Cvalue*ESS_cell_Qmax;   % Charge current peak
% Open circuit voltage of typical Li-ion NMC automotive cell
ESS_cell_OCV(1,:) = [  0 2.80 3.429 3.450 3.494 3.571 3.609 3.642 3.696 3.812 3.908 4.02 4.15 4.40]; % (V) Open circuit voltage
ESS_cell_OCV(2,:) = [-15 0 10 15 20 30 40 50 60 70 80 90 100 120]; % (%) SOC value
% Calculate the initial voltage of the pack (at time 0)
ESS_pack_start_voltage = interp1(ESS_cell_OCV(2,:), ESS_cell_OCV(1,:),ESS_start_SOC ) * ESS_cells_series;


%% User parameters (customize your vehicle here)
m_v = 10160;                % (kg) Vehicle total mass
rotating_mass = 0;         % (%) Equivalent inertia (wheels, shafts) as percentage of total vehicle mass
d_wheel = 2.846/pi*0.97;   % (m) Tire unloaded circumference to effective diameter
c_r = 9.0/1000;            % (-) Wheel rolling friction coefficient
A_f = 6.52;                 % (m²) Vehicle frontal area
c_d = 0.5;                % (-) Drag coefficienct


%% Transmission (configure your gearbox here)
gear_ratio = 16;            % (-)
eta_gear = 0.98;           % (0..1) Efficiency of gearbox. One percent per gear stage as a rule of thumb.
P_aux_gear = 0;            % (W) Idle losses in gearbox (pumps, clutches, actuators...)


%% Parameters conversion (do not change)
mt2m_f      = rotating_mass/100;	% The user made the input in [%]
r_wheel     = d_wheel/2;	% The user specified the diameter, not the radius

% Convert EM parameters
T_EM_max   = EM_scaling * T_EM_max;    % Scale max EM torque limit
Iph_EM_map = EM_scaling * Iph_EM_map;  % Scale output EM current
T_EM       = EM_scaling * T_EM;        % Scale the torque vector, and all maps will be scaled accordingly

% Scale PEC losses
% PEC_scale = EXTERNAL (configurable) scaling variable
% scale_PEC = Used in PEC block!?
% Re-scale transistor and diode conduction resistances with scaling factor
% Also shift the reference current vector 
PEC_i2     = PEC_i2 * PEC_scaling;       % Transistor current reference vector
PEC_Rt_con = PEC_Rt_con / PEC_scaling;   % Transistor resistance
PEC_Rd_con = PEC_Rd_con / PEC_scaling;   % Diode resistance
PEC_Imax   = PEC_Imax * PEC_scaling;     % Max current limit

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