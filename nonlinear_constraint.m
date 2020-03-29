function [c, ceq] = nonlinear_constraint(x)

% % imposes constraint that the voltage should be between 0.95 and 1.05
[V,Theta,fail, buses] = solve_loadflow(x(1),x(2),x(3),x(4),x(5),x(6));
c(1:buses) = V' - 1.05*ones(1,buses);
d(1:buses) = 0.95*ones(1,buses)-V';
c = [c d];

% % CURRENT limits per line can also be defined here

ceq=[];
end