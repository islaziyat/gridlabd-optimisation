clear all;
close all;
global complex_grid gridlabd IEEE37 multi obj_deviation regulator

IEEE37 = 1;
% Multiple objective function or single?
multi = 1;
if multi
    disp('Multi-objective optimisation and generation of pareto front');
end

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
if gridlabd == 1
    complex_grid = 0;
    answer = questdlg('Use 3-phase model? (otherwise one-line diagram)', ...
        'Type of grid', 'Yes', 'No', 'Yes');
    if strcmp(answer,'Yes')==1 
        complex_grid = 1;
        disp('Using 3-phase model');
    else
        disp('Using 3-phase balanced + transposable lines');
    end
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

answer = questdlg('Minimise voltage deviation or power loss?', ...
	'Objective', 'voltage deviation', 'power loss', 'power loss');
if strcmp(answer,'voltage deviation')==1 
    obj_deviation = 1;
    disp('Minimising voltage deviation...');
else
    obj_deviation = 0;
    disp('Minimising power loss in lines...');
end

answer = questdlg('Insert regulator?', ...
	'Regulator insertion', 'Yes', 'No', 'No');
if strcmp(answer,'Yes')==1 
    regulator = 1;
    disp('Grid with regulator');
else
    regulator = 0;
    disp('Grid without regulator');
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

tic
if usega
    if multi == 0 %single objective
        options = optimoptions('ga');
        options.MaxGenerations = 10;
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
    [x,fval,exitflag,output] = particleswarm(ObjectiveFunction,nvars,LB,UB,options);
end
%record time of simulation
toc

% ---------------------------------------------------------------------------------------------
% % Optimisation Outputs
if multi == 0
    if gridlabd
        [Vinit,Imag,Psubstation,fail]  = loadflow_gridlabd(2,3,4,0,0,0,0,0,0);
        ploss1 = read_power_csv('underground_line_losses.csv');

        [Vout,Imag,Psubstation,fail] = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
        ploss2 = read_power_csv('underground_line_losses.csv');
    else
        [V,Psubstation,Y,fail, buses] = solve_loadflow(2,2,2,0,0,0,0,0,0);
        [Vout,Psubstation,Y,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
    end
    disp('Total voltage deviation with no DG is:')
    y = voltage_deviation(Vinit)
    disp('After optimisation delta_V is:')
    y = voltage_deviation(Vout)
    disp('x is:');
    x

    % ---------------------------------------------------------------------------------------------
    % % Performance indeces

    if gridlabd
        disp('Percentage decrease in power loss:')
        Ploss_decrease = 100*(ploss1-ploss2)/ploss1
    end

    % Voltage stability index



    % ---------------------------------------------------------------------------------------------
    % Plot voltage profiles
    plot(1:length(Vinit), Vinit);
    hold on;
    plot(1:length(Vout), Vout);
    ylabel('Voltage (pu)')
    xlabel('bus number')
    title('Voltage profile over 3-phases')
    legend('Phase A - no DG','Phase B - no DG','Phase C - no DG','Phase A - optimised','Phase B - optimised','Phase C - optimised')
    legend('Phase A - no DG','Phase B - no DG','Phase C - no DG','Phase A - optimised','Phase B - optimised','Phase C - optimised','Location','southwestoutside')
    legend('Phase A - no DG','Phase B - no DG','Phase C - no DG','Phase A - optimised','Phase B - optimised','Phase C - optimised','Location','southeastoutside')

    [c, ceq] = nonlinear_constraint(x);
    if max(c) > 0
        disp('WARNING: constraints not all met');
    else
        disp('All constraints have been met');
    end
end
