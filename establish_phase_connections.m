function establish_phase_connections()
%outputs what bus are connected to only phase A, B or C
    global PhaseA_only PhaseB_only PhaseC_only
    PhaseA_only = [];
    PhaseB_only = [];
    PhaseC_only = [];

    [Vinit,Imag,Psubstation,fail]  = loadflow_gridlabd(1,1,1,0,0,0,0,0,0);
    [I,Imag] = read_current_csv('output_current.csv');
    PhaseB_only = find(Imag(:,1) < 1e-3)+1; % Can only connect to Phase B
    PhaseC_only = find(Imag(:,2) < 1e-3)+1; % Can only connect to Phase C
    PhaseA_only = find(Imag(:,3) < 1e-3)+1; % Can only connect to Phase A


end
