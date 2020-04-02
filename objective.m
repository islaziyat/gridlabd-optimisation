function y = objective(x)
global gridlabd multi obj_deviation
% x(1),x(2),x(3) is location of solar pv
% x(4),x(5),x(6) is real power of solar pv in kW
% x(7),x(8),x(9) is reactive power of solar pv in kW

% ---------------------------------------------------------------------------------------------
% % Using MATLAB (one line model with newton raphson)
if gridlabd == 0 
    [V,Psubstation,Y,fail] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9)); % With solar panels
    if fail == 1
        disp('Loadflow failed in MATLAB');
        return;
    end
    
    if obj_deviation
        Vpu = ones(length(V),1);
        delta_V = abs(V-Vpu);
        y = sum(delta_V);
    else
        y = read_power_csv('underground_line_losses.csv');
    end
    
% ---------------------------------------------------------------------------------------------
% % Using GridLAB-D
else
    [V,Imag,Theta,fail] = loadflow_gridlabd(ceil(x(1)),ceil(x(2)),ceil(x(3)),x(4),x(5),x(6),x(7),x(8),x(9));
    if fail == 1
        disp('Loadflow failed in gridlabd');
        return;
    end
    
    if multi == 0 % single objective
        if obj_deviation
            Vpu = ones(length(V),3);
            delta_V = abs(V-Vpu);
            y = sum(sum(delta_V));
        else
            y = read_power_csv('underground_line_losses.csv');
        end
        
    else % multi objective
        % Minimise voltage deviation
        Vpu = ones(length(V),3);
        delta_V = abs(V-Vpu);
        y(1) = sum(sum(delta_V));
        % Minimise power loss
        y(2) = read_power_csv('underground_line_losses.csv');
    end
end



end