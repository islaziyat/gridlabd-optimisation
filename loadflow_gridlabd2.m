%%insert the generators as negative loads
% % INCLUDES reactive power
function [V,Theta,fail, buses] = loadflow_gridlabd2(x1, x2, x3, x4, x5, x6)
global complex_grid
    buses=37;
    fail = 0;
    
    variables_DG1 = strcat(' --define DG1_location=',num2str(x1),' --define DG1_size=', num2str(x4*1000));
    variables_DG2 = strcat(' --define DG2_location=',num2str(x2),' --define DG2_size=', num2str(x5*1000));
    variables_DG3 = strcat(' --define DG3_location=',num2str(x3),' --define DG3_size=', num2str(x6*1000));

    file = ' IEEE37/IEEE37_symmetric_balanced';
    if complex_grid == 1
        file = ' IEEE37/IEEE37_real_no_regulator';
    end

    % for Windows OS
    s = strcat('set path=%path:C:\Program Files\MATLAB\R2020a\bin\win64;=% & gridlabd',variables_DG1,variables_DG2,variables_DG3, file);
     % for Mac OS
    s = strcat('\usr\local\gridlabd\bin',variables_DG1,variables_DG2,variables_DG3, file);
    [status,cmdout] = system(s);
    if status == 1
        cmdout
        disp('Error');
        V = zeros(37,1);
        fail = 1;
        return;
    end

    Vout = data_analysis('output_voltage.csv');
    V = Vout(1:37,1);
    if complex_grid == 1
        V = [Vout(1:37,1);Vout(1:37,2); Vout(1:37,3)];
    end

    Theta = [];
   
end