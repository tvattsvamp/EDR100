%% energy consumption 1 drive cycle (Wh/km)
% used generated value in simulink
%% Battery capacity (kWh)
Amp_h_cell = 5;
nominal_voltage_cell = 3.65;
battery_cell_series = 96;
battery_cell_paralell = 35;
capacity_module = Amp_h_cell*(nominal_voltage_cell*battery_cell_series);
capacity_ESS = battery_cell_paralell * capacity_module;
%% Estimated Range (km)
size_rows = size(out.Energy_consumption,1)
Estimated_range = (capacity_ESS / round(out.Energy_consumption([size_rows],1),1))   % (batterycpacity(kWh) / avg.consumption (Wh/km);
%% max power consumption at wheel (kW)
% Torque * rotation or ESS powerdraw - losses
TR_power = out.wheel_torque .* out.wheel_speed;
%plot(out.Time,abs(TR_power))
TR_max_power = (max(abs(TR_power)) / 1000)
tr_idx = find(TR_power==(TR_max_power * 1000))
% power_ess_minus_losses_max = max(abs(out.ESS_power_delivery))
% power_ess_minus_losses_idx = find(out.ESS_power_delivery==power_ess_minus_losses_max)
% power_ess_minus_losses = (out.ESS_power_delivery(power_ess_minus_losses_idx,:) - (out.ESS_power_loss(power_ess_minus_losses_idx,:) + out.PEC_loss(power_ess_minus_losses_idx,:) + out.EM_loss(power_ess_minus_losses_idx,:) + out.TM_loss(power_ess_minus_losses_idx,:) + out.roll_aero_inertia_loss(power_ess_minus_losses_idx,:)))

%% average speed (km/h)
avg_speed = sum(V) / length(V(:,1))
%avg_speed2 = sum(out.avg_speed) / length(out.avg_speed(:,1)) * 3.6
%% plot WLTC, NEDC, UDDS depending on what cycles is used in simulink model
figure(1);
plot(out.Time,V)
title("NYCC Drive Cycle") % change name depending on cycle used
xlabel("Time(s)");
ylabel("Velocity (km/h)")
legend({'Velocity (km/h)'},'Location','best')
%% 120kWh ESS
capacity_ESS_new = 120 * 1000;
Amp_h_cell = 5;
nominal_voltage_cell = 3.65;
battery_cell_series = 96;
capacity_module = Amp_h_cell*(nominal_voltage_cell*battery_cell_series);
battery_cell_paralell_new = ceil(capacity_ESS_new / capacity_module);
mass_single_cell = 0.07;
mass_of_cells = (battery_cell_paralell_new * battery_cell_series)*mass_single_cell;
mass_off_ESS = mass_of_cells / 0.66;         % 66% of ESS is cells rest cooling and structures ect.
mass_off_ESS_auxsystems = mass_off_ESS - mass_of_cells;
%% Estimated Range 120wh (km)
size_rows = size(out.Energy_consumption,1)
Estimated_range = (capacity_ESS_new / round(out.Energy_consumption([size_rows],1),1))   % (batterycpacity(kWh) / avg.consumption (Wh/km);
%% create acceleration cycle 0-200-0kmh
for i = 1.0:1.0:95.0;
    t(i,1) = i;
end
for k = 1.0:1.0:3.0;
    v(k,1) = 1;
end
for j = 4.0:1.0:10.0;
    v(j,1) = 1+(4.5*(j-4));
end
for l = 11.0:1.0:39.0;
    v(l,1) = v(10,1) + l-11;
end
for m = 1.0:1.0:56;
    v(39+m,1) = v(39,1)-1*m;
end
for ii = 1.0:1.0:95.0;
    V(ii,1) = v(ii,1) * 3.6;
end
%% gear box GR calculation
max_v = 200 / (18/5);
wheel_rad_200 = max_v / (d_wheel / 2);
max_EM_rot = (10000*2*pi)/60;
GR = floor(max_EM_rot / wheel_rad_200);
%% 100kWh ESS
capacity_ESS_new = 100 * 1000;
Amp_h_cell = 6;
nominal_voltage_cell = 3.65;
battery_cell_series = 96;
capacity_module = Amp_h_cell*(nominal_voltage_cell*battery_cell_series);
battery_cell_paralell_new = ceil(capacity_ESS_new / capacity_module);
mass_single_cell = 0.07;
mass_of_cells = (battery_cell_paralell_new * battery_cell_series)*mass_single_cell;
mass_off_ESS = mass_of_cells / 0.66;         % 66% of ESS is cells rest cooling and structures ect.
mass_off_ESS_auxsystems = mass_off_ESS - mass_of_cells;
%% plot acc_cycle after simulink run

figure(2);
subplot(2,1,1);
plot(t,V);
title("Acceleration cycle")
xlabel("Time(s)")
ylabel("Velocity(km/h)")
legend({'Velocity (km/h)'},'Location','best')
xlim([0 95])
ylim([0 210])
grid on;

subplot(2,1,2);
plot(out.Time,out.Acceleration)
title("Acceleration");
xlabel("Time(s)");
ylabel("Acceleration(m/s^2)")
legend({'Acceleration (m/s^2)'},'Location','best')
ylim([-2 6])
xlim([0 95])
grid on;

%% power em
power_em = out.T_EM .* out.w_EM

%% battery truck
%% 100kWh ESS
capacity_ESS_new = 100 * 1000;
Amp_h_cell = 6;
nominal_voltage_cell = 3.65;
battery_cell_series = 96;
capacity_module = Amp_h_cell*(nominal_voltage_cell*battery_cell_series);
battery_cell_paralell_new = ceil(capacity_ESS_new / capacity_module);
mass_single_cell = 0.07;
mass_of_cells = (battery_cell_paralell_new * battery_cell_series)*mass_single_cell;
mass_off_ESS = mass_of_cells / 0.66;         % 66% of ESS is cells rest cooling and structures ect.
mass_off_ESS_auxsystems = mass_off_ESS - mass_of_cells;
