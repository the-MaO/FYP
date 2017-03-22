%% define variables and load data
s = 1.6;
xr = 1;
z = 1;

V_lim_eu = 240 * 0.9;
V_lim_uk = 240 * 0.94;

load load_buses_distance;

% load dataset
load_profile = 'winter weekday';
filename = [load_profile 'S=' num2str(s) 'Z=' num2str(z) ...
    'XR=' num2str(xr) '.mat'];

load(filename);

%% find violations by EU regulation
% [bus, time] = find(V_loads < V_lim_eu);
% 
% [~, temp] = min(bus);
% 
% V_data = V_loads(:,time(temp));
% 
% plot_data = [load_buses_distance V_data];
% figure
% plot (plot_data(:,2), plot_data(:,end), '.');
% hold on;
% plot (plot_data(:,2), ones(size(plot_data,1))*V_lim_eu, 'r');
% title(['Worst violation by EU regulations, S=' num2str(s) ', Z=' num2str(z) ...
%     ', XR=' num2str(xr) ' fist viol. bus ' num2str(plot_data((min(bus)),1))]);
% xlabel('Distance from substation [m]');
% ylabel('Voltage [V]');
% 
% % plot by impedance distance
% figure
% plot (plot_data(:,4), plot_data(:,end), '.');
% hold on;
% plot (plot_data(:,4), ones(size(plot_data,1))*V_lim_eu, 'r');
% title(['Worst violation by EU regulations, S=' num2str(s) ', Z=' num2str(z) ...
%     ', XR=' num2str(xr) ' fist viol. bus ' num2str(plot_data((min(bus)),1))]);
% xlabel('Total cable impedance [\Omega]');
% ylabel('Voltage [V]');

%% find violation by UK regulation
[bus, time] = find(V_loads < V_lim_uk);

[~, temp] = min(bus);

V_data = V_loads(:,time(temp));

plot_data = [load_buses_distance V_data];
figure
plot (plot_data(:,2), plot_data(:,end), '.');
hold on;
plot (plot_data(:,2), ones(size(plot_data,1))*V_lim_uk, 'r');
title(['Worst violations by UK regulations, S = ' num2str(s) ', Z=' num2str(z) ...
    ', XR=' num2str(xr) ' fist viol. bus ' num2str(plot_data(min(bus),1))]);
xlabel('Distance from substation [m]');
ylabel('Voltage [V]');

% plot by impedance distance
% figure
% plot (plot_data(:,4), plot_data(:,end), '.');
% hold on;
% plot (plot_data(:,4), ones(size(plot_data,1))*V_lim_uk, 'r');
% title(['Worst violation by UK regulations, S=' num2str(s) ', Z=' num2str(z) ...
%     ', XR=' num2str(xr) ' fist viol. bus ' num2str(plot_data((min(bus)),1))]);
% xlabel('Total cable impedance [\Omega]');
% ylabel('Voltage [V]');

%% theoretical voltage drop
% calculate average Z of the line
Z_tot = sum(abs(lines_EU.R1 .* lines_EU.Length + 1i .* lines_EU.X1 .* lines_EU.Length));
length = sum(lines_EU.Length);
Z = Z_tot/length
Z = Z/Z_base

I_t = PGEN(907,temp);
L = max(load_buses_distance(:,2));
x = 0:0.1:L;
emp_factor = 3e-3;

V_x = VOLT(1,temp) - emp_factor*(Z*I_t*(x - x.^2/(2*L)));
V_x = V_x * V_base;

plot (x, V_x, 'g');