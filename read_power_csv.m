function Ploss = read_power_csv(power_file)
    m = csvread('underground_line_losses.csv',9,1);
    Ploss = sum(m);   
end
