%% run the simulation
for time=1:1440
    
    curr_load = 1;
    
    % assign load to load buses for this time instant
    for j=1:length(load_indx)
        indx = find(bus(:,1) == load_indx(j));
        
        bus(indx,6) = S_mltp * P0h(curr_load,time) / S_base;
        bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        
        curr_load = curr_load + 1;
    end
    
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
end

beep;
%% extract, save and plot data
% get data at load locations
V_loads = VOLT(load_indx,:) .* V_base;
V_ang_loads = VOLT_ang(load_indx,:) .* V_base;
P_loads = PLOAD(load_indx,:) .* S_base;
Q_loads = QLOAD(load_indx,:) .* S_base;

filename = [load_profile 'S=' num2str(S_mltp) 'Z=' num2str(Z_mltp) ...
    'XR=' num2str(XR_mltp)];

save ([filename '.mat'], 'V_loads', 'V_ang_loads', 'P_loads', 'Q_loads', 'PGEN')

figure
mesh(V_loads)
xlabel('time [min]');
ylabel('load no.');
zlabel('voltage [V]');
title(filename);
savefig([filename '.fig']);
close all;