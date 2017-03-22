%% read data
[num, ~, ~] = xlsread('Loads.csv');

load_buses = num(:,2);

[num, ~, ~] = xlsread('Lines_EU.csv');

% lines: 1=from 2=to 3=length 4=resistance 5=reactance
lines = [num(:,1:2) num(:,4) num(:,8) num(:,9)];

%% process data
load_buses_distance = zeros(size(load_buses,1),3);

substation_bus = 1;

for i = 1:size(load_buses,1)
    curr_bus = load_buses(i);      % iterating bus
    curr_dst = 0;
    curr_res = 0;
    curr_rea = 0;
    
    while (curr_bus ~= substation_bus)
        temp_indx = find(curr_bus == lines(:,2));
        
        curr_dst = curr_dst + lines(temp_indx,3);
        curr_res = curr_res + lines(temp_indx,3)*lines(temp_indx,4);
        curr_rea = curr_rea + lines(temp_indx,3)*lines(temp_indx,5);
        curr_bus = lines(temp_indx,1);
    end
    
    load_buses_distance(i,1) = curr_dst;
    load_buses_distance(i,2) = curr_res + 1i*curr_rea;
    load_buses_distance(i,3) = abs(load_buses_distance(i,2));

end
% 1 = bus number, 2 = distance, 3 = impedance, 4 = impedance magnitude
load_buses_distance = [load_buses load_buses_distance];

%% play with data
figure
plot(load_buses_distance(:,1), load_buses_distance(:,2),'*');
figure
plot(load_buses_distance(:,1), load_buses_distance(:,4),'*');

load_buses_distance_ordered = sortrows(load_buses_distance, 2);

save load_buses_distance load_buses_distance