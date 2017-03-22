clear all;
clc; clf; close all;

%-----------------------------------------------------------
%Import EU LV Network Data
%----------------------------------------------------------
Lines_EU = readtable('Lines_EU.csv');
Loads = readtable('Loads.csv');

%Base values
V_base = 416/sqrt(3);
S_base = 1e3;
Z_base = V_base^2/S_base;

V_Source= 1.0; phase_selected = 'A';
% ----------------------Line data starts-------------------------------

% Line data format
% from bus, to bus, resistance(pu), reactance(pu),
% line charging(pu), tap ratio, phaseshift   
line(:,1) = Lines_EU.Bus1;
line(:,2) = Lines_EU.Bus2;
line(:,3) = Lines_EU.Length .*Lines_EU.R1/1000/Z_base;
line(:,4) = Lines_EU.Length .*Lines_EU.X1/1000/Z_base;
line(:,5) = Lines_EU.Length .*Lines_EU.C1/1000/Z_base;
line(:,6) = 1;
line(:,7) = 0;

aa = size(line,1);
line(aa+1,:)   =  [1000   1   .4/800/3 4/800/3  0   1  0]; %Transformer connected between node 1000 (source) and 1 (LV node)
    
% -----------------------Bus data starts-------------------------------

% Bus data format
% bus number, voltage(pu), angle(degree), P_gen(pu), Q_gen(pu),
% P_load(pu), Q_load(pu), G-shunt(pu), B-shunt(pu); bus_type
% bus_type - 1, swing bus
%          - 2, generator bus (PV bus)
%          - 3, load bus (PQ bus)

BUS(:,1) = unique(line(:,1:2));
BUS(:,2) = 1;
BUS(:,3:9) = 0;
BUS(:,10) = 3;

slack_indx = find(BUS(:,1)== 1000);

BUS(slack_indx,10) = 1; %Slack bus
BUS(slack_indx,2) = V_Source;%Slack bus

%find indices of buses to which loads on selected phase are connected
load_index = Loads.Bus(find(strcmp(Loads.phases, phase_selected)));

for tt=1:50:1000;   %time loop
load_inc = 1; 
for ii=1:1:length(load_index)   % load loop
     idx = find(BUS(:,1)==load_index(ii));
     BUS(idx,6) = tt*3000./S_base/1440;
     BUS(idx,7) = 100./S_base;
     load_inc = load_inc + 1;
    [bus_sol,line_sol,line_flow] = loadflow(BUS,line,1e-5,30,1,'y',1);
    
    VOLT(:,tt) = bus_sol(:,2);
    tt
end
end
