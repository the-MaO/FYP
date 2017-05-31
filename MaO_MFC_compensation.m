%% find earliest load bus where violation occurs
filename = [load_profile 'S=' num2str(S_mltp) 'Z=' num2str(Z_mltp) ...
    'XR=' num2str(XR_mltp)];
load (['unc' filename '.mat']);
V_lim_uk = 0.94;
violations = uncVOLT < V_lim_uk;
[viol_buses, ~] = find(violations);
viol_buses = unique(viol_buses);
min(viol_buses)
mfc_load_buses = intersect(viol_buses, load_indx)
mfc_load_buses = sort([mfc_load_buses; 388; 349])

%% now manually find the bus in the main path to connect the MFC to
% first_bus = 178 -> plug it between 148 and 155
% first bus = 898 -> 878 and 884
% to compensate for whole end branches -> 272 and 280

%% get normalised power flow to the feeder
% P_net = sum(P0h(1:size(load_indx,1),:));
% P_norm = (P_net - min(P_net))./(max(P_net) - min(P_net));
% MFC = P_norm * 0.15 + 0.94;

% % MFC from last load bus voltage
% last_bus = load_indx(end);
% MFC = uncVOLT(last_bus,:);
% MFC(MFC<0.96) = 0.96;

% mfc from last load bus voltage, DSM
% last_bus = load_indx(end);
% MFC = uncVOLT(last_bus,:);
% MFC(MFC>0.985) = 1.04;
% MFC(MFC>0.97&MFC<1.04) = 1.02;
% MFC(MFC>0.95&MFC<1.02) = 0.985;
% MFC(MFC>0.94&MFC<0.985) = 0.98;
% MFC(MFC<0.94) = 0.97;

% MFC from flow at it
MFC = uncVOLT(272,:);         % MFC upstream bus
MFC(MFC>0.99) = 1.04;
MFC(MFC>0.97&MFC<1.04) = 1.01;
MFC(MFC>0.95&MFC<1.01) = 0.98;
MFC(MFC<0.95) = 0.97;

figure
plot(MFC);
title('MFC taps')
% hold on
% plot(uncVOLT(last_bus,:));
% legend('mfc','load');
