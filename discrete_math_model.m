%% initialisation
clear all;
clc;
close all;

% ------parameters------------
It = 28;        % It, Z and N taken from simulation of my feeder
Z = 10e-5;
N = 55;
Vs = 1;
Vl = 0.94;
%-----------------------------

%% constant current
% total drop on whole feeder (for check)
% delVN = Z*It*(N+1)/2;

% drop at branch k
CI_delVk = @(k) Z*It/N*k*(N-(k-1)/2);

% branch at which drop is delV
delV = Vs - Vl;
branch = @(delV) round((N+0.5) - sqrt((N+0.5)^2-(2*N*delV)/(Z*It)));
onseti = real(branch(delV));

% current in feeder
currentsi = zeros(1,N);
currentsi(1) = It;
currentsi(2) = It;
% current to loads
ldcuri = zeros(1,N);

% feeder voltages
voltagesi = zeros(1,N);
voltagesi(1) = Vs;

% calaculate feeder voltages and both currents
for i=2:N
    drop = CI_delVk(i-1);
    voltagesi(i) = Vs - drop;
    
    currentsi(i+1) = It*(1-(i-1)/N);
    ldcuri(i-1) = currentsi(i-1) - currentsi(i);
end
% last load current is whatever is left in feeder
ldcuri(N) = currentsi(N);
% last element is removed because in loop i+1 is calculated
currentsi = currentsi(1:end-1);

%plot results
subplot(2,1,1);
plot(voltagesi, 'b.');
vline(onseti,'b')
grid on
hold on

subplot(2,1,2);
plot(currentsi,'b.');
hold on
plot(ldcuri, 'k');
grid on

%% constant impedance
% voltage drop function
sumVz = 0;
CZ_delVk = @(sumVz) Z*It*(1 - 1/(Vs*N)*sumVz);

% vector of feeder voltages
voltagesz = zeros(1,N);
voltagesz(1) = Vs;
voltagesz(2) = Vs - Z*It;
onsetz = 0;         % voltage problem onset bus

% vector of feeder current
currentsz = zeros(1,N);
currentsz(1) = It;
currentsz(2) = It;

% currents going to loads
ldcurz = zeros(1,N);

% calculate voltages and currents
for i = 3:N
    % voltage sum for drop calculation, can sum to end because vector initiated with 0s
    sumVz = sum(voltagesz(2:end)); 
    
    voltagesz(i) = voltagesz(i-1) - CZ_delVk(sumVz);
    if voltagesz(i) > Vl
        onsetz = i;     % get undervoltage onset bus
    end
    
    currentsz(i) = CZ_delVk(sumVz)/Z;
    ldcurz(i-1) = currentsz(i-1)-currentsz(i);
    
end
%last load current is whatever is left in feeder
ldcurz(N) = currentsz(N);

%check loads are constant impedance
% imp = voltagesz./ldcurz;
% range(imp(2:end-1))

% plot results
subplot(2,1,1);
plot(voltagesz, 'r.')
vline(onsetz,'r');
xlabel('branch number k');
ylabel('voltage pu');
title(['N = ' num2str(N) ', Z = ' num2str(Z) ', It = ' num2str(It)]);

subplot(2,1,2);
plot(currentsz, 'r.');
plot(ldcurz, 'm');
xlabel('branch number k');
ylabel('feeder current pu');
% plot(imp,'m.');

%% constant power
% voltage drop function
sumVp = 0;
CP_delVk = @(sumVp) Z*It*(1 - Vs/N*sumVp);
onsetp = 0;             % voltage problem onset bus

% feeder voltage vector
voltagesp = zeros(1,N);
voltagesp(1) = Vs;
voltagesp(2) = Vs - Z*It;

%feeder  current vector
currentsp = zeros(1,N);
currentsp(1) = It;
currentsp(2) = It;

% current into loads
ldcurp = zeros(1,N);

for i = 3:N
    % sum for drop calculation, sum to i-1 to avoid division by 0
    sumVp = sum(1./voltagesp(2:i-1));
    
    voltagesp(i) = voltagesp(i-1) - CP_delVk(sumVp);
    % get undervoltage onset bus
    if voltagesp(i) > Vl
        onsetp = i;     
    end
    currentsp(i) = CP_delVk(sumVp)/Z;
    ldcurp(i-1) = currentsp(i-1)-currentsp(i);
end
% current into last load
ldcurp(N) = currentsp(N);

% check all loads are constant power
% pow = voltagesp.*ldcurp;
% range(pow(2:end-1));

% plot results
subplot(2,1,2);
plot(currentsp, 'g.');
plot(ldcurp, 'c');
% plot(pow, 'c.')
subplot(2,1,1);
plot(voltagesp, 'g.')
vline(onsetp,'g')

legend('constant current','constant impedance','constant power');

%% MFC rating calculation
%CI
delVN = voltagesi(onseti) - voltagesi(end); % voltage drop at onset location = MFC location
MFCi = delVN * currentsi(onseti)    % multiply by feeder current at that location

%CZ
delVN = voltagesz(onsetz) - voltagesz(end);
MFCz = delVN * currentsz(onsetz)

%CP
delVN = voltagesp(onsetp) - voltagesp(end);
MFCp = delVN * currentsp(onsetp)

%% PoLC rating calculation
% because of the wrong load current in last branch, this will be 
% approximated by the branch before it

%CI
delVi = Vl - voltagesi(onseti+1:end)    %undervoltages that need to be corrected
poli = delVi.*ldcuri(onseti+1:end)      %multiply by current into the loads
poli(end) = delVi(end)*ldcuri(end-1);   %correct the last element
politot = sum(poli)                     %sum to get total PoLC rating

%CZ
delVz = Vl - voltagesz(onsetz+1:end)
polz = delVz.*ldcurz(onsetz+1:end)
polz(end) = delVz(end)*ldcurz(end-1);
polztot = sum(polz)

%CZ
delVp = Vl - voltagesp(onsetp+1:end)
polp = delVp.*ldcurp(onsetp+1:end)
polp(end) = delVp(end)*ldcurp(end-1);
polptot = sum(polp)