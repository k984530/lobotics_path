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

x= zeros(100,2);

vx1 = 0.05;
vx2 = 1.0;
omega = 0.1;

finT = 1000;
for t=1:finT
    x(t+1,1) = x(t,1) + vx1;
    x(t+1,2) = x(t,2) + vx2*sin(omega*t);
end

figure(2)
plot(x(:,1),x(:,2))

xx = x(:,1);
yy = x(:,2);
T = 1000;

for t=1:T
    set(hMyCar, 'xdata', xx(t), 'ydata', yy(t));
    pause(0.05);
    drawnow;
end