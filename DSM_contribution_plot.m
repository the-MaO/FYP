load('C:\Users\Martin\Desktop\FYP stuff\Simulations\EVOpWinter\polc_DSM\winter weekend S=1.mat')
pgendsm = PGEN(907,:)
load('C:\Users\Martin\Desktop\FYP stuff\Simulations\EVOpWinter\polc\winter weekend S=1.mat')
figure
plot(0:1/60:24-1/60, PGEN(907,:) - pgendsm)
grid on
hold on
xlabel('time [hr]')
ylabel('power [kW]')
title('Compensated power flow change with CVR, EV, winter')
load('C:\Users\Martin\Desktop\FYP stuff\Simulations\EVOpWinter\mfc_DSM_new\winter weekend S=1.mat')
pgendsm = PGEN(907,:)
load('C:\Users\Martin\Desktop\FYP stuff\Simulations\EVOpWinter\mfc_new\winter weekend S=1.mat')
plot(0:1/60:24-1/60, PGEN(907,:) - pgendsm)
legend('PoLC','MFC')