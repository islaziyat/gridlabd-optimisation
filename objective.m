function y = objective(x)
global gridlabd multi
% x(1),x(2),x(3) is location of solar pv
% x(4),x(5),x(6) is real power of solar pv in kW
% x(7),x(8),x(9) is reactive power of solar pv in kW

if gridlabd == 0
    % Using MATLAB (one line model with newton raphson
    [V,theta,fail,buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9)); % With solar panels
    if fail == 1
        disp('Loadflow failed in MATLAB');
        return;
    end
else
    % Using gridlabd (one line model with newton raphson)
    [V,Imag,Theta,fail, buses] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6));
    if fail == 1
        disp('Loadflow failed in gridlabd');
        return;
    end
end

if multi == 0 % single objective
    Vpu = ones(length(V),1);
    delta_V = abs(V-Vpu);
    y = sum(delta_V);
else % multi objective
    % Minimise voltage deviation
    Vpu = ones(length(V),1);
    delta_V = abs(V-Vpu);
    y(1) = sum(delta_V);
    % Minimise power loss
    y(2) = read_power_csv('underground_line_losses.csv');
end

end