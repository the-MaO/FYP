S_base = 1e3;

load('Load_Profiles_CRES/PQnpnq_summer_wd.mat');
Solar_Profile_Generation;
EV_Profile_Generation;


P_net = (2*sum(P0h(1:189,:))-SUN*189 +EV*189);
P_normal  = (P_net - min(P_net))./(max(P_net) - min(P_net));
TAP(1,1:1440) = smooth(P_normal,180)*.15 + 0.95;
edges = 0.925:0.025:1.125;
values = edges(2:end);
YY = discretize(TAP,values);

TAP = .95 + YY*.025-.025;
MFC = P_normal*.15 + 0.94;
MFC = MFC';

MFC(635:645,1) =   MFC(635:645,1)  -.005;
MFC(684:706,1) =  MFC(684:706,1) -.01;
MFC(944:1023,1) = MFC(944:1023,1)-.02;
MFC(1023:1160,1) =  MFC(1023:1160,1) -.035;
MFC(1160:1167,1) =  MFC(1160:1167,1) -.035;


clearvars -except TAP MFC;





