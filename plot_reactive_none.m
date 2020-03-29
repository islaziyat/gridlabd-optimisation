global complex_grid
complex_grid = 0;

% x = [29.0000    7.0000   17.0000  731.9837  595.1860  516.3693 -454.6422    2.1532 -296.0265];
% [VQ,theta,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
% voltage_deviation(VQ)
% 
% x=[17.0000   16.0000   34.0000  472.2689  319.8677  247.1791];
% [V,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),0,0,0);
% voltage_deviation(V)

x = [29.0000    7.0000   17.0000  0 0 0 0 0 0];
[V0,theta,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
voltage_deviation(V0)

x = [29.0000    7.0000   17.0000  0 0 0 -500 -500 -500];
[VQ,theta,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
voltage_deviation(VQ)

x = [29.0000    7.0000   17.0000  0 0 0 500 500 500];
[V,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
voltage_deviation(V)


plot(1:37, V0);
hold on;
plot(1:37, VQ);
plot(1:37, V);
yline(1);
legend('one', '-react', '+react','Location','southeastoutside');
xlabel('bus number');
ylabel('Voltage (pu)');