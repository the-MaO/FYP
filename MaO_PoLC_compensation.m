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
S_orig = sqrt(P0h_polc.^2 + Q0h_polc.^2);

% calculate new load bus voltages
V_setpt = 1;
polc_rating = 0.05;
V_comp = uncVOLT(viol_load_buses(:,1),:);
V_polc = V_comp;

V_comp(abs(V_comp-V_setpt)<=polc_rating) = V_setpt;
V_comp((V_comp-V_setpt)>polc_rating) = V_comp((V_comp-V_setpt)>polc_rating) - polc_rating;
V_comp((V_setpt-V_comp)>polc_rating) = V_comp((V_setpt-V_comp)>polc_rating) + polc_rating;
% PoLC device voltage
V_polc = V_comp - V_polc;

% for debug
% figure
% boxplot(V_comp','Labels',num2cell(viol_load_buses(:,1)));
% xlabel('load bus number');
% ylabel('voltage p.u.');
% hold on
% plot(xlim,[0.94 0.94],'g');
% plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
% grid on


for i=1:size(viol_load_buses,1)
    P0h_polc(viol_load_buses(i,2),:) = P0h_polc(viol_load_buses(i,2),:) .* ...
        (V_comp(i,:) ./ uncVOLT(viol_load_buses(i,1))).^(npt(viol_load_buses(i,2)));
    Q0h_polc(viol_load_buses(i,2),:) = Q0h_polc(viol_load_buses(i,2),:) .* ...
        (V_comp(i,:) ./ uncVOLT(viol_load_buses(i,1))).^(nqt(viol_load_buses(i,2)));
end

S_comp = sqrt(P0h_polc.^2 + Q0h_polc.^2);

I_polc = S_comp(viol_load_buses(:,2),:)./(V_base.*V_comp);
S_polc = abs(2*V_base*polc_rating*I_polc);
figure
boxplot(S_polc')
total_polc_rating = sum(max(S_polc,[],2))