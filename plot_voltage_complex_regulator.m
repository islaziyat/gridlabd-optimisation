set(gcf, 'Position',  [100, 100, 700, 1000])
[V,V0,fail, buses] = loadflow_gridlabd(2,3,4,0,0,0);

% GA + simple gridlabd
x=[25.0000    9.0000   26.0000    2.9659    0.7892    1.0022];
[V,VPSO,fail, buses] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6));

% PSO + gridlabd loadflow
% x=[28   18   9  883.7942  192.5856  537.2358];
% [V,VPSO,fail, buses] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6));

subplot(3,1,1);
plot(1:37, V0(1:37,1));
hold on;
plot(1:37, VPSO(1:37,1));
yline(1);
title('Voltage for Phase A');
legend('original voltage profile', 'PS0 + gridlabd','1 pu aim','Location','southwest');
xlabel('bus number');
ylabel('Voltage (pu)');

subplot(3,1,2);
plot(1:37, V0(1:37,2));
hold on;
plot(1:37, VPSO(1:37,2));
yline(1);
title('Voltage for Phase B');
legend('original voltage profile', 'PS0 + gridlabd','1 pu aim','Location','southwest');
xlabel('bus number');
ylabel('Voltage (pu)');

subplot(3,1,3);
plot(1:37, V0(1:37,3));
hold on;
plot(1:37, VPSO(1:37,3));
yline(1);
title('Voltage for Phase C');
legend('original voltage profile', 'PS0 + gridlabd','1 pu aim','Location','southwest');
xlabel('bus number');
ylabel('Voltage (pu)');