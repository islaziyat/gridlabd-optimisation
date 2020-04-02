%%insert the generators as negative loads
function [Vmag,Imag,Psubstation,fail] = loadflow_gridlabd(x1, x2, x3, x4, x5, x6, x7, x8, x9)
global complex_grid IEEE37
    fail = 0;
    
    if IEEE37
        buses = 37;
        lines = 36;
    end
    
    %establish + or negative signs for gridlabd
    sign1 = '+';
    sign2 = '+';
    sign3 = '+';
    if x7 < 0 
        sign1='';
    end 
    if x8 < 0 
        sign2='';
    end
    if x9 < 0 
        sign3='';
    end
    
    variables_DG1 = strcat(' --define DG1_location=',num2str(ceil(x1)),' --define DG1_size=', num2str(x4*1000),sign1, num2str(x7*1000));
    variables_DG2 = strcat(' --define DG2_location=',num2str(ceil(x2)),' --define DG2_size=', num2str(x5*1000),sign2, num2str(x8*1000));
    variables_DG3 = strcat(' --define DG3_location=',num2str(ceil(x3)),' --define DG3_size=', num2str(x6*1000),sign3, num2str(x9*1000));
 
    if complex_grid == 1
        file = ' IEEE37/IEEE37_real_with_regulator';
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
    [V, Vmag] = read_voltage_csv('output_voltage.csv');
    [I,Imag] = read_current_csv('output_current.csv');
    
    Vmag = Vmag(1:buses,:);
    V = V(1:buses,:);
    Imag = Imag(1:lines,:);

    % Power at slack bus/substation
    Psubstation = conj(I(1,:)').*V(1,:)';
    
end