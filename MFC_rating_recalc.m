% load('Load_Profiles_CRES/PQnpnq_winter_we.mat');
% load_profile = 'winter weekend';
load('Load_Profiles_CRES/PQnpnq_summer_wd.mat');
load_profile = 'summer weekday';

filename = [load_profile ' S=1'];
folder = 'PVEVOpSummer';

load (['./' folder '/unc' filename '.mat']);         %uncompensated
load (['./' folder '/polc/' filename '.mat']);         %compensated

S_base = 1e3;
V_base = 230;

% S_mfc = sqrt(PLINE(279,:).^2 + QLINE(279,:).^2);
% I_mfc = S_mfc*S_base./(VOLT(272,:) * V_base);
% mfc_rating = 2*max(I_mfc * 0.1 * V_base)

%----------------calculate losses----------------------------------------
% device_loss_pc = 0.02;
% device_loss = (mfc_rating * device_loss_pc)/sum(sum(abs(PGEN))) * 100
total_power_saving = (sum(sum(uncPGEN))-sum(sum(PGEN)))/(sum(sum(uncPGEN)))*100

cable_loss = sum(sum(PGEN) - sum(PLOAD))/sum(sum(abs(PGEN)))*100

uncCable_loss = sum(sum(uncPGEN) - sum(uncPLOAD))/sum(sum(abs(uncPGEN)))*100

pv_thruput = sum(sum(abs(PGEN(PGEN<0))) - sum(abs(uncPGEN(uncPGEN<0))))/...
    sum(sum(abs(uncPGEN(uncPGEN<0))))*100


comp_load_buses = [349,7;388,9;502,10;562,11;563,12;611,13;629,14;817,15;860,16;861,17;896,18;898,19;900,20;906,21];
num_of_loads = length(load_indx);

P0h_mfc = P0h(1:num_of_loads,:);

for i=1:size(comp_load_buses,1)
    P0h_mfc(comp_load_buses(i,2),:) = P0h_mfc(comp_load_buses(i,2),:) .* ...
        (VOLT(comp_load_buses(i,1),:) ./ uncVOLT(comp_load_buses(i,1),:)) .^(npt(comp_load_buses(i,2),:));
end

energy_saving = (sum(sum(P0h(1:num_of_loads,:))) - sum(sum(P0h_mfc)))/ ...
    sum(sum(P0h(1:num_of_loads,:)))*100

curt_pv = 5.0105e+04;           %summer

comp_pv = sum(sum(abs(PGEN(PGEN<0))));
incr_pv = (comp_pv - curt_pv)/60
incr_pv_pc = incr_pv*60/comp_pv*100

