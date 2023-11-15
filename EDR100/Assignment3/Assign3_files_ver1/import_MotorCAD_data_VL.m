% Import MotorCAD data for Simulation model 3
% EDR100 "Electric Drive Systems", 2022.
% University West, Trollhättan, Sweden
% Written by Stefan Skoog, 2022

% Load raw data file exported from MotorCAD
load('Nissan_Leaf_Sample_Data');

w2 = Speed; % rotational speed in RPM
w = Speed * 2*pi/60; % Speed from MotorCAD is rpm, convert to rad/s
T = Shaft_Torque;
P_out = Shaft_Power;
P_in = Terminal_Power;
P_loss = Total_Loss;
eta = Efficiency;
PF = Power_Factor;
U_ph_RMS = Voltage_Phase_RMS;
I_ph_RMS = Stator_Current_Phase_RMS;

%% A1
figure(10);
surf(w,T,eta);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Effiency (percent)');
%legend({'rotational speed','Torque EM','Effiency'},Location="bestoutside")
%% A2
figure(11);
surf(w,T,U_ph_RMS);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Phase voltage RMS (V)');
%% A3
figure(12);
surf(w,T,I_ph_RMS);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Phase Current RMS (A)');
%% A4
figure(13);
surf(w,T,100 * PF);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Power factor (%)');
%% A5
figure(14);
surf(w,T,P_loss / 1000);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Total power losses (kW)');
%% A6
figure(15);
surf(w,T,P_out / 1000);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Power out EM (kW)');
%% B1
max_rotational_speed_RPM = max(w2(:));
max_rotational_speed_w = max(w(:));
%% B2
max_tourque = max(T);
max_tourque_2 = max(max_tourque);
%% B3
Zmax = max(eta(:))
[Zmax,Idx] = max(eta(:)); %possition of max value
[ZmaxRow,ZmaxCol] = ind2sub(size(eta), Idx); % finds row and col of max value
speedMax_point = w(ZmaxRow,ZmaxCol) % locates corresponding value att Zmaxrow and zmaxcol in speedmatrix
torqueMax_point = T(ZmaxRow,ZmaxCol) % locates corresponding value att Zmaxrow and zmaxcol in torque matrix
%% B4
Voltage_min = min(U_ph_RMS(:))
%% B5
Umax = max(U_ph_RMS(:));
[Umax,Idx] = max(U_ph_RMS(:)); %possition of max value
xy = ind2sub(size(U_ph_RMS), Idx); % finds row and col of max value
speedMax_point_U = w(UmaxRow,UmaxCol) % locates corresponding value att Zmaxrow and zmaxcol in speedmatrix
torqueMax_point_U = T(UmaxRow,UmaxCol) % locates corresponding value att Zmaxrow and zmaxcol in torque matrix

figure(16);
h = surf(w,T,U_ph_RMS);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('Phase voltage RMS (V)');
datatip(h,'DataIndex',xy);
%% B6
highest_current = max(I_ph_RMS(:))
lowest_current = min(I_ph_RMS(:))
%% B7
round_eta = round(eta,1);
mode(round_eta(:))
%% B8
maxP_shaft = max(P_out(:))
[Pmax,Idx] = max(P_out(:)); %possition of max value
[PmaxRow,PmaxCol] = ind2sub(size(P_out), Idx); % finds row and col of max value
xy_2 = ind2sub(size(P_out), Idx); % finds row and col of max value
speedMax_point_P = w(PmaxRow,PmaxCol) % locates corresponding value att maxrow and maxcol in speedmatrix
torqueMax_point_P = T(PmaxRow,PmaxCol) % locates corresponding value att maxrow and maxcol in torque matrix

figure(17);
h = surf(w,T,P_out / 1000);
title('Nissan Leaf EM');
xlabel('Rotational Speed (rad/s)');
ylabel('Torque (Nm)');
zlabel('EM shaft power (kW)');
datatip(h,'DataIndex',xy_2);
% End of File