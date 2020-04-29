function measure_performance(x)

    [Vinit,Imag,Psubstation,fail]  = loadflow_gridlabd(2,3,4,0,0,0,0,0,0);
    ploss1 = read_power_csv('underground_line_losses.csv');

    [Vout,Imag,Psubstation,fail] = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
    ploss2 = read_power_csv('underground_line_losses.csv');
    
    Ploss_decrease = 100*(ploss1-ploss2)/ploss1;
    fprintf('\nPercentage decrease in power loss: %f\n', Ploss_decrease); 
    
    y1 = voltage_deviation(Vinit);
    y2 = voltage_deviation(Vout);
    
    decrease_deviation = 100*(y1-y2)/y1;
    fprintf('Decrease in phase deviation is: %f\n\n', decrease_deviation); 
    
    disp('Optimisation solution:');
    fprintf('DG location | real power (kW) | reactive power (kVar)\n');
    fprintf('%f\t\t%f\t\t%f\n', ceil(x(1)), x(4),x(7));
    fprintf('%f\t\t%f\t\t%f\n', ceil(x(2)), x(5),x(8));
    fprintf('%f\t\t%f\t\t%f\n\n', ceil(x(3)), x(6),x(9));
   
    % Voltage stability index

    % ---------------------------------------------------------------------------------------------
    % Plot voltage profiles
    set(gcf, 'Position',  [400, 400, 900, 500])
    plot(1:length(Vinit), Vinit);
    hold on;
    plot(1:length(Vout), Vout);
    ylabel('Voltage (pu)')
    xlabel('bus number')
    yline(1);
    title('Voltage profile over 3-phases')
    legend('Phase A - no DG','Phase B - no DG','Phase C - no DG','Phase A - optimised','Phase B - optimised','Phase C - optimised','1 pu aim','Location','southeastoutside')

    [c, ceq] = nonlinear_constraint(x);
    if max(c) > 0
        disp('WARNING: constraints not all met');
    else
        disp('All constraints have been met');
    end
    
end
