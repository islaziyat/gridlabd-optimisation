function [signA, signB, signC] = establish_sign(DG)
    signA = '+';
    signB = '+';
    signC = '+';
    if DG(1,2) < 0 
        signA='';
    end 
    if DG(2,2) < 0 
        signB='';
    end 
    if DG(3,2) < 0 
        signC='';
    end 
end