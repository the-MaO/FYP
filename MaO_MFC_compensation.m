%% find earliest load bus where violation occurs
filename = [load_profile 'S=' num2str(S_mltp) 'Z=' num2str(Z_mltp) ...
    'XR=' num2str(XR_mltp)];
load (['unc' filename '.mat']);
% V_lim_uk = 0.94;
% violations = V_loads < V_lim_uk;
% [row, ~] = find(violations);
% 
% first_bus = load_indx(min(row))

%% now manually find the bus in the main path to connect the MFC to
% first_bus = 178 -> plug it between 148 and 155
% first bus = 898 -> 878 and 884

%% get normalised power flow to the feeder
P_net = sum(P0h(1:size(load_indx,1),:));
P_norm = (P_net - min(P_net))./(max(P_net) - min(P_net));

% MFC = P_norm * 0.15 + 0.94;
MFC = V_loads(end,:);
MFC = smooth(MFC,3);
MFC(MFC<0.96) = 0.96;
% find(MFC < 0.96) = 0.96;
% MFC = MFC';
% MFC = 1./MFC;
plot(MFC);
hold on
plot(V_loads(end,:));
legend('mfc','load');
