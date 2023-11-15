%% körcykel plot
figure(1)
plot(t,V)
title("UDDS Drive Cycle")
ylabel("Velocity (km/h)")
xlabel("Time(s)")
legend({"Speed (km/h)"},'Location','best')

%% power over time plot
figure(2)
plot(out.Time,out.Power_wheel/1000)
title("Power Wheel Axel")
ylabel("Power (kW)")
xlabel("Time(s)")
legend({"Power(W)"},'Location','best')


%% Plott Losses watt
figure(3)
plot(out.Time,out.PEC_Wloss/1000,out.Time,out.EM_Ploss/1000,out.Time,out.TM_Ploss/1000,out.Time,out.ESS_Ploss/1000)
ylabel("Power(kW)")
xlabel("Time(s)")
title("Losses of systems")
legend({"PEC losses","EM losses","TM losses","ESS losses"},'Location','best')

%% Vehicle Losses
figure(4)
plot(out.Time,Vehicle_losses/1000,'k')
ylabel("Power(kW)")
xlabel("Time(s)")
title("Vehicle Power losses")
legend({"Vehicle Losses"},'Location','best')
%%
%% 150kWh ESS
capacity_ESS_new = 150 * 1000;
Amp_h_cell = 6;
nominal_voltage_cell = 3.65;
battery_cell_series = 96;
capacity_module = Amp_h_cell*(nominal_voltage_cell*battery_cell_series);
battery_cell_paralell_new = ceil(capacity_ESS_new / capacity_module)
mass_single_cell = 0.07;
mass_of_cells = (battery_cell_paralell_new * battery_cell_series)*mass_single_cell
mass_off_ESS = mass_of_cells / 0.66         % 66% of ESS is cells rest cooling and structures ect.
mass_off_ESS_auxsystems = mass_off_ESS - mass_of_cells
