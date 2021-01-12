% Forward backward sweep or newton raphson for 3-phase detailed system
% through gridlabd. 
% See IEEE37_real_with_regulator.glm
% IEEE37_real_no_regulator.glm

%%insert the generators as negative loads
function [Vmag,Imag,Psubstation,fail] = loadflow_gridlabd(x1, x2, x3, x4, x5, x6, x7, x8, x9)
global complex_grid IEEE37 regulator surrey
    fail = 0;
    
    if IEEE37
        buses = 37;
        lines = 36;
        if regulator
            file = ' IEEE37/IEEE37_real_with_regulator';
        else
            file = ' IEEE37/IEEE37_real_no_regulator';
    end
    
    if surrey
        buses = 19;
        lines = 18;
        file = ' Surrey/surreycommercial';
    end
    
    %establish phase connections - some parts of the grid are 1 or 2-phase
    %laterals
    DG1 = phase_connections(x1,x4,x7);
    DG2 = phase_connections(x2,x5,x8);
    DG3 = phase_connections(x3,x6,x9);
    
    %establish + or negative signs for gridlabd
    [sign1A, sign1B, sign1C] = establish_sign(DG1);
    [sign2A, sign2B, sign2C] = establish_sign(DG2);
    [sign3A, sign3B, sign3C] = establish_sign(DG3);
    
    variables_DG1 = strcat(' --define DG1_location=',num2str(ceil(x1))...
        ,' --define DG1_PhaseA=', num2str(DG1(1,1)),sign1A, num2str(DG1(1,2))...
        ,' --define DG1_PhaseB=', num2str(DG1(2,1)),sign1B, num2str(DG1(2,2))...
        ,' --define DG1_PhaseC=', num2str(DG1(3,1)),sign1C, num2str(DG1(3,2)));
    
    variables_DG2 = strcat(' --define DG2_location=',num2str(ceil(x2))...
        ,' --define DG2_PhaseA=', num2str(DG2(1,1)),sign2A, num2str(DG2(1,2))...
        ,' --define DG2_PhaseB=', num2str(DG2(2,1)),sign2B, num2str(DG2(2,2))...
        ,' --define DG2_PhaseC=', num2str(DG2(3,1)),sign2C, num2str(DG2(3,2)));
    
    variables_DG3 = strcat(' --define DG3_location=',num2str(ceil(x3))...
        ,' --define DG3_PhaseA=', num2str(DG3(1,1)),sign3A, num2str(DG3(1,2))...
        ,' --define DG3_PhaseB=', num2str(DG3(2,1)),sign3B, num2str(DG3(2,2))...
        ,' --define DG3_PhaseC=', num2str(DG3(3,1)),sign3C, num2str(DG3(3,2)));
    
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

    Vang = angle(V)*180/pi;
    Vmag = Vmag(1:buses,:);
    V = V(1:buses,:);
    Imag = Imag(1:lines,:);

    % Power at slack bus/substation
    Psubstation = conj(I(1,:)').*V(1,:)';
    
end