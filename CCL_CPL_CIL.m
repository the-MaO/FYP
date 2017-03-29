clc;
clear variables;
close all;
%% dummy definitions of feeder constants (all pu)
I = 20;
L = 300;
di = I/L;
step = 0.01;
x = 0:step:L;
Z = 1e-5;

%% constant current loads, even distribution
ix = I - x.*di;
dVx = @(x) Z*ix.*x;
dVx_cil = dVx(x);

% yyaxis left
% plot(x, dVx_cil)
% hold on
% yyaxis right
% plot(x, ix,'r')
% legend('dVx','ix')

for ii=1:length(L)
    delVx(ii) = integral(dVx,0,ii*step);
end

%% symbolic maths
clear variables;
clc
syms x L di I ix dVx delVx Z
di = I/L;
ix = @(x) I - x*di;
dVx = @(x) Z*ix;

delVx = simplify(int(dVx,x));

