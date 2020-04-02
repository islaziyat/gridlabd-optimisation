function dev = voltage_deviation(V)
Vpu = ones(length(V),1);
delta_V = abs(V-Vpu);
dev = sum(sum(delta_V));
end