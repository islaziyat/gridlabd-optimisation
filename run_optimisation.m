clear all;
global complex_grid gridlabd

% ---------------------------------------------------------------------------------------------
% % Use gridlabd or MATLAB model?
gridlabd = 0;
answer = questdlg('Use gridlabd? (default is MATLAB one-line diagram)', ...
	'Type of model', 'Yes', 'No', 'No');
if strcmp(answer,'Yes')==1 %Otherwise full 3 phase, untransposed, unbalanced model is used in gridlabd
    gridlabd = 1;
end

% ---------------------------------------------------------------------------------------------
% % Use one line diagram or detailed 3-phase gridlabd model?
if gridlabd == 1
    complex_grid = 0;
    answer = questdlg('Is this grid a one-line model? (default is 3-phase model)', ...
        'Type of grid', 'Yes', 'No', 'No');
    if strcmp(answer,'No')==1 %Otherwise full 3 phase, untransposed, unbalanced model is used in gridlabd
        complex_grid = 1;
    end
end

% ---------------------------------------------------------------------------------------------
% % Optimisation Tools:
%Setting for all
ObjectiveFunction = @objective;
nvars = 9; % Number of variables
LB = [2 2 2 0 0 0 -500 -500 -500]; % Lower bound
UB = [36 36 36 1000 1000 1000 500 500 500]; % Upper bound

% % GA solved
IntCon = [1 2 3];
options = optimoptions('ga');
options.MaxGenerations = 10;
% [x,fval, exitflag, output] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,@nonlinear_constraint,IntCon,options);
[x,fval, exitflag, output] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,[],IntCon,options);


% % Particle swarm
% options = optimoptions('particleswarm');
% options.MaxIterations = 10;
% [x,fval,exitflag,output] = particleswarm(ObjectiveFunction,nvars,LB,UB,options);

% ---------------------------------------------------------------------------------------------
% % Optimisation Outputs
[V,Theta,fail, buses] = loadflow_gridlabd(2,3,4,0,0,0);
Vpu = ones(length(V),1);
delta_V = abs(V-Vpu);
disp('Initially delta_V is:')
y = sum(delta_V)
disp('After optimisation delta_V is:')
fval
disp('x is:');
x


% ---------------------------------------------------------------------------------------------
% % Performance indeces

% Power loss in lines

% Voltage stability index



% ---------------------------------------------------------------------------------------------
% % EXTRAS
% % % FMINCON solved 
% ObjectiveFunction = @objective;
% LB = [2 2 2 0.1 0.1 0.1]; % Lower bound
% UB = [15 15 15 1 1 1]; % Upper bound
% % x0 = [5 2 5 0.1 0.1 0.1];
% % x0 = [3	6 10 0.5 0.5 0.5];
% % x0 = [5	10 15 0.5 0.3 0.1];
% % x0 = [3 7 12 0.3 0.3 0.3];
% x0 = [5 5 5 0.1 0.3 0.1];
% [x,fval, exitflag, output] = fmincon(ObjectiveFunction,x0,[],[],[],[],LB,UB);


