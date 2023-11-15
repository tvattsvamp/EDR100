% Assignemnt 2 A

%   WLTC
% figure(1);
% subplot(3,1,1);
% plot(out.Time,out.Speed)
% title('WLTC')
% %legend({'vehicle Speed (m/s)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Speed (m/s)')
% xlim([0 1801])
% 
% subplot(3,1,2);
% plot(out.Time,out.Acceleration)
% %legend({'vehicle Acceleration (m/s^2)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Acceleration (m/s^2)')
% xlim([0 1801])
% 
% subplot(3,1,3);
% plot(out.Time,out.P_wheel)
% %legend({'vehicle traction power (W)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Power (W)')
% xlim([0 1801])

%   NEDC
% figure(1);
% subplot(3,1,1);
% plot(out.Time,out.Speed)
% title('NEDC')
% %legend({'vehicle Speed (m/s)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Speed (m/s)')
% xlim([0 1180])
% 
% subplot(3,1,2);
% plot(out.Time,out.Acceleration)
% %legend({'vehicle Acceleration (m/s^2)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Acceleration (m/s^2)')
% xlim([0 1180])
% 
% subplot(3,1,3);
% plot(out.Time,out.P_wheel)
% %legend({'vehicle traction power (W)'},'Location','bestoutside')
% xlabel('Time (s)')
% ylabel('Power (W)')
% xlim([0 1180])

%   SELF
figure(1);
subplot(3,1,1);
plot(out.Time,out.Speed)
title('SELF')
%legend({'vehicle Speed (m/s)'},'Location','bestoutside')
xlabel('Time (s)')
ylabel('Speed (m/s)')
xlim([0 101])

subplot(3,1,2);
plot(out.Time,out.Acceleration)
%legend({'vehicle Acceleration (m/s^2)'},'Location','bestoutside')
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
xlim([0 101])

subplot(3,1,3);
plot(out.Time,out.P_wheel)
%legend({'vehicle traction power (W)'},'Location','bestoutside')
xlabel('Time (s)')
ylabel('Power (W)')
xlim([0 101])