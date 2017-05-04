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
dVx_ccl = dVx(x);

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
syms x L di I ix dVx delVx Z a Vs Vl
di = I/L;
ix(x) = I - x*di;
dVx(x) = Z*ix;

delVx = simplify(int(dVx,x));

x1 = simplify(solve(delVx == (Vs - Vl),x));

Imfc = simplify(ix(x1));

%% constant power loads - symbolic math from notebook
clear
clc
syms Vx Z It Vs L x delVx dVx

syms f x a b c s
laplace(f + int(a/f) - b - c*x,x,s)
dVx = Z*It*(1-Vs/L/Vx)
delVx = simplify(int(dVx,x))
Vx = Vs - delVx

%% costant impedance plot
clear
clc
close all
Vs = 1;
Z = 1e-5;
It = 20;
L = 300;
x = 1:1:L;
% Vx(x) = Vs - Z^2*It^2/Vs/L - Z*It*x + Vs*L/Z/It*(exp(-Vs*L*x/Z/It)*(Z^3*It^3/Vs^2/L^2 - Z*It/L + Vs))
Vx(x) = Vs*L - Vs*L/Z/It*(exp(Z*It*x/Vs/L)*(Z*It-Z*It/L))
plot(x,Vx)