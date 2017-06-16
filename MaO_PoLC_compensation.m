%% get load buses with voltage violation
% load uncompensated flow data and get violated buses
V_lim_uk = 0.94;
% violations = uncVOLT < V_lim_uk;
% [viol_buses, ~] = find(violations);
% viol_buses = unique(viol_buses);
% min(viol_buses)

% find violated load buses and their indices in load_indx (=indices in P0h)
% num_of_loads = length(load_indx);
% viol_load_buses = intersect(load_indx,viol_buses);
% for i=1:length(viol_load_buses)
%     viol_load_buses(i,2) = find(viol_load_buses(i,1) == load_indx);
% end
% if no buses violated, still compensate the buses after fork (ideal MFC place)
comp_load_buses = [349,7;388,9;502,10;562,11;563,12;611,13;629,14;817,15;860,16;861,17;896,18;898,19;900,20;906,21];
num_of_loads = length(load_indx);

%% calculate new P and Q for PoLC loads
% create new load P and Q matrices
P0h_polc = P0h(1:num_of_loads,:);
Q0h_polc = Q0h(1:num_of_loads,:);

% calculate new load bus voltages
polc_rating = 0.05;
V_comp = uncVOLT(comp_load_buses(:,1),:);
V_polc = V_comp;
% figure
% plot(V_comp(end,:))
% hold on

V_comp(abs(V_comp-V_setpt)<=polc_rating) = V_setpt;
% plot(V_comp(end,:))
V_comp((V_comp-V_setpt)>polc_rating) = V_comp((V_comp-V_setpt)>polc_rating) - polc_rating;
% plot(V_comp(end,:))
V_comp((V_setpt-V_comp)>polc_rating) = V_comp((V_setpt-V_comp)>polc_rating) + polc_rating;
% plot(V_comp(end,:))
% PoLC device voltage
V_polc = V_comp - V_polc;

% for debug
% figure
% boxplot(V_comp','Labels',num2cell(viol_load_buses(:,1)));
% xlabel('load bus number');
% ylabel('voltage p.u.');
% hold on
% plot(xlim,[0.94 0.94],'g');
% plot(xlim,[1.1 1.1],'g');
% ylim([0.935 1.105])
% grid on

% calculate load powers with changed voltage
for i=1:size(comp_load_buses,1)
    P0h_polc(comp_load_buses(i,2),:) = P0h_polc(comp_load_buses(i,2),:) .* ...
        (V_comp(i,:) ./ uncVOLT(comp_load_buses(i,1),:)) .^(npt(comp_load_buses(i,2),:));
    Q0h_polc(comp_load_buses(i,2),:) = Q0h_polc(comp_load_buses(i,2),:) .* ...
        (V_comp(i,:) ./ uncVOLT(comp_load_buses(i,1),:)).^(nqt(comp_load_buses(i,2)));
end

energy_saving = (sum(sum(P0h(1:num_of_loads,:))) - sum(sum(P0h_polc)))/ ...
    sum(sum(P0h(1:num_of_loads,:)))*100
% add EV/PV
% ------- EV case ---------------
% for j=1:num_of_loads
%     if (mod(j,2) == 0)
%         P0h_polc(j,:) = P0h_polc(j,:);
%     else
%         if (mod(j,6) == 1)
%             P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape1);
%         elseif(mod(j,6) == 3)
%             P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape2);
%         else
%             P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape3);
%         end
%     end
% end
% ------------------------------------------------------------
% ---------------PV and EV case
for j=1:num_of_loads
    if (mod(j,2) == 0)
        P0h_polc(j,:) = P0h_polc(j,:) - 8*solar_summer_day';
    else
        if (mod(j,6) == 1)
            P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape1- 8.*solar_summer_day');
        elseif(mod(j,6) == 3)
            P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape2- 8.*solar_summer_day');
        else
            P0h_polc(j,:) = (P0h_polc(j,:) + ev_shape3- 8.*solar_summer_day');
        end
    end
end
% ---------------PV case
% for j=1:num_of_loads
%       P0h_polc(j,:) = P0h_polc(j,:) - 8*solar_winter_day';
% end


S_comp = sqrt(P0h_polc.^2 + Q0h_polc.^2);

I_polc = S_comp(comp_load_buses(:,2),:)./(V_base.*V_comp);
S_polc = abs(2*V_base*polc_rating*I_polc);
% figure
% boxplot(S_polc')
% title('PoLC power in W');
total_polc_rating = 2*sum(max(S_polc,[],2))