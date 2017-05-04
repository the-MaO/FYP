%% initialisation
clear all;
clc;
close all;

% ------parameters------------
It = 28;
Z = 10e-5;
N = 55;
Vs = 1;
Vl = 0.94;
%-----------------------------

%% constant current
% total drop on whole feeder (for check)
delVN = Z*It*(N+1)/2

% drop at branch k
CI_delVk = @(k) Z*It/N*k*(N-(k-1)/2);

% branch at which drop is delV
delV = Vs - Vl;
branch = @(delV) floor((N+0.5) - sqrt((N+0.5)^2-(2*N*delV)/(Z*It)));
onseti = real(branch(delV))

% plot profile on feeder
voltages = zeros(1,N);
voltages(1) = Vs;
for i=2:N
    drop = CI_delVk(i-1);
    voltages(i) = Vs - drop;
end
plot(voltages, 'b.');
hold on
vline(onseti,'b')
grid on

%% constant impedance
% voltage drop function
sumVz = 0;
CZ_delVk = @(sumVz) Z*It*(1 - 1/(Vs*N)*sumVz);

% vector of feeder voltages
voltagesz = zeros(1,N);
voltagesz(1) = Vs;
voltagesz(2) = Vs - Z*It;
onsetz = 0;

% vector of feeder current
currentsz = zeros(1,N);
currentsz(1) = It;
currentsz(2) = It;

% currents going to loads
ldcurz = zeros(1,N);

for i = 3:N
    sumVz = sum(voltagesz(2:end));
    voltagesz(i) = voltagesz(i-1) - CZ_delVk(sumVz);
    if voltagesz(i) > Vl
        onsetz = i;     % get undervoltage onset bus
    end
    
    currentsz(i) = CZ_delVk(sumVz)/Z;
    ldcurz(i-1) = currentsz(i-1)-currentsz(i);
    
end
imp = voltagesz./ldcurz;
range(imp(2:end-1))

currentsz(end)

yyaxis left
plot(voltagesz, 'r.')
yyaxis right
plot(ldcurz, 'r*');
% plot(imp,'m.');
vline(onsetz,'r');

%% constant power
% voltage drop function
sumVp = 0;
CP_delVk = @(sumVp) Z*It*(1 - Vs/N*sumVp);
onsetp = 0;

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
    sumVp = sum(1./voltagesp(2:i-1));
    voltagesp(i) = voltagesp(i-1) - CP_delVk(sumVp);
    if voltagesp(i) > Vl
        onsetp = i;     % get undervoltage onset bus
    end
    currentsp(i) = CP_delVk(sumVp)/Z;
    ldcurp(i-1) = currentsp(i-1)-currentsp(i);
end

pow = voltagesp.*ldcurp;
range(pow(2:end-1))

currentsp(end)

yyaxis right
plot(ldcurp, 'g*');
% plot(pow, 'c.')
yyaxis left
plot(voltagesp, 'g.')
vline(onsetp,'g')

legend('constant current','constant impedance','constant power');