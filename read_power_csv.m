function Ploss = read_power_csv(power_file)
    m = csvread(power_file,9,1);
    Ploss = sum(m(1,:));   
end
