function DG = phase_connections(location, real, reactive)
global PhaseA_only PhaseB_only PhaseC_only
    DG = []; % phase A real | phase A imag | phase  B real| phase B imag| phase C real| phase C imag
    DG(1,1) = real*1000/3;% phase A
    DG(1,2) = reactive*1000/3;
    DG(2,1) = real*1000/3; %phase B
    DG(2,2) = reactive*1000/3;
    DG(3,1) = real*1000/3;
    DG(3,2) = reactive*1000/3;
    
    if ismember(ceil(location), PhaseA_only) % power input at B and C are zero
        DG(1,1) = real*1000;% phase A
        DG(1,2) = reactive*1000;
        DG(2,1) = 0;
        DG(2,2) = 0;
        DG(3,1) = 0;
        DG(3,2) = 0;
    elseif ismember(ceil(location), PhaseB_only)
        DG(2,1) = real*1000; %phase B
        DG(2,2) = reactive*1000;
        DG(1,1) = 0;
        DG(1,2) = 0;
        DG(3,1) = 0;
        DG(3,2) = 0;
    elseif ismember(ceil(location), PhaseC_only)
        DG(1,1) = 0;% phase A
        DG(1,2) = 0;
        DG(2,1) = 0; %phase B
        DG(2,2) = 0;
        DG(3,1) = real*1000;
        DG(3,2) = reactive*1000;
    end

end