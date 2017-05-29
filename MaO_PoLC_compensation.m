%% get load buses with voltage violation
% load uncompensated flow data and get violated buses
filename = [load_profile 'S=' num2str(S_mltp) 'Z=' num2str(Z_mltp) ...
    'XR=' num2str(XR_mltp)];
load (['unc' filename '.mat']);
V_lim_uk = 0.94;
violations = uncVOLT < V_lim_uk;
[viol_buses, ~] = find(violations);
viol_buses = unique(viol_buses);
min(viol_buses)

% find violated load buses and their indices in load_indx (=indices in P0h)
num_of_loads = length(load_indx);
viol_load_buses = intersect(load_indx,viol_buses);
for i=1:length(viol_load_buses)
    viol_load_buses(i,2) = find(viol_load_buses(i,1) == load_indx);
end

%% calculate new P and Q for PoLC loads
% create new load P and Q matrices
P0h_polc = P0h(1:num_of_loads,:);
Q0h_polc = Q0h(1:num_of_loads,:);

% calculate new load bus voltages
V_setpt = 0.97;
polc_rating = 0.01;
V_polc = uncVOLT(viol_load_buses(:,1),:);

V_polc(abs(V_polc-V_setpt)<=polc_rating) = V_setpt;
V_polc((V_polc-V_setpt)>polc_rating) = V_polc((V_polc-V_setpt)>polc_rating) - polc_rating;
V_polc((V_setpt-V_polc)>polc_rating) = V_polc((V_setpt-V_polc)>polc_rating) + polc_rating;

% for debug
figure
plot(uncVOLT(viol_load_buses(1,1),:));
hold on
plot(V_polc(1,:));

for i=1:size(viol_load_buses,1)
    P0h_polc(viol_load_buses(i,2),:) = P0h_polc(viol_load_buses(i,2),:) .* ...
        (V_polc(i,:) ./ uncVOLT(viol_load_buses(i,1))).^(npt(viol_load_buses(i,2)));
    Q0h_polc(viol_load_buses(i,2),:) = Q0h_polc(viol_load_buses(i,2),:) .* ...
        (V_polc(i,:) ./ uncVOLT(viol_load_buses(i,1))).^(nqt(viol_load_buses(i,2)));
end