function [I,Imag] = read_current_csv(current_file)
    m = csvread(current_file,2,1);
    busnumber = length(m(:,1));
    
    for phase = 1:3
    I(:,phase) = m(:,(phase-1)*2 + 1) + 1i*m(:,(phase-1)*2 + 2);
    end
    Imag = abs(I);
end