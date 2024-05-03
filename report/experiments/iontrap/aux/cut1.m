function y=cut1(rho,x)

% Initialize the output
y=zeros(size(x));
% Anything less than rho is mapped to 1
y(x<rho)=1;