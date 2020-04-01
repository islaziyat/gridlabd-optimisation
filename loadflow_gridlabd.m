%%insert the generators as negative loads
function [Vmag,Imag,Psubstation,fail, buses] = loadflow_gridlabd(x1, x2, x3, x4, x5, x6)
global complex_grid
    
    buses=37;
    fail = 0;
    
    variables_DG1 = strcat(' --define DG1_location=',num2str(ceil(x1)),' --define DG1_size=', num2str(x4*1000));
    variables_DG2 = strcat(' --define DG2_location=',num2str(ceil(x2)),' --define DG2_size=', num2str(x5*1000));
    variables_DG3 = strcat(' --define DG3_location=',num2str(ceil(x3)),' --define DG3_size=', num2str(x6*1000));

    
    if complex_grid == 1
        file = ' IEEE37/IEEE37_real_no_regulator';
    else
        file = ' IEEE37/IEEE37_symmetric_balanced';
    end
 
    if ismac % for Mac OS
        s = strcat('/usr/local/bin/gridlabd',variables_DG1,variables_DG2,variables_DG3, file);
    elseif ispc % for Windows 
        s = strcat('set path=%path:C:\Program Files\MATLAB\R2020a\bin\win64;=% & gridlabd',variables_DG1,variables_DG2,variables_DG3, file);
    end
    
    [status,cmdout] = system(s);
    if status == 1
        cmdout
        disp('Error');
        V = zeros(37,1);
        fail = 1;
        return;
    end

    % IMPORT DATA FROM SIMULATION
    [V, VPU] = read_voltage_csv('output_voltage.csv');
    [I,Imag] = read_current_csv('output_current.csv');

    % At power slack bus
    Psubstation = conj(I(1,:)').*V(1,:)';
    
    if complex_grid == 1
        Vmag = [VPU(1:37,1);VPU(1:37,2); VPU(1:37,3)];
        Imag = [Imag(1:length(Imag),1);Imag(1:length(Imag),2); Imag(1:length(Imag),3)];
    else % symmetrical grid
        Vmag = VPU(:,1);
        Imag = Imag(:,1);
    end
        
    
end