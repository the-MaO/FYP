close all
clear all
%% constant current MFC
unc_onset =[17	16	15	14	14	13]
mfc_onset= [16	15	14	14	13	12]
N	=      [20	21	22	23	25	30]

figure
subplot(2,2,1);
plot(N, unc_onset./N*100,'o-')
hold on
plot(N, mfc_onset./N*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9]
mfc_onset= [20	15	13	10	8]
z=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04]

subplot(2,2,2);
plot(z, unc_onset, 'o-');
hold on
plot(z, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7]
mfc_onset= [18	13	11	9	8	7	6]
i=[25	30	35	40	45	50	55]

subplot(2,2,3);
plot(i, unc_onset, 'o-');
hold on
plot(i, mfc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14	14]
mfc_onset= [14	13	13	13	13	13	13	13	13	12]
v=[0.01	0.02 0.03	0.04	0.05	0.06	0.07	0.08	0.09	0.1]

subplot(2,2,4);
plot(v, unc_onset, 'o-');
hold on
plot(v, mfc_onset,'o-');
ylabel('onset node');
xlabel('V_{mfc} [p.u.]');
legend('uncomp','MFC')
grid on
ylim([11.9 14.1])
xlim([0 0.11])

%% constant current PoLC
unc_onset =[17	16	15	14	14	13]
polc_onset=[16	15	15	14	13	12]
N	=[20	21	22	23	25	30]

figure
subplot(2,2,1);
plot(N, unc_onset./N*100,'o-')
hold on
plot(N, polc_onset./N*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9]
polc_onset=[21	16	13	10	8]
z=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04]

subplot(2,2,2);
plot(z, unc_onset, 'o-');
hold on
plot(z, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7]
polc_onset=[19	13	11	9	8	7	6]
i=[25	30	35	40	45	50	55]

subplot(2,2,3);
plot(i, unc_onset, 'o-');
hold on
plot(i, polc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14]
polc_onset=[14	13	13	13	13	13	13	13	12]
v=[0.94	0.95	0.96	0.97	0.98	0.99	1	1.01	1.02]

subplot(2,2,4);
plot(v, unc_onset, 'o-');
hold on
plot(v, polc_onset,'o-');
ylabel('onset node');
xlabel('V_{PoLC} setpoint [p.u.]');
legend('uncomp','PoLC')
grid on
ylim([11.9 14.1])
xlim([0.93 1.03])
%% constant current
unc_onset =[17	16	15	14	14	13]
mfc_onset= [16	15	14	14	13	12]
N	=      [20	21	22	23	25	30]

figure
subplot(2,2,1);
plot(N, unc_onset./N*100,'o-')
hold on
plot(N, mfc_onset./N*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9]
mfc_onset= [20	15	13	10	8]
z=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04]

subplot(2,2,2);
plot(z, unc_onset, 'o-');
hold on
plot(z, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7]
mfc_onset= [18	13	11	9	8	7	6]
i=[25	30	35	40	45	50	55]

subplot(2,2,3);
plot(i, unc_onset, 'o-');
hold on
plot(i, mfc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14	14]
mfc_onset= [14	13	13	13	13	13	13	13	13	12]
v=[0.01	0.02 0.03	0.04	0.05	0.06	0.07	0.08	0.09	0.1]

subplot(2,2,4);
plot(v, unc_onset, 'o-');
hold on
plot(v, mfc_onset,'o-');
ylabel('onset node');
xlabel('V_{mfc} [p.u.]');
legend('uncomp','MFC')
grid on
ylim([11.9 14.1])
xlim([0 0.11])

%% constant current PoLC
unc_onset =[17	16	15	14	14	13]
polc_onset=[16	15	15	14	13	12]
N	=[20	21	22	23	25	30]

figure
subplot(2,2,1);
plot(N, unc_onset./N*100,'o-')
hold on
plot(N, polc_onset./N*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9]
polc_onset=[21	16	13	10	8]
z=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04]

subplot(2,2,2);
plot(z, unc_onset, 'o-');
hold on
plot(z, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7]
polc_onset=[19	13	11	9	8	7	6]
i=[25	30	35	40	45	50	55]

subplot(2,2,3);
plot(i, unc_onset, 'o-');
hold on
plot(i, polc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14]
polc_onset=[14	13	13	13	13	13	13	13	12]
v=[0.94	0.95	0.96	0.97	0.98	0.99	1	1.01	1.02]

subplot(2,2,4);
plot(v, unc_onset, 'o-');
hold on
plot(v, polc_onset,'o-');
ylabel('onset node');
xlabel('V_{PoLC} setpoint [p.u.]');
legend('uncomp','PoLC')
grid on
ylim([11.9 14.1])
xlim([0.93 1.03])