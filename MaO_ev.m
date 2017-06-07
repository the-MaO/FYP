ev_shape(1) = 0;
for i=1:14
    ev_shape(i+1) = 3e3/14*i;
end
for i=1:14
    ev_shape(i+15) = ev_shape(15) + 0.68e3/14*i;
end
ev_shape(30:270) = 3.68e3;
for i=1:29
    ev_shape(270+i) = ev_shape(270) - 3.68e3/29*i;
end
ev_shape(300:1440) = 0;

ev_shape1 = circshift(ev_shape', [1260,0])';
ev_shape2 = circshift(ev_shape', [1320,0])';
ev_shape3 = circshift(ev_shape', [1380,0])';
ev_shape3 = ev_shape3/3.68*6.5;
% ev_shape2 = ev_shape2/3.6*6.5;

% figure
% plot(0:1/60:24-1/60, ev_shape1, 'LineWidth', 2)
% hold on
% plot(0:1/60:24-1/60, ev_shape2, 'LineWidth', 2)
% plot(0:1/60:24-1/60, ev_shape3, 'LineWidth', 2)
% grid on
% title ('EV demand curves')
% xlabel('time [h]');
% ylabel('power [W]');
% legend ('shape 1', 'shape 2', 'shape 3');
