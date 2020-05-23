function plot_pareto(x)
set_globals
disp('Globals being set...')
len = length(x);
establish_phase_connections();

for r = 1:len
    [Vout,Imag,Psubstation,fail] = loadflow_gridlabd(x(r,1),x(r,2),x(r,3),x(r,4),x(r,5),x(r,6),x(r,7),x(r,8),x(r,9));
    y2 = voltage_deviation(Vout);
    ploss2 = read_power_csv('underground_line_losses.csv');
    plot(y2,ploss2,'x');
    textin = strcat(num2str(r) , '[', num2str(ceil(x(r,1))), ', ',num2str(ceil(x(r,2))), ', ',num2str(ceil(x(r,3))), ' ]');
    text(y2,ploss2,textin,'FontSize',6);
    hold on;
    pause(0.1)
end

title("Pareto Front")
% xlabel("Voltage deviation index")
xlabel("Average voltage")
ylabel("Power loss in lines (W)")
end

% 46885.700000
% 2.287293