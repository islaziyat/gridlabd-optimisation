function VPU = read_voltage_csv(voltage_file)
    m = csvread(voltage_file,2,1);
    busnumber = length(m(:,1));
    
    for phase = 1:3
    V(:,phase) = m(:,(phase-1)*2 + 1) + 1i*m(:,(phase-1)*2 + 2);
    end

    VPU=abs(V)/4800;
    theta=angle(V)*180/pi;
    
end




