%% read data
[a,b,c] = xlsread('C:\Users\Martin\Desktop\suny1.csv');

%% find start of each year in data series
s1 = min(find(strcmp('01/01/1998',b(:,1))));
s2 = min(find(strcmp('01/01/1999',b(:,1))));
s3 = min(find(strcmp('01/01/2000',b(:,1))));
s4 = min(find(strcmp('01/01/2001',b(:,1))));
s5 = min(find(strcmp('01/01/2002',b(:,1))));
s6 = min(find(strcmp('01/01/2003',b(:,1))));
s7 = min(find(strcmp('01/01/2004',b(:,1))));
s8 = min(find(strcmp('01/01/2005',b(:,1))));

%% average the years together
solar_avg = a(s1:s2-1,6) +a(s2:s3-1,6)+a(s3:s4-25,6)+a(s4:s5-1,6)+a(s5:s6-1,6)+a(s6:s7-1,6)+a(s7:s8-25,6)+a(s8-1:end,6);
solar_avg = solar_avg / 8;
plot(solar_avg)

%% average winter data over 20 days
solar_winter_day = zeros(24,1);
count = 0;
for i=1:24:480
    solar_winter_day = solar_winter_day + solar_avg(i:i+23);
    count = count + 1;
end

solar_winter_day = solar_winter_day./count;
solar_fit = fit([1:24]', solar_winter_day, 'gauss2');

for i=1:1:1440
    solar_winter_day(i) = solar_fit(i/60);
end
min(solar_winter_day)
figure
plot(solar_winter_day)
title('winter solar power');
grid on

%% average summer data over 20 days
solar_summer_day = zeros(24,1);
count = 0;
for i=3600:24:4080
    solar_summer_day = solar_summer_day + solar_avg(i:i+23);
    count = count + 1;
end

solar_summer_day = solar_summer_day./count;
solar_fit = fit([1:24]', solar_summer_day, 'gauss2');

for i=1:1:1440
    solar_summer_day(i) = solar_fit(i/60);
end
min(solar_summer_day)
figure
plot(solar_summer_day)
title('summer solar power');
grid on;

    