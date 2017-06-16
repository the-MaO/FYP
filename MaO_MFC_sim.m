%% get ready
tic
clear all;
clc
close all;

addpath('./loadflow_files');

%% import data and define constants
lines_EU = readtable('Lines_EU.csv');

loads = readtable('Loads.csv');     % change for own?
load('Load_Profiles_CRES/PQnpnq_winter_we.mat');
load_profile = 'winter weekend';
% load('Load_Profiles_CRES/PQnpnq_summer_wd.mat');
% load_profile = 'summer weekday';


V_base = 230;
S_base = 1e3;
Z_base = V_base^2/S_base;
V_src = 1;

phase_sel = 'A';
% loads.phases(:) = {'A'};

% load multiplier for changing load magnitude
S_mltp = 1;
% impedance multiplier for changing line impedance
Z_mltp = 1;
% X:R ratio multiplier for changing line X:R ratio (multiply only R, hence
% ratio changes
XR_mltp = 1;

uncfolder = 'PVEVOpWinter';
filename = [load_profile ' S=' num2str(S_mltp) ''];
load([uncfolder '/unc' filename '.mat']);
savefolder = 'PVEVOpWinter/mfc_new';


%% define lines
% --- format ---
% 1 from bus | 2 to bus | 3 resistance pu | 4 reactance pu
% 5 line charging pu | 6 tap ratio | 7 phase shift

lines(:,1) = lines_EU.Bus1;
lines(:,2) = lines_EU.Bus2;
lines(:,3) = lines_EU.Length .*lines_EU.R1/1000/Z_base*Z_mltp*XR_mltp;
lines(:,4) = lines_EU.Length .*lines_EU.X1/1000/Z_base*Z_mltp;
lines(:,5) = lines_EU.Length .*lines_EU.C1/1000/Z_base;
lines(:,6) = 1;
lines(:,7) = 0;

% line to connect transformer between bus 1000 (source) and 1 (LV)
lines(size(lines,1)+1,:) = [1000 1 0.4/800/3 4/800/3 0 1 0];

%% define buses
% --- format ---
% 1 bus number | 2 voltage pu | 3 angle deg | 4 P gen pu | 5 Q gen pu
% 6 P load pu | 7 Q load pu | 8 G shunt pu | 9 B shunt pu | 10 bus type
% bus types: 1-swing bus; 2-gen bus (PV bus); 3-load bus (PQ)

bus(:,1) = unique(lines(:,1:2));
bus(:,2) = 1;
bus(:,3:9) = 0;
bus(:,10) = 3;

% define slack bus
slck_indx = find(bus(:,1) == 1000);
bus(slck_indx, 10) = 1;
bus(slck_indx, 2) = V_src;

% find indices of buses with loads
if exist('phase_sel', 'var') % single phase was selected
    load_indx = loads.Bus(find(strcmp(loads.phases, phase_sel)));
else
    load_indx = loads.Bus;
end

%% calculate MFC taps

load solar.mat
MaO_ev
MaO_MFC_compensation

%% run first simulation to get compensated voltages
for time=1:1440
    
    curr_load = 1;
    
    % assign load to load buses for this time instant
    for j=1:length(load_indx)
        indx = find(bus(:,1) == load_indx(j));
        
        % -----------------normal operation
%         bus(indx,6) = S_mltp * P0h(curr_load,time) / S_base;
%         bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        % ------------------------add PV
%         bus(indx,6) = (P0h(curr_load,time) - 8*solar_summer_day(time)) / S_base;
%         bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        % ----------------------add EVs to every second house
%         if (mod(j,2) == 0)
%             bus(indx,6) = S_mltp * P0h(curr_load,time) / S_base;
%             bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%         else
%             if (mod(j,6) == 1)
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape1(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             elseif(mod(j,6) == 3)
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape2(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             else
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape3(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             end
%         end
        % ---------------------PV and EV
        if (mod(j,2) == 0)
            bus(indx,6) = S_mltp * (P0h(curr_load,time)- 8*solar_winter_day(time)) / S_base;
            bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        else
            if (mod(j,6) == 1)
                bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape1(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            elseif(mod(j,6) == 3)
                bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape2(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            else
                bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape3(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            end
        end
%         
        curr_load = curr_load + 1;
    end
    
    % --------------set MFC tap ratio--------------------
        bus1 = 272;                 % buses found manually from MFC calculations
        bus2 = 280;
        mfc_line = find(lines(:,1) == bus1 & lines(:,2) == bus2);
        lines(mfc_line, 6) = MFC(time);
    % ---------------------------------------------------
    
    % loadflow(bus,line,tol,iter_max,acc,display,flag)
    [bus_sol,line_sol,line_flow] = loadflow(bus,lines,1e-5,30,1,'n',1);
    
    VOLT(:,time) = bus_sol(:,2);
    VOLT_ang(:,time)  = bus_sol(:,3);
    
    PGEN(:,time) = bus_sol(:,4);
    QGEN(:,time) = bus_sol(:,5);
    PLOAD(:,time) = bus_sol(:,6);
    QLOAD(:,time) = bus_sol(:,7);
    
    PLINE(:,time) = line_flow(:,4);
    QLINE(:,time) = line_flow(:,5);
    
    time
end

beep;

%% recalculate power to compensated loads
comp_load_buses = [349,7;388,9;502,10;562,11;563,12;611,13;629,14;817,15;860,16;861,17;896,18;898,19;900,20;906,21];
num_of_loads = length(load_indx);

P0h_mfc = P0h(1:num_of_loads,:);
Q0h_mfc = Q0h(1:num_of_loads,:);

for i=1:size(comp_load_buses,1)
    P0h_mfc(comp_load_buses(i,2),:) = P0h_mfc(comp_load_buses(i,2),:) .* ...
        (VOLT(comp_load_buses(i,1),:) ./ uncVOLT(comp_load_buses(i,1),:)) .^(npt(comp_load_buses(i,2),:));
    Q0h_mfc(comp_load_buses(i,2),:) = Q0h_mfc(comp_load_buses(i,2),:) .* ...
        (VOLT(comp_load_buses(i,1),:) ./ uncVOLT(comp_load_buses(i,1),:)).^(nqt(comp_load_buses(i,2)));
end

%% re-run the simulation with new load values
for time=1:1440
    
    curr_load = 1;
    
    % assign load to load buses for this time instant
    for j=1:length(load_indx)
        indx = find(bus(:,1) == load_indx(j));
        
        % -----------------normal operation
%         bus(indx,6) = S_mltp * P0h_mfc(curr_load,time) / S_base;
%         bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
        % ------------------------add PV
%         bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) - 8*solar_summer_day(time)) / S_base;
%         bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
        % ----------------------add EVs to every second house
%         if (mod(j,2) == 0)
%             bus(indx,6) = S_mltp * P0h_mfc(curr_load,time) / S_base;
%             bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
%         else
%             if (mod(j,6) == 1)
%                 bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape1(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
%             elseif(mod(j,6) == 3)
%                 bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape2(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
%             else
%                 bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape3(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h_mfc(curr_load,time) / S_base;
%             end
%         end
        % ---------------------PV and EV
        if (mod(j,2) == 0)
            bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time)- 8*solar_winter_day(time)) / S_base;
            bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        else
            if (mod(j,6) == 1)
                bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape1(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            elseif(mod(j,6) == 3)
                bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape2(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            else
                bus(indx,6) = (S_mltp * P0h_mfc(curr_load,time) + ev_shape3(time)- 8*solar_winter_day(time)) / S_base;
                bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
            end
        end
%         
        curr_load = curr_load + 1;
    end
    
    % --------------set MFC tap ratio--------------------
        bus1 = 272;                 % buses found manually from MFC calculations
        bus2 = 280;
        mfc_line = find(lines(:,1) == bus1 & lines(:,2) == bus2);
        lines(mfc_line, 6) = MFC(time);
    % ---------------------------------------------------
    
    % loadflow(bus,line,tol,iter_max,acc,display,flag)
    [bus_sol,line_sol,line_flow] = loadflow(bus,lines,1e-5,30,1,'n',1);
    
    VOLT(:,time) = bus_sol(:,2);
    VOLT_ang(:,time)  = bus_sol(:,3);
    
    PGEN(:,time) = bus_sol(:,4);
    QGEN(:,time) = bus_sol(:,5);
    PLOAD(:,time) = bus_sol(:,6);
    QLOAD(:,time) = bus_sol(:,7);
    
    PLINE(:,time) = line_flow(:,4);
    QLINE(:,time) = line_flow(:,5);
    
    time
end

beep;

%% post simulation analysis
V_lim_uk_b = 0.94;
V_lim_uk_t = 1.1;

%------------------save simulation data --------------------------

mkdir([pwd '/' savefolder]);
save (['./' savefolder '/' filename '.mat'],...
    'VOLT', 'PLOAD', 'QLOAD', 'PGEN', 'QGEN', 'PLINE', 'QLINE')

% ----------------------plot uncompensated voltages--------------------
figure
% MFC
boxplot(uncVOLT(load_indx,:)','Labels', num2cell(load_indx))
%---
xlabel('load bus number');
ylabel('voltage p.u.');
title('Uncompensated voltages');
hold on
plot(xlim,[0.94 0.94],'g');
plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
grid on
savefig(['./' savefolder '/uncVoltages.fig']);

%-------------------------plot compensated voltages -----------------------
figure
% MFC
boxplot(VOLT(load_indx,:)','Labels', num2cell(load_indx))
%---
xlabel('load bus number');
ylabel('voltage p.u.');
title('Compensated voltages');
hold on
plot(xlim,[0.94 0.94],'g');
plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
grid on
savefig(['./' savefolder '/voltages.fig']);

% ploting_netwrok_Updated
% savefig(['./' savefolder '/map.fig']);

%---------------plot bus 906 voltage for optical check
figure
plot(VOLT(906,:))           %MFC
hold on
plot(uncVOLT(906,:))
grid on
legend('compensated','uncompensated')
title('bus 906 voltage')
savefig(['./' savefolder '/bus906.fig']);


% -----------------calculate power saving in percent-------------
total_power_saving = (sum(sum(uncPGEN))-sum(sum(PGEN)))/(sum(sum(uncPGEN)))*100

%-----------calculate MFC (connected at line 279) rating----------------
S_mfc = sqrt(PLINE(279,:).^2 + QLINE(279,:).^2)
I_mfc = S_mfc*S_base./(VOLT(272,:) * V_base)
mfc_rating = max(I_mfc * range(MFC) * V_base)

%----------------calculate losses----------------------------------------
comp_loss = (sum(sum(PGEN)) - sum(sum(PLOAD)))/sum(sum(PGEN))*100
device_loss_pc = 0.02;
device_loss = (mfc_rating * device_loss_pc)/sum(sum(PGEN)) * 100
total_loss = comp_loss + device_loss

%--------------plot total power flow in/out of the feeder---------------
figure
plot(0:1/60:24-1/60,PGEN(907,:));
subs_pwr = PGEN(907,:);
pwr_out = sum(subs_pwr(subs_pwr<0))
pwr_in = sum(subs_pwr(subs_pwr>0))
xlabel('time [hr]');
ylabel('power [kW]');
hold on
plot(0:1/60:24-1/60,sum(PLOAD,1));
legend('power from substation','power to all loads');
title('compensated power flow')
grid on
savefig(['./' savefolder '/powerflow.fig']);

figure
plot(0:1/60:24-1/60,uncPGEN(907,:));
uncsubs_pwr = uncPGEN(907,:);
uncpwr_out = sum(uncsubs_pwr(uncsubs_pwr<0))
uncpwr_in = sum(uncsubs_pwr(uncsubs_pwr>0))
xlabel('time [hr]');
ylabel('power [kW]');
hold on
plot(0:1/60:24-1/60,sum(uncPLOAD,1));
legend('power from substation','power to all loads');
title('uncompensated power flow')
grid on
savefig(['./' savefolder '/uncpowerflow.fig']);

figure
plot(0:1/60:24-1/60,uncPGEN(907,:)-PGEN(907,:));
xlabel('time [hr]');
ylabel('power [kW]');
title('power flow difference (uncompensated - compensated)')
grid on
savefig(['./' savefolder '/powerflowdiff.fig']);

%----------------write metrics into text file----------------------
fileId = fopen(['./' savefolder '/resultsmfc.txt'], 'w');
desc_txt = ['MFC before fork, tap calculated from flow at MFC bus\r\n' ...
     'mfc setpoint flow, rating +-5%%\r\n'];

% MFC
text_mfc = [desc_txt 'Device rating  %7.2f W\r\n' ...
    'Energy saved %5.5f%%\r\n' ...
    'Total loss %1.4f%% in cable %1.4f%% in device %1.4f%%'];
fprintf(fileId,text_mfc, mfc_rating, total_power_saving, total_loss, comp_loss, device_loss);

fclose(fileId);

toc