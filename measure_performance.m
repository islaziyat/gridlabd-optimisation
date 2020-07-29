function measure_performance(x)
    close;
    set_globals;
    establish_phase_connections();

    [Vinit,Imag,Psubstation,fail]  = loadflow_gridlabd(2,3,4,0,0,0,0,0,0);
    ploss1 = read_power_csv('underground_line_losses.csv');
    if surrey
        ploss11 = read_power_csv('overhead_line_losses.csv');
        ploss1 = ploss1 + ploss11;
    end

    [Vout,Imag,Psubstation,fail] = loadflow_gridlabd(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9));
    ploss2 = read_power_csv('underground_line_losses.csv');
    if surrey
        ploss21 = read_power_csv('overhead_line_losses.csv');
        ploss2 = ploss2 + ploss21;
    end
    
    Vout
    
    Imag
    
    Ploss_decrease = 100*(ploss1-ploss2)/ploss1;

    
    y1 = voltage_deviation(Vinit);
    y2 = voltage_deviation(Vout);

    decrease_deviation = 100*(y1-y2)/y1;
    
    
    disp('Optimisation solution:');
    fprintf('DG location | real power (kW) | reactive power (kVar)\n');
    fprintf('%f\t\t%f\t\t%f\n', ceil(x(1)), x(4),x(7));
    fprintf('%f\t\t%f\t\t%f\n', ceil(x(2)), x(5),x(8));
    fprintf('%f\t\t%f\t\t%f\n\n', ceil(x(3)), x(6),x(9));
%     fprintf('%f\t\t%f\t\t%f\n\n', ceil(x(10)), x(11),x(12));
    fprintf('Power loss in lines is now: %f\n', ploss2);
    fprintf('Voltage deviation index is now: %f\n\n', y2);
    fprintf('\nPercentage decrease in power loss: %f\n', Ploss_decrease); 
    fprintf('Decrease in phase deviation is: %f\n\n', decrease_deviation); 
    
%     fprintf('Average voltage is: %f\n\n', average); 
%     fprintf('standard deviation is: %f\n\n', stdv); 

    % Voltage stability index

    % ---------------------------------------------------------------------------------------------
%     Plot voltage profiles
    set(gcf, 'Position',  [400, 400, 700, 400])
    plot(1:length(Vinit), Vinit(:,:),'Color' , 'b');
    hold on;
    plot(1:length(Vout), Vout(:,:),'Color' , 'r');
    title('Voltage profile over 3-phases');
    ylabel('Voltage (pu)');
    xlabel('bus number');
    yline(1);
    legend('Phase A - no DG','Phase B - no DG','Phase C - no DG','Phase A - optimised','Phase B - optimised','Phase C - optimised','1 pu aim')

% 
%     set(gcf, 'Position',  [400, 50, 900, 900])
%     subplot(3,1,1);
%     plot(1:length(Vout), Vout(:,1));
% %     yline(1);
%     ylabel('Voltage A (pu)')
%     xlabel('bus number')
%     title('Voltage profiles (A, B and C) for different objectives')
%     hold on
%     
%     subplot(3,1,2);
%     plot(1:length(Vout), Vout(:,2));
% %     yline(1);
%     ylabel('Voltage B (pu)')
%     xlabel('bus number')
%     hold on
%     
%     subplot(3,1,3);
%     plot(1:length(Vout), Vout(:,3));
% %     yline(1);
%     ylabel('Voltage C (pu)')
%     xlabel('bus number')
    

%     [c, ceq] = nonlinear_constraint(x);
%     if max(c) > 0
%         disp('WARNING: constraints not all met');
%     else
%         disp('All constraints have been met');
%     end
    
end
