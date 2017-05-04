%% define variables and load data
s = 1.6;
xr = 1;
z = 1;
emp_factor = 3


V_lim_eu = 240 * 0.9;
V_lim_uk = 240 * 0.94;

load load_buses_distance;

% load dataset
load_profile = 'winter weekday';
filename = [load_profile 'S=' num2str(s) 'Z=' num2str(z) ...
    'XR=' num2str(xr) '.mat'];

load(filename);

close all;

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

[~, iterator] = min(bus);
I_all = [];
for iterator = 1:100:1440
    V_data = V_loads(:,time(iterator));
    
    plot_data = [load_buses_distance V_data];
    figure
    plot (plot_data(:,2), plot_data(:,end), '.');
    hold on;
    plot (plot_data(:,2), ones(size(plot_data,1))*V_lim_uk, 'r');
    title(['Worst violations by UK regulations, S = ' num2str(s) ', Z=' num2str(z) ...
        ', XR=' num2str(xr) ' time ' num2str(iterator)]);
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
    Z_tot = sum(abs(lines_EU.R1 .* lines_EU.Length + 1i .* lines_EU.X1 .* lines_EU.Length));
    length = sum(lines_EU.Length);
    Z = Z_tot/length/1e3;
    Z = Z/Z_base;
    
    I_t = PGEN(907,iterator)
%     I_t_alt = sum(PLOAD(:,iterator)./VOLT(:,iterator));
    I_all = [I_all I_t];
    L = max(load_buses_distance(:,2));
    x = 0:0.1:L;
    
%     V_x = VOLT(1,iterator) - (Z*I_t*(x - x.^2/(2*L)));
%     plot_data(end,end)
%     V_x(end) * V_base
    
%     V_x = VOLT(7,iterator) - emp_factor * (Z*I_t_alt*(x - x.^2/(2*L)));
%     V_x = V_x * V_base;
%     
%     plot (x, V_x, 'g');
end