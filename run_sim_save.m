%% run the simulation
for time=1:1440
    
    curr_load = 1;
    
    % assign load to load buses for this time instant
    for j=1:length(load_indx)
        indx = find(bus(:,1) == load_indx(j));
        
        % -----------------normal operation
%         bus(indx,6) = S_mltp * P0h(curr_load,time) / S_base;
%         bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
        % ------------------------add solar panels
%         bus(indx,6) = (P0h(curr_load,time) - 2*solar_winter_day(time)) / S_base;
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
%         if (mod(j,2) == 0)
%             bus(indx,6) = S_mltp * (P0h(curr_load,time)- 2*solar_winter_day(time)) / S_base;
%             bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%         else
%             if (mod(j,6) == 1)
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape1(time)- 2*solar_winter_day(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             elseif(mod(j,6) == 3)
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape2(time)- 2*solar_winter_day(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             else
%                 bus(indx,6) = S_mltp * (P0h(curr_load,time) + ev_shape3(time)- 2*solar_winter_day(time)) / S_base;
%                 bus(indx,7) = S_mltp * Q0h(curr_load,time) / S_base;
%             end
%         end
        
        %----------- for PoLC------------------
                bus(indx,6) = S_mltp * P0h_polc(curr_load,time) / S_base;
                bus(indx,7) = S_mltp * Q0h_polc(curr_load,time) / S_base;
        %-----------------------------
        
        curr_load = curr_load + 1;
    end
    
    % --------------set MFC tap ratio--------------------
%         bus1 = 272;                 % buses found manually from MFC calculations
%         bus2 = 280;
%         mfc_line = find(lines(:,1) == bus1 & lines(:,2) == bus2);
%         lines(mfc_line, 6) = MFC(time);
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
%% extract, save and plot data
% get data at load locations
V_loads = VOLT(load_indx,:);
V_ang_loads = VOLT_ang(load_indx,:);
P_loads = PLOAD(load_indx,:) .* S_base;
Q_loads = QLOAD(load_indx,:) .* S_base;

filename = [load_profile ' S=' num2str(S_mltp) ''];
uncfolder = 'EVOpWinter';

% %---save uncompensated values----
% S.('uncVOLT') = VOLT;
% S.('uncPLOAD') = PLOAD;
% S.('uncQLOAD') = QLOAD;
% S.('uncPGEN') = PGEN;
% S.('uncQGEN') = QGEN;
% S.('uncPLINE') = PLINE;
% S.('uncQLINE') = QLINE;
% save(['./' uncfolder '/unc' filename '.mat'], '-struct', 'S');
% %------------------------------

% figure
% boxplot(V_loads','Labels',num2cell(load_indx))
% xlabel('load bus number');
% ylabel('voltage p.u.');
% title(filename);
% savefig([filename '.fig']);
% grid on
% plot(xlim,[0.94 0.94],'g');
% plot(xlim,[1.1 1.1],'g');
% ylim([0.94 1.1])

