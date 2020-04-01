function [c, ceq] = nonlinear_constraint(x)
global gridlabd IEEE37

% % imposes constraint that the voltage should be between 0.95 and 1.05
if gridlabd == 0
    % Using MATLAB (one line model with newton raphson
    [V,theta,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9)); % With solar panels
else
    % Using gridlabd (one line model with newton raphson)
    [V,I,Psubstation,fail, buses] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6));
end
c(1:length(V')) = V' - 1.05*ones(1,length(V'));
d(1:length(V')) = 0.95*ones(1,length(V'))-V';

e = [];

% Current limits for IEEE37
if IEEE37 == 1 && gridlabd == 1
    Imax = load('Imax_IEEE37.mat');
    Imax =  Imax.Imax_IEEE37;
    Imax = [Imax; Imax; Imax];
    e(1:length(I')) = I' - Imax';
end

% reverse power flow constraint
f = -sum(real(Psubstation));

c = [c d e f];
ceq=[];
end