
%Generates EV profile 
EV = zeros(1,1440);

timeStep =40;
t0 = 1;
EV(t0:t0+timeStep) = 500;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 350;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 250;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 300;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 150;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 200;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 250;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 250;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 200;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 150;
t0 = t0+timeStep;

% midday no demand because noone is home
EV(1260:1440) = 500;
 
timeStep =40;
t0 = 1260;
EV(t0:t0+timeStep) = 100;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 200;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 300;
t0 = t0+timeStep;
EV(t0:t0+timeStep) = 400;
t0 = t0+timeStep;
EV(t0:1440) = 500;

EV = smooth(EV,20);
EV = smooth(EV, 30);
EV = 4.0*EV';
plot(0:(24/1440):23.99, EV)