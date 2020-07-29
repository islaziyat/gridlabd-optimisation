function [V, VPU] = read_voltage_csv(voltage_file)
global surrey IEEE37
    if surrey
        Vbase = 25000
    end
    
    if IEEE37
        Vbase = 4800
    end
    
    m = csvread(voltage_file,2,1);
    busnumber = length(m(:,1));
    
    for phase = 1:3
    V(:,phase) = m(:,(phase-1)*2 + 1) + 1i*m(:,(phase-1)*2 + 2);
    end

    VPU = abs(V)/Vbase;
%     theta=angle(V)*180/pi;
    
end




