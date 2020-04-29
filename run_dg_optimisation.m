clear all;
close all;
global complex_grid gridlabd IEEE37 multi obj_deviation regulator 

% Using IEEE37 grid. TO DO: make general for any grid
IEEE37 = 1;

% ---------------------------------------------------------------------------------------------
% % Use gridlabd or MATLAB model?
gridlabd = 0;
answer = questdlg('Use gridlabd? (otherwise MATLAB one-line diagram)', ...
	'Type of model', 'Yes', 'No', 'Yes');
if strcmp(answer,'Yes')==1 %Otherwise full 3 phase, untransposed, unbalanced model is used in gridlabd
    gridlabd = 1;
    disp('Using gridlabd');
else
    disp('Using MATLAB one line diagram');
end

% ---------------------------------------------------------------------------------------------
% % Use one line diagram or detailed 3-phase gridlabd model?
% if gridlabd == 1
%     complex_grid = 0;
%     answer = questdlg('Use 3-phase model? (otherwise one-line diagram)', ...
%         'Type of grid', 'Yes', 'No', 'Yes');
%     if strcmp(answer,'Yes')==1 
%         complex_grid = 1;
%         disp('Using 3-phase model');
%     else
%         disp('Using 3-phase balanced + transposable lines');
%     end
% end

complex_grid = 1;

% ---------------------------------------------------------------------------------------------
% % Grid with pre-existing voltage regulation or not?
answer = questdlg('Insert voltage regulator at bus 1 ?', ...
	'Regulator insertion', 'No', 'Yes', 'No');
if strcmp(answer,'Yes')==1 
    regulator = 1;
    disp('Grid with regulator');
else
    regulator = 0;
    disp('Grid without regulator');
end

% ---------------------------------------------------------------------------------------------
% % Multiple objective function or single?
multi = 0;
answer = questdlg('Use single or multiple objectives?', ...
	'Objectives', 'Multiple', 'Single', 'Multiple');
if strcmp(answer,'Multiple')==1 %Otherwise full 3 phase, untransposed, unbalanced model is used in gridlabd
    multi = 1;
        disp('Multi-objective optimisation and generation of pareto front');
        usega = 1;
else
    disp('Using single objective optimisation');
end
% ---------------------------------------------------------------------------------------------
% For single objective: choose tool and objective
if multi == 0
    answer = questdlg('Minimise voltage deviation or power loss?', ...
        'Choose single objective', 'voltage deviation', 'power loss', 'power loss');
    if strcmp(answer,'voltage deviation')==1 
        obj_deviation = 1;
        disp('Minimising voltage deviation...');
    else
        obj_deviation = 0;
        disp('Minimising power loss in lines...');
    end
    
    answer = questdlg('Use GA or PSO?', ...
	'Type of optimisation tool', 'GA', 'PSO', 'GA');
    if strcmp(answer,'GA')==1 
        usega = 1;
        disp('Using GA');
    else
        usega = 0;
        disp('Using PSO');
    end

end

% ---------------------------------------------------------------------------------------------
% Initialising and computing Original grid
establish_phase_connections();

% ---------------------------------------------------------------------------------------------
% % Optimisation Tools:
%Setting for all
ObjectiveFunction = @objective;
nvars = 9; % Number of variables
LB = [2 2 2 0 0 0 -500 -500 -500]; % Lower bound
UB = [36 36 36 1000 1000 1000 500 500 500]; % Upper bound

% % GA solved
IntCon = [1 2 3];

tic
if usega
    if multi == 0 %single objective
        options = optimoptions('ga');
        options.MaxGenerations = 10;
        options.PopulationSize = 200;
        [x,fval, exitflag, output] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,@nonlinear_constraint,IntCon,options);
    else %multiple objectives
        options = optimoptions('gamultiobj');
        options.MaxGenerations = 40;
        options.PlotFcn = @gaplotpareto;
        [x,fval, exitflag, output] = gamultiobj(ObjectiveFunction,nvars,[],[],[],[],LB,UB,@nonlinear_constraint,options);
    end
else
    % % Particle swarm
    options = optimoptions('particleswarm');
    options.MaxIterations = 10;
    options.SwarmSize = 200;
    [x,fval,exitflag,output] = particleswarm(ObjectiveFunction,nvars,LB,UB,options);
end
%record time of simulation
toc

% ---------------------------------------------------------------------------------------------
% % Optimisation Outputs
if multi == 0
    measure_performance(x)
%     res = [x y2 Ploss_decrease];
end


