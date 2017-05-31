ev_shape(1) = 0;
for i=1:14
    ev_shape(i+1) = 6e3/14*i;
end
for i=1:14
    ev_shape(i+15) = ev_shape(15) + 0.5e3/14*i;
end
ev_shape(30:270) = 6.5e3;
for i=1:29
    ev_shape(270+i) = ev_shape(270) - 6.5e3/29*i;
end
ev_shape(300:1440) = 0;

ev_shape1 = circshift(ev_shape, 1260);
ev_shape2 = circshift(ev_shape, 1320);
ev_shape3 = circshift(ev_shape, 1380);

% plot(0:1/60:24-1/60, ev_shape1)
% hold on
% plot(0:1/60:24-1/60, ev_shape2)
% plot(0:1/60:24-1/60, ev_shape3)