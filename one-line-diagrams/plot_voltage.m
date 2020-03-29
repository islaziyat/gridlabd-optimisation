global complex_grid
complex_grid = 0;
set(gcf, 'Position',  [100, 100, 900, 500])

%No DG installation - 0.3914
[V,theta,fail, buses] = loadflow_gridlabd(2,2,2,0,0,0);

% GA + simple gridlabd - 0.0155
x=[33.0000    3.0000    7.0000  284.2768  736.1620  269.9157];
Vgridlabd = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6));

% PSO + simple gridlabd - 0.0260
x=[36.0000    6.1182    2.0000  283.7244  611.0289  543.0789];
Vgridlabdpso = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6));

% GA + MATLAB loadflow
x=[15.0000   29.0000   19.0000  435.6387  405.2138  178.2529];
[VloadflowGA,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),0,0,0);

% PSO + MATLAB loadflow
x=[32.5107   16.9284    7.7978  273.4811  434.6674  363.5680];
[VloadflowPSO,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),0,0,0);

plot(1:37, V(1:37));
hold on;
plot(1:37, Vgridlabd);
plot(1:37, Vgridlabdpso);
plot(1:37, VloadflowGA);
plot(1:37, VloadflowPSO);
yline(1);
legend('original voltage profile', 'GA + gridlabd', 'PSO + gridlabd','GA + simple loadflow','PSO + simple loadflow','1 pu aim','Location','southeastoutside');
xlabel('bus number');
ylabel('Voltage (pu)');