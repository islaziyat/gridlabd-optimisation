[V,V0,fail, buses] = loadflow_gridlabd(2,2,2,0,0,0);
plot(1:37, V0);
% GA + simple gridlabd
x=[33.0000    3.0000    7.0000  284.2768  736.1620  269.9157];
Vgridlabd = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6));

% GA + MATLAB loadflow
x=[15.0000   29.0000   19.0000  435.6387  405.2138  178.2529];
[VloadflowGA,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6));

% PSO + MATLAB loadflow
x=[32.5107   16.9284    7.7978  273.4811  434.6674  363.5680];
[VloadflowPSO,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6));

plot(1:37, V0);
hold on;
plot(1:37, Vgridlabd);
plot(1:37, VloadflowGA);
plot(1:37, VloadflowPSO);
yline(1);
legend('original voltage profile', 'GA + gridlabd','GA + simple loadflow','PSO + simple loadflow','1 pu aim');
xlabel('bus number');
ylabel('Voltage (pu)');