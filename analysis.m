%% set folder to analyse

folder = 'simulation270217/';
%% find lowest voltage in each situation and node where voltage problem starts

V_min = zeros(6,4,7);       % minimum voltage
bus_min = zeros(6,4,7);     % # of bus with minimum voltage
i=1;
j=1;
k=1;

eu_onset_bus = zeros(6,4,7);    % # of bus with undervoltage onset EU reg
uk_onset_bus = zeros(6,4,7);    % # of bus with undervoltage onset UK reg

V_lim_eu = 240 * 0.9;
V_lim_uk = 240 * 0.94;

for z = 0.4:0.2:1.6
    for s = 1:0.3:2.2
        for xr = 0.4:0.2:1.6
            % load data
            load_profile = 'summer weekday';
            filename = [folder load_profile 'S=' num2str(s) 'Z=' num2str(z) ...
                'XR=' num2str(xr) '.mat'];
            load(filename)
            % find minimum value and bus where it occurs
            [min_val, min_indx] = min(V_loads);
            [min_val, temp_indx] = min(min_val);
            min_indx = min_indx(temp_indx);
            % write values into result arrays
            V_min(i,j,k) = min_val;
            bus_min(i,j,k) = min_indx;
            
            % find violations by EU regulations
            [b, ~] = find(V_loads < V_lim_eu);
            if (isempty(b))
                eu_onset_bus(i,j,k) = -1;
            else
                eu_onset_bus(i,j,k) = min(b);
            end
            % find violations by UK regulations
            [b, ~] = find(V_loads < V_lim_uk);
            if (isempty(b))
                uk_onset_bus(i,j,k) = -1;
            else
                uk_onset_bus(i,j,k) = min(b);
            end
            
            k=k+1;
        end
        k = 1;
        j = j+1;
    end
    j = 1;
    i = i+1;
end
beep

violations_uk = V_min < (240 * 0.94);
violations_eu = V_min < (240 * 0.9);


%% plot lowest voltages varying one variable, keeping other two fixed
% nominal value indices: z = 4; s = 1; xr = 4;
% fixed xr, s
figure
plot_data = squeeze(V_min(:,1,4));
plot(0.85:0.05:1.1, plot_data, 'r')
% xlabel('Z multiplier');
ylabel('voltage [V]');
% fixed Z, XR
hold on
plot_data = squeeze(V_min(4,:,4));
plot(1:0.5:2.5, plot_data, 'g')
% xlabel('S multiplier');
% ylabel('voltage [V]');
% fixed S, Z

plot_data = squeeze(V_min(4,1,:));
plot(0.7:0.1:1.3, plot_data, 'b.')
% xlabel('X:R multiplier');
% ylabel('voltage [V]');
legend('variable Z','variable S','variable XR');
%% keep one var fixed, plot the other two
% nominal value indices: z = 4; s = 1; xr = 4;
% fixed xr
figure
plot_data = squeeze(V_min(:,:,4));
surf(1:0.5:2.5, 0.85:0.05:1.1, plot_data)
ylabel('Z multiplier');
zlabel('voltage [V]');
xlabel('S multiplier');
% fixed Z
figure
plot_data = squeeze(V_min(4,:,:));
surf(0.7:0.1:1.3, 1:0.5:2.5, plot_data)
ylabel('S multiplier');
zlabel('voltage [V]');
xlabel('XR multiplier');
% fixed S
figure
plot_data = squeeze(V_min(:,1,:));
surf(0.7:0.1:1.3, 0.85:0.05:1.1, plot_data)
xlabel('X:R multiplier');
zlabel('voltage [V]');
ylabel('Z multiplier');
