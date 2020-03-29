function Ploss = powerlosslines(V, theta, Y)
    voltage=V.*exp(i*Theta);
    I = Y*voltage;
    S = voltage.*conj(I);
    Ploss = -sum(S);
end