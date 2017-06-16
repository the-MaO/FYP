close all
clear all
%% constant current MFC
unc_onset =[17	16	15	14	14	13];
mfc_onset= [16	15	14	14	13	12];
x	=      [20	21	22	23	25	30];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, mfc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9];
mfc_onset= [20	15	13	10	8];
x=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7];
mfc_onset= [18	13	11	9	8	7	6];
x=[25	30	35	40	45	50	55];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14	14];
mfc_onset= [14	13	13	13	13	13	13	13	13	12];
x=[0.01	0.02 0.03	0.04	0.05	0.06	0.07	0.08	0.09	0.1];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('V_{mfc} [p.u.]');
legend('uncomp','MFC')
grid on
ylim([11.9 14.1])
xlim([0 0.11])

mtit('Constant current MFC')

%% constant current PoLC
unc_onset =[17	16	15	14	14	13];
polc_onset=[16	15	15	14	13	12];
x	=[20	21	22	23	25	30];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, polc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[21	16	14	11	9];
polc_onset=[21	16	13	10	8];
x=[1.60E-04	1.80E-04	2.00E-04	2.40E-04	2.80E-04];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[19	14	11	9	8	7	7];
polc_onset=[19	13	11	9	8	7	6];
x=[25	30	35	40	45	50	55];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('I_T [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[14	14	14	14	14	14	14	14	14];
polc_onset=[14	13	13	13	13	13	13	13	12];
x=[0.94	0.95	0.96	0.97	0.98	0.99	1	1.01	1.02];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('V_{PoLC} setpoint [p.u.]');
legend('uncomp','PoLC')
grid on
ylim([11.9 14.1])
xlim([0.93 1.03])

mtit('Constant current PoLC')

%% constant impedance MFC
unc_onset =[13 14	15	16	17	19];
mfc_onset= [12 13	13	14	15	17];
x	=      [30 29	28	27	26	25];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, mfc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[22 19 17 16 14 11];
mfc_onset= [19 17 15 14 12 10];
x=[1.9E-04	2.0E-04	2.1E-04	2.2E-04	2.4E-04	2.8E-04];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[10	11 12 14	16 19	22];
mfc_onset= [9	10 11 13	15 17	19];
x=[0.6	0.67 0.72 0.8	0.88 0.95 1];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_L [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[19	19	19	19	19	19	19];
mfc_onset= [17	17	17	17	17	16	16];
x=[0.02	0.03	0.04	0.05	0.06	0.07	0.1];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('V_{mfc} [p.u.]');
legend('uncomp','MFC')
grid on
xlim([0.01 0.11])
ylim([15.9 19.1])
mtit('Constant impedance MFC')

%% constant impedance PoLC
unc_onset =[13	14	15	16	17	19];
polc_onset=[13	13	14	15	17	19];
x	=[30	29	28	27	26	25];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, polc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[22	19	17	16	14	11	9];
polc_onset=[22	19	17	16	14	11	9];
x=[1.90E-04	2.00E-04	2.10E-04	2.20E-04	2.40E-04	2.80E-04	3.40E-04];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[8	10	12	14	17	22];
polc_onset=[8	9	12	14	17	22];
x=[0.5	0.6	0.7	0.8	0.9	1];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_L [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[19	19	19	19	19	19	19	19];
polc_onset=[19	19	19	18	18	18	18	18];
x=[0.94	0.95	0.96	0.97	0.98	0.99	1	1.01];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('V_{PoLC} setpoint [p.u.]');
legend('uncomp','PoLC')
grid on
xlim([0.93 1.02])
ylim([17.9 19.1])
mtit('Constant impedance PoLC')

%% constant power MFC
unc_onset =[15	15	16	17	19];
mfc_onset= [15	15	15	16	17];
x	=      [30	29	27	25	23];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, mfc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[20	18	17	16	15	12	10	8];
mfc_onset= [19	17	16	15	14	12	10	8];
x=[23	24	25	26	27	30	34	40];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('P_T [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[22	19	17	15	14	13	12	9];
mfc_onset= [20	18	16	15	14	13	12	9];
x=[1.80E-04	1.90E-04	2.00E-04	2.10E-04	2.20E-04	2.30E-04	2.40E-04	3.00E-04];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','MFC')
grid on

%-------------------------------
unc_onset =[17	17	17	17	17	17	17	17	17];
mfc_onset= [16	16	16	16	16	16	17	17	17];
x=[0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09	0.1];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, mfc_onset,'o-');
ylabel('onset node');
xlabel('V_{mfc} [p.u.]');
legend('uncomp','MFC')
grid on
xlim([0.01 0.11])
ylim([15.9 17.1])
mtit('Constant power MFC')

%% constant power PoLC
unc_onset =[15	15	16	17	19];
polc_onset=[15	15	16	17	18];
x	=[30	29	27	25	23];

figure
subplot(2,2,1);
plot(x, unc_onset./x*100,'o-')
hold on
plot(x, polc_onset./x*100,'o-')
ylabel('onset point [% of feeder]');
xlabel('N')
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[20	18	17	16	15	12	10	8];
polc_onset=[20	18	17	15	14	12	10	8];
x=[23	24	25	26	27	30	34	40];

subplot(2,2,2);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('P_T [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[22	19	17	15	14	13	12	9];
polc_onset=[22	18	17	15	14	13	12	9];
x=[1.80E-04	1.90E-04	2.00E-04	2.10E-04	2.20E-04	2.30E-04	2.40E-04	3.00E-04];

subplot(2,2,3);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('Z_N [p.u.]');
legend('uncomp','PoLC')
grid on

%-------------------------------
unc_onset =[17	17	17	17	17	17	17];
polc_onset=[17	17	16	16	16	16	16];
x=[0.94	0.95	0.96	0.97	0.98	0.99	1];

subplot(2,2,4);
plot(x, unc_onset, 'o-');
hold on
plot(x, polc_onset,'o-');
ylabel('onset node');
xlabel('V_{PoLC} setpoint [p.u.]');
legend('uncomp','PoLC')
grid on
xlim([0.93 1.01])
ylim([15.9 17.1])
mtit('Constant power PoLC')
