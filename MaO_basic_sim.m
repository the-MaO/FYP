%% get ready
clear all;
clc
close all;

addpath('./loadflow_files');

%% import data and define constants
lines_EU = readtable('Lines_EU.csv');

loads = readtable('Loads.csv');     % change for own?
load('Load_Profiles_CRES/PQnpnq_winter_wd.mat');
load_profile = 'winter weekday';

V_base = 240;
S_base = 1e3;
Z_base = V_base^2/S_base;
V_src = 1;

phase_sel = 'A';
% loads.phases(:) = {'A'};

% load multiplier for changing load magnitude
S_mltp = 3;
% impedance multiplier for changing line impedance
Z_mltp = 1;
% X:R ratio multiplier for changing line X:R ratio (multiply only R, hence
% ratio changes
XR_mltp = 1;

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

%% calculate MFC taps or PoLC flow
MaO_MFC_compensation
MaO_PoLC_compensation

%% call script to run simulation and save data

% vary Z, S and X:R multipliers
% for z = 0.4:0.2:1.6
%     for s = 1:0.3:2.2
%         for xr = 0.4:0.2:1.6
%             
%             Z_mltp = z;
%             S_mltp = s;
%             XR_mltp = xr;
            
%             lines(1:(size(lines,1)-1),3) = lines_EU.Length .*lines_EU.R1/1000/Z_base*Z_mltp*XR_mltp;
%             lines(1:(size(lines,1)-1),4) = lines_EU.Length .*lines_EU.X1/1000/Z_base*Z_mltp;
            
            run_sim_save;
% 
%         end
%     end
% end

%% post simulation analysis
V_lim_uk_b = 0.94;
V_lim_uk_t = 1.1;

%------------------save simulation data --------------------------
savefolder = 's=3_mfc_at_Y_from_last_bus_basic';
mkdir([pwd '/' savefolder]);
save (['./' savefolder '/' filename '.mat'],...
    'VOLT', 'PLOAD', 'QLOAD', 'PGEN', 'QGEN', 'PLINE', 'QLINE')

load(['unc' filename '.mat']);
% ----------------------plot uncompensated voltages--------------------
figure
% MFC
boxplot(uncVOLT(mfc_load_buses,:)','Labels', num2cell(mfc_load_buses))
% PoLC
boxplot(uncVOLT(viol_load_buses(:,1),:)', ...
    'Labels',num2cell(viol_load_buses(:,1)));
%---
xlabel('load bus number');
ylabel('voltage p.u.');
hold on
plot(xlim,[0.94 0.94],'g');
plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
grid on

%-------------------------plot compensated voltages -----------------------
figure
% MFC
boxplot(VOLT(mfc_load_buses,:)','Labels', num2cell(mfc_load_buses))
% PoLC
boxplot(V_comp', 'Labels',num2cell(viol_load_buses(:,1)));
%---
xlabel('load bus number');
ylabel('voltage p.u.');
hold on
plot(xlim,[0.94 0.94],'g');
plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
grid on

ploting_netwrok_Updated
savefig(['./' savefolder '/map.fig']);

% -----------------calculate power saving in percent-------------
total_power_saving = (sum(sum(uncPGEN))-sum(sum(PGEN)))/(sum(sum(uncPGEN)))*100

%-----------calculate MFC (connected at line 279) rating----------------
S_mfc = sqrt(PLINE(279,:).^2 + QLINE(279,:).^2)
I_mfc = S_mfc*S_base./(VOLT(272,:) * V_base)
mfc_rating = max(I_mfc * range(MFC) * V_base)