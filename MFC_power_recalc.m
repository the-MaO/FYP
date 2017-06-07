% compensated load buses with their index in 
comp_load_buses = [349,7;388,9;502,10;562,11;563,12;611,13;629,14;817,15;860,16;861,17;896,18;898,19;900,20;906,21];
num_comp_ld = size(comp_load_buses,1);

PLOAD_comp = PLOAD(comp_load_buses(:,1),:);
PLOAD_org = PLOAD_comp;

for i=1:num_comp_ld
    PLOAD_comp(i,:) = PLOAD_comp(i,:) .* ...
        (VOLT(comp_load_buses(i,1),:)./ uncVOLT(comp_load_buses(i,1),:)) .^ ...
        npt(comp_load_buses(i,2),:);
end
