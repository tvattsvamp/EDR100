%% 2c
ESS_loss_max = max(out.ESS_p_loss) % finds max ESS power loss
time_ESS_max = find(out.ESS_p_loss==ESS_loss_max)-1 % finds where max ESS powerloss occures in time

tot_p_loss_all_exESS = out.TM_p_loss + out.EM_p_loss + out.PEC_p_loss;  % compinds all losses except ESS 
max_p_loss_all_exESS = max(tot_p_loss_all_exESS)    % finds max combined losses 
time_all_exESS_max = find(tot_p_loss_all_exESS==max_p_loss_all_exESS)-1 % finds where in time these losses occure

figure(1);
subplot(3,1,1);
plot(out.Time,(tot_p_loss_all_exESS / 1000))
title('EM,TM and PEC losses combined')
ylabel('Watt (kW)')
xlabel('Time (s)')

subplot(3,1,2);
plot(out.Time,(out.ESS_p_loss/1000))
title('ESS power losses')
ylabel('Watt (kW)')
xlabel('Time (s)')

subplot(3,1,3);
plot(out.Time,out.vehicle_speed)
title('WLTC Speed')
ylabel('velocity (m/s)')
xlabel('Time (s)')
%% 2d
PEC_loss_max = max(out.PEC_p_loss)  %findes max PEC loss
time_PEC_max = find(out.PEC_p_loss == PEC_loss_max)-1   % fines where in time max PEC loss occures

max_acceleration = max(out.vehicle_acceleration)    % finds max acceleration
time_max_acc = find(out.vehicle_acceleration == max_acceleration)-1 % finds where max acceleration occures 

max_PEC_I_EM = max(out.PEC_I_phase_RMS_EM) % finds max phase current
time_max_PEC_I_EM = find(out.PEC_I_phase_RMS_EM == max_PEC_I_EM) % time for max phase current

figure(2);
subplot(3,1,1);
plot(out.Time,(out.PEC_p_loss / 1000))
title('PEC losses')
ylabel('Watt (kW)')
xlabel('Time (s)')

subplot(3,1,2);
plot(out.Time,out.vehicle_acceleration)
title('WLTC Acceleration')
ylabel('Acceleration (m/s^2)')
xlabel('Time (s)')

subplot(3,1,3);
plot(out.Time,out.PEC_I_phase_RMS_EM)
title('Current Phase RMS EM')
ylabel('Current (A)')
xlabel('Time (s)')
%% 2e
tot_acc_EM = out.EM_J_loss(1801,:) / 1000 % acc joules kJ
tot_acc_TM = out.TM_J_loss(1801,:)  / 1000 % acc joules kJ
tot_acc_PEC = out.PEC_J_loss(1801,:)  / 1000 % acc joules kJ
tot_acc_ESS = out.ESS_J_loss(1801,:)  / 1000 % acc joules kJ
%% 3
tot_acc_ESS = max(out.ESS_J_loss)  / 1000 % acc joules kJ

figure(3);
subplot(3,1,1)
plot(out.Time,out.ESS_cell_V)
title('ESS cell Voltage')
xlabel('Time (s)')
ylabel('Voltage (V)')

subplot(3,1,2)
plot(out.Time,out.ESS_cell_A)
title('ESS cell Current')
xlabel('Ampere (A)')
ylabel('Speed (m/s)')

subplot(3,1,3)
plot(out.Time,out.vehicle_speed)
title('WLTC Speed')
xlabel('Time (s)')
ylabel('Speed (m/s)')

figure(4);
plot(out.Time,(out.ESS_J_loss / 1000))
title('Accumulated losses ESS, scaling factor: 2')
ylabel('Joules (kJ)')
xlabel('Time (s)')
%% 4
Acc_losses_PEC_and_EM = (max(out.EM_J_loss) + max(out.PEC_J_loss))/1000 % combined acc losses of EM and PEC
%% 5a

figure(5)
plot(out.Time,out.Motor_torque)
title('Motor Torque')
xlabel('Time (s)')
ylabel('Torque (Nm)')

max_torque = max(out.Motor_torque)
%% 5b
figure(6)
subplot(2,1,1)
plot(out.Time,out.Motor_torque)
title('Motor Torque')
xlabel('Time (s)')
ylabel('Torque (Nm)')

subplot(2,1,2)
plot(out.Time,(out.PEC_J_loss / 1000),out.Time,(out.EM_J_loss)/1000)
title('Total losses PAC & EM')
ylabel('Joules (kJ)')
xlabel('Time (s)')
legend({'PEC','EM'},Location="best")

PEC_acc_max = max(out.PEC_J_loss) / 1000
EM_acc_max = max(out.EM_J_loss) / 1000
%% 6
ESS_eff = 1 - (max(out.ESS_J_loss) / max(out.ESS_E_tot))
PEC_eff = 1 - (max(out.PEC_J_loss) / max(out.ESS_E_tot))
EM_eff = 1 - (max(out.EM_J_loss) / max(out.ESS_E_tot))
GB_eff = 1 - (max(out.TM_J_loss) / max(out.ESS_E_tot))
tot_eff = 1 - ((max(out.ESS_J_loss) + max(out.PEC_J_loss) + max(out.EM_J_loss) + max(out.TM_J_loss)) / max(out.ESS_E_tot))