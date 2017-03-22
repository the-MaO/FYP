
S_base = 1e3;

load('PQnpnq_summer_wd.mat');



P_net = (2*sum(P0h(1:189,:)));
P_normal  = (P_net - min(P_net))./(max(P_net) - min(P_net));
TAP(1,1:1440) = smooth(P_normal,180)*.15 + 0.95;
edges = 0.925:0.025:1.125;
values = edges(2:end);
YY = discretize(TAP,values);

TAP = .95 + YY*.025-.025;
MFC = P_normal*.15 + 0.94;
MFC = MFC';

 

clearvars -except TAP MFC; 





