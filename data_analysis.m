function VPU = data_analysis(voltage_file)
    m = csvread(voltage_file,2,1);
    busnumber = length(m(:,1));
    
    for phase = 1:3
    V(:,phase) = m(:,(phase-1)*2 + 1) + j*m(:,(phase-1)*2 + 2);
    end

    VPU=abs(V)/4800;
    theta=angle(V)*180/pi;
    
%     n = csvread(current_file,2,1);
%     linenumber = length(n(:,1));
%     for phase = 1:3
%         current(:,phase) =  n(:,(phase-1)*2 + 1) + j*n(:,(phase-1)*2 + 2);
%     end
%     
%     current = [current; current(linenumber,:)];
%     ieee4Vact = [7200,7200,7200;7107,7140,7121;2247.60000000000,2269,2256;1918,2061,1981];

end




