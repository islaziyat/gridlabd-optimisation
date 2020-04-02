function [c, ceq] = nonlinear_constraint(x)
global gridlabd IEEE37 complex_grid

%initialise 
c = [];
d = [];
e = [];
f = [];

% ---------------------------------------------------------------------------------------------
% % Using MATLAB (one line model with newton raphson)
if gridlabd == 0
    [V,Psubstation,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9)); 

    
    
% ---------------------------------------------------------------------------------------------
% % Using GridLAB-D
else
    [V,I,Psubstation,fail] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6),x(7),x(8),x(9));

% Voltage limits: 0.95 - 1.05 pu
buses = length(V);
V = [V(1:length(V),1); V(1:length(V),2); V(1:length(V),3)];

% Current limits for IEEE37
    I = [I(1:length(I),1); I(1:length(I),2); I(1:length(I),3)];
    if IEEE37 == 1 
        Imax = load('Imax_IEEE37.mat');
        Imax =  Imax.Imax_IEEE37;
        if complex_grid == 1
            Imax = [Imax; Imax; Imax];
        end
        e(1:length(I')) = I' - Imax';

% reverse power flow constraint
        f = -sum(real(Psubstation));
    end
    
end

% ---------------------------------------------------------------------------------------------
% % Voltage limits: imposes constraint that the voltage should be between 0.95 and 1.05
c(1:length(V')) = V' - 1.05*ones(1,length(V'));
d(1:length(V')) = 0.95*ones(1,length(V'))-V';

c = [c d e f];
ceq=[];

end