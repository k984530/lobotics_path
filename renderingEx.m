clc;
clear all;
close all;

% create figure
hfig = figure(20);
grid on;
axis([-2,25,-2,25])

% create line object
hMyCar = line(inf,inf);
set(hMyCar, 'linestyle', 'none', 'marker','o', 'markeredgecolor', ' k', ...
    'markerfacecolor', 'r' , 'markersize', 18)

x= 0;
y = 0;
vx = 0.01;
vy = 0.02;

% Let draw figure!
set(hMyCar, 'xdata', x, 'ydata', y);
T = 100;
for t=1:T
    x=x+vx;
    y=y+vy;
    set(hMyCar, 'xdata', x,'ydata',y);
    pause(0.05);
    drawnow;
end