function Ploss = powerlosslines(V, Theta, Y)
    voltage=V.*exp(1i*Theta);
    I = Y*voltage;
    S = voltage.*conj(I)
    Ploss = -sum(S);
end