% clear all; clc; close all;

%-----------------------------------------------------------
%Import EU LV Network Data
%----------------------------------------------------------
ftax = 14;
ft = 14;
mt = 15;

% figure(1)

set(groot, 'DefaultAxesFontName', 'Timesnewroman');
set(groot, 'DefaultUIControlFontName', 'Timesnewroman');

nodes_EU = readtable('Buscoords.csv');
Lines_EU = readtable('Lines_EU.csv');
%
% plot(nodes_EU.x, nodes_EU.y, '.k', 'MarkerSize',mt);
% hold on;
%
%  for ii=1:1:size(Lines_EU,1)
%     n1 = Lines_EU.Bus1(ii);
%     n2 = Lines_EU.Bus2(ii);
%     r1 = find(nodes_EU.Busname==n1);
%     r2 = find(nodes_EU.Busname==n2);
%
%     XX = [nodes_EU.x(r1)   nodes_EU.x(r2)];
%     YY = [nodes_EU.y(r1)   nodes_EU.y(r2)];
%     plot(XX,YY, '-k', 'LineWidth', 1.0);
%     hold on
%  end
% text(nodes_EU.x(1) - 10,nodes_EU.y(1)+7,'Substation', 'FontSize', ftax);
%
% set(gca, 'XTick', [], 'YTick', [])
% set(gca,'visible','off')
% box off
% hold off
% print -depsc2 system.eps
% print -dbmp system.bmp

figure

ftax = 7;
ft = 10;
mt = 10;
lw =1;

set(groot, 'DefaultAxesFontName', 'Timesnewroman');
set(groot, 'DefaultUIControlFontName', 'Timesnewroman');

plot(nodes_EU.x, nodes_EU.y, '.k', 'MarkerSize',mt);
hold on;

for ii=1:1:size(Lines_EU,1)
    n1 = Lines_EU.Bus1(ii);
    n2 = Lines_EU.Bus2(ii);
    r1 = find(nodes_EU.Busname==n1);
    r2 = find(nodes_EU.Busname==n2);
    
    XX = [nodes_EU.x(r1)   nodes_EU.x(r2)];
    YY = [nodes_EU.y(r1)   nodes_EU.y(r2)];
    plot(XX,YY, '-k', 'LineWidth', lw);
    hold on
end
text(nodes_EU.x(1)+2 ,nodes_EU.y(1)+7,'Substation', 'FontSize', ftax);

set(gca, 'XTick', [], 'YTick', []);

% all node numbers
% for i=1:size(nodes_EU,1)
%     text(nodes_EU.x(i) ,nodes_EU.y(i), ...
%         num2str(i), 'FontSize', ftax);
% end

% load node numbers
for i=1:size(load_indx,1)
    text(nodes_EU.x(load_indx(i))+1 ,nodes_EU.y(load_indx(i))+1, ...
        num2str(load_indx(i)), 'FontSize', ftax, 'Color', 'red');
end

% mfc node
% text(nodes_EU.x(bus2)+1,nodes_EU.y(bus2)+1,'MFC', 'FontSize', ftax);

% violated nodes numbers
for i=1:size(row,1)
    text(nodes_EU.x(row(i)) ,nodes_EU.y(row(i)), ...
        'O', 'FontSize', ftax, 'Color', 'blue');
end

% last common branch nodes
text(nodes_EU.x(272)+1 ,nodes_EU.y(272)+1, ...
    num2str(272), 'FontSize', ftax);

text(nodes_EU.x(280)+1 ,nodes_EU.y(280)+1, ...
    num2str(280), 'FontSize', ftax);









%set(gca,'visible','off');
%box off;

% load('NC.mat');
%
% %Red nodes
% VV = VOLT(2:907,:);
% nn=1;
% for ii=1:1:size(VV,1)
% VV_max(ii) = max(VV(ii,:));
% VV_min(ii) = min(VV(ii,:));
% end
%
%
%
% r_nodes = find(VV_max>1.1);
% r_nodes = r_nodes';
%
% b_nodes = find(VV_min<.94);
% b_nodes = b_nodes';
%
% for ii=1:1:length(r_nodes)
%     idx(ii) = find(nodes_EU.Busname== r_nodes(ii));
%
%     plot(nodes_EU.x(idx), nodes_EU.y(idx), '.r', 'MarkerSize',mt)
%
%    hold on
% end
%     idx = find(nodes_EU.Busname== 123);
%     plot(nodes_EU.x(idx), nodes_EU.y(idx), 's', 'MarkerSize',8, 'MarkerFaceColor', [0.603922 0.803922 0.196078])
%     text(nodes_EU.x(idx) -25,nodes_EU.y(idx)+8,'PEC for MFC', 'FontSize', ftax);
%     hold on
% title('(a) Over-voltage','FontSize',ft)
% sub_pos = get(gca,'position'); % get subplot axis position
% set(gca,'position',sub_pos.*[1 1 1.00 1.08]) % stretch its width and height
%
% subplot(2,1,2)
% %Blue Nodes
%
% set(groot, 'DefaultAxesFontName', 'Timesnewroman');
% set(groot, 'DefaultUIControlFontName', 'Timesnewroman');
%
%
% plot(nodes_EU.x, nodes_EU.y, '.k', 'MarkerSize',mt);
% hold on;
%
%  for ii=1:1:size(Lines_EU,1)
%     n1 = Lines_EU.Bus1(ii);
%     n2 = Lines_EU.Bus2(ii);
%     r1 = find(nodes_EU.Busname==n1);
%     r2 = find(nodes_EU.Busname==n2);
%
%     XX = [nodes_EU.x(r1)   nodes_EU.x(r2)];
%     YY = [nodes_EU.y(r1)   nodes_EU.y(r2)];
%     plot(XX,YY, '-k', 'LineWidth', lw);
%     hold on
%  end
% text(nodes_EU.x(1) +2,nodes_EU.y(1)+7,'Substation', 'FontSize', ftax);
%
% set(gca, 'XTick', [], 'YTick', [])
% %set(gca,'visible','off')
% %box off
%
%
% for ii=1:1:length(b_nodes)
%     idx = find(nodes_EU.Busname== b_nodes(ii));
%     plot(nodes_EU.x(idx), nodes_EU.y(idx), '.b', 'MarkerSize',mt)
%     hold on
% end
%
%     idx = find(nodes_EU.Busname== 123);
%     plot(nodes_EU.x(idx), nodes_EU.y(idx), 's', 'MarkerSize',8, 'MarkerFaceColor', [0.603922 0.803922 0.196078])
%     text(nodes_EU.x(idx) -25,nodes_EU.y(idx)+8,'PEC for MFC', 'FontSize', ftax);
%     hold on
%
% title('(b) Under-voltage','FontSize',ft)
% hold off
% sub_pos = get(gca,'position'); % get subplot axis position
% set(gca,'position',sub_pos.*[1 1 1.00 1.08]) % stretch its width and height
%
%
% %print('FIG7', '-depsc2', '-r600');
% print('system1', '-depsc2', '-r600');

