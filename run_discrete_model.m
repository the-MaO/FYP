% run discrete model in loop and write results to excel for analysis
It = 28;
Z = 10e-5;
N = 55;
Vs = 1;
Vl = 0.94;

sheet = 2;
range = 'A1';
% write header
header = [{'It'} 'Z' 'N' {'onset CI'} {'onset CZ'} {'onset CP'} {'MFC CI'} {'MFC CZ'} ...
    {'MFC CP'} {'PoL CI'} {'PoL CZ'} {'PoL CP'}];
xlswrite('discreteMathTesting.xlsx', header, sheet, range);

% run model in loop to produce results
r = 2;
for It = 25:5:75
    discrete_math_model
    range = ['A' num2str(r)];
    r = r+1;
    op = [It Z N onseti onsetz onsetp MFCi MFCz MFCp politot polztot polptot];
    xlswrite('discreteMathTesting.xlsx', op, sheet, range);
end

    