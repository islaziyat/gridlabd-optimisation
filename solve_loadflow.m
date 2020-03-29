% Load are entered positive (kW)
% Generations are entered negative (kVAR)
% Line impedance entered in Ohm (converted to pu in code)

% to do: line charging and capacitor banks

% x(1),x(2),x(3) is location of solar pv
% x(4),x(5),x(6) is real power of solar pv in kW
% x(7),x(8),x(9) is reactive power of solar pv in kW

function [V,Theta,Y,fail, buses] = solve_loadflow(x1,x2,x3,x4,x5,x6,x7,x8,x9)
    fail = 0;
    j = sqrt(-1);
    m = ieee37_loads();
    l = ieee37_lines();

    lines=length(l(:,1));
    buses=length(m(:,1));
    Y = zeros(max(m(:,1)),max(m(:,1)));
    busnumber = max(m(:,1));

    %SET
    S_base_MVA = 0.01;
    Vbase = 4800;

    added_power = zeros(buses,1);
    added_power(ceil(x1),1) = added_power(ceil(x1),1)-x4;
    added_power(ceil(x2),1) = added_power(ceil(x2),1)-x5;
    added_power(ceil(x3),1) = added_power(ceil(x3),1)-x6;
    P = (m(:,2)+ added_power)/(S_base_MVA*1000);
    
    reactive_added_power = zeros(buses,1);
    reactive_added_power(ceil(x1),1) = reactive_added_power(ceil(x1),1)-x7;
    reactive_added_power(ceil(x2),1) = reactive_added_power(ceil(x2),1)-x8;
    reactive_added_power(ceil(x3),1) = reactive_added_power(ceil(x3),1)-x9;
    Q = (m(:,3)+reactive_added_power)/(S_base_MVA*1000);
    Zbase = Vbase^2/(S_base_MVA*1e6);

    %Impedance pu conversion
    l(:,4) = l(:,4)/Zbase;
    l(:,5) =l(:,5)/Zbase;


    for line = 1:lines
        %diagonal
        Y(l(line,2),l(line,2)) = Y(l(line,2),l(line,2)) + 1/(l(line,4)+j*l(line,5));
        Y(l(line,3),l(line,3)) = Y(l(line,3),l(line,3)) + 1/(l(line,4)+j*l(line,5));
        %others
        Y(l(line,2),l(line,3)) =  Y(l(line,2),l(line,3)) - 1/(l(line,4)+j*l(line,5));
        Y(l(line,3),l(line,2)) =  Y(l(line,3),l(line,2)) - 1 /(l(line,4)+j*l(line,5));
    end

    Vinit = 1;
    V = [1; Vinit*ones(busnumber-1,1)];
    Theta = zeros(busnumber,1);
    x = [Theta(2:busnumber,1) ; V(2:busnumber,1)];

    voltage=V.*exp(j*Theta);
    I = Y*voltage;
    S = voltage.*conj(I);
    mismatch = S + P + j*Q;
    S = S(2:busnumber,1);
    mismatch = mismatch(2:busnumber,1);
    f = [real(mismatch); imag(mismatch)];

    sensitivity = 1;
    iter_max = 100;
    iter = 0;

    while(sensitivity>1e-7 && iter<iter_max)
        Jac = zeros((busnumber-1)*2,(busnumber-1)*2);

        %Del for shift in theta
        deltheta = 0.0001;
        for t=2:busnumber
            loc = [];
            loc = zeros(busnumber,1);
            loc(t,1) = deltheta;
            Vdel = V.*exp(j*(Theta + loc));
            Inew = Y*Vdel;
            Sdel = Vdel.*conj(Inew);
            Sdel = Sdel(2:busnumber,1);
            Jac(1:(busnumber-1),t-1) = real((Sdel - S)/deltheta);
            Jac((busnumber):(busnumber-1)*2,t-1) = imag((Sdel - S)/deltheta);
        end

          %Del for Voltage shift 
        delv = 0.001;
        for t=2:busnumber
            loc = [];
            loc = zeros(busnumber,1);
            loc(t,1) = delv;
            Vdel = (V+loc).*exp(j*Theta);
            Inew = Y*Vdel;
            Sdel = Vdel.*conj(Inew);
            Sdel = Sdel(2:(busnumber),1);
            Jac(1:(busnumber-1),busnumber+t-2) = real((Sdel - S))/delv;
            Jac((busnumber):(busnumber-1)*2,busnumber+t-2) = imag((Sdel - S)/delv);
        end
        % 
        
        x = x - Jac\f;
        Theta = [0; x(1:busnumber-1,1)];
        V = [1; x(busnumber:(busnumber-1)*2,1)];

        voltage=V.*exp(j*Theta);
        I = Y*voltage;
        S = voltage.*conj(I);
        mismatch = S + P + j*Q;
        S = S(2:busnumber,1);
        mismatch = mismatch(2:busnumber,1);
        fnew = [real(mismatch); imag(mismatch)];
        sensitivity = norm(f-fnew);
        f = fnew;
        iter = iter+1;
    end

    if(iter==iter_max)
        disp('Maximum iterations reached: algorithm did not converge');
        fail = 1;
        return;
    end
%     fprintf('Newton raphson converged after %i interations\n', iter);
%     fprintf('Solution we converged to:\n');
%     V
%     Theta
end
% 
