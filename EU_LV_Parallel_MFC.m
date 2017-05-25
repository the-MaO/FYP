clear all;
TAP_Calculations;
clc; clf; close all;
load('PQnpnq_summer_wd.mat');

load('FF.mat');
MFC = MFC-FF;


Solar_Profile_Generation;
EV_Profile_Generation;


%-----------------------------------------------------------
%Import EU LV Network Data
%----------------------------------------------------------
Lines_EU = readtable('Lines_EU.csv');
Loads = readtable('Loads.csv');

%Base values
V_base = 416/sqrt(3);
S_base = 1e3;
Z_base = V_base^2/S_base;

parallel_systems = 1;
V_Source= 1.0; phase_selected = 'A';
% ----------------------Line data starts-------------------------------

% Line data format
% from bus, to bus, resistance(pu), reactance(pu),
% line charging(pu), tap ratio, phaseshift
line(:,1) = Lines_EU.Bus1;
line(:,2) = Lines_EU.Bus2;
line(:,3) = Lines_EU.Length .*Lines_EU.R1/1000/Z_base*4;
line(:,4) = Lines_EU.Length .*Lines_EU.X1/1000/Z_base*4;
line(:,5) = Lines_EU.Length .*Lines_EU.C1/1000/Z_base;
line(:,6) = 1;
line(:,7) = 0;

line_inc = 1000; rr =0;
for pp=1:1:parallel_systems
    aa = size(line,1);
    LINE(rr+1:rr+aa,:) = [line(:,1)+line_inc   line(:,2)+line_inc   line(:,3)   line(:,4)  line(:,5)  line(:,6)  line(:,7)];
    if (line_inc ==1000)
        LINE(rr+aa+1,:)   =  [1000   line(1,1)+line_inc   .4/800/parallel_systems/3 4/800/parallel_systems/3  0   1  0]; %Transformer connected between node 1000 (source) and 1001 (LV node)
    else
        LINE(rr+1,1) = 1001; %LV node of Transformer
    end
    line_inc =  line_inc + 1000;
    rr = size(LINE,1);
end

% -----------------------Bus data starts-------------------------------

% Bus data format
% bus number, voltage(pu), angle(degree), P_gen(pu), Q_gen(pu),
% P_load(pu), Q_load(pu), G-shunt(pu), B-shunt(pu); bus_type
% bus_type - 1, swing bus
%          - 2, generator bus (PV bus)
%          - 3, load bus (PQ bus)

BUS(:,1) = unique(LINE(:,1:2));
BUS(:,2) = 1;
BUS(:,3:9) = 0;
BUS(:,10) = 3;

slack_indx = find(BUS(:,1)== 1000);

BUS(slack_indx,10) = 1; %Slack bus
BUS(slack_indx,2) = V_Source;%Slack bus

load_index_b = Loads.Bus(find(strcmp(Loads.phases, phase_selected)));

bus_inc = 1000; rr =0;
for pp=1:1:parallel_systems
    load_index (rr+1:rr+length(load_index_b),1) = load_index_b + bus_inc;
    bus_inc = bus_inc +1000;
    rr = length(load_index);
end

for tt=1:1:1440
    
    load_inc = 1;
    for ii=1:1:length(load_index)
        idx = find(BUS(:,1)==load_index(ii));
        BUS(idx,6) = (2*P0h(load_inc,tt) - SUN(tt) + EV(tt))./S_base;
        BUS(idx,7) = 2*Q0h(load_inc,tt)./S_base;
        load_inc = load_inc + 1;
        
    end
    LINE(906, 6) = 1/TAP(tt); %TAP ratio
    
    line_inc = 1000;
    for pp=1:1:parallel_systems
        N1 = line_inc + 118;
        N2 = line_inc +123;
        
        R_MFC = find(LINE(:,1) ==N1 & LINE(:,2) == N2);
        LINE(R_MFC, 6) = 1/MFC(tt);
        line_inc =  line_inc + 1000;
    end
    
    
    [bus_sol,line_sol,line_flow] = loadflow(BUS,LINE,1e-5,30,1,'n',1);
    tt
    
    VOLT(:,tt) = bus_sol(:,2);
    VOLT_ang(:,tt)  = bus_sol(:,3);
    
    PGEN(:,tt) = bus_sol(:,4);
    QGEN(:,tt) = bus_sol(:,5);
    PLOAD(:,tt) = bus_sol(:,6);
    QLOAD(:,tt) = bus_sol(:,7);
    
    PLINE(:,tt) = line_flow(:,4);
    QLINE(:,tt) = line_flow(:,5);
end