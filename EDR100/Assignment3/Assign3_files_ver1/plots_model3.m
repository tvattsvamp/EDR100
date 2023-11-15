%% C2
max_total_losses = max(out.P_loss_tot / 10.^3)

%% C3
max_TM_losses_J = max(out.P_loss_TM_J)
max_EM_losses_J = max(out.P_loss_EM_J)
diff_losses_J = max_EM_losses_J - max_TM_losses_J
%% final testing
gear_ratio = 3.6:0.1:9.3;
a = out.Total_acc_power(1801,:);
b = round(a,1);
min = min(b);
k = find(b==min);
GR_with_least_acc_input_power = gear_ratio(:,k)