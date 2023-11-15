%% converts original mph values to m/s
t = UDDS(:,1)
V = UDDS(:,2) .* 1.609344
v = UDDS(:,2) .* 0.44704
%%
t = NYCC(:,1)
V = NYCC(:,2) .* 1.609344
v = NYCC(:,2) .* 0.44704
