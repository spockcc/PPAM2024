% Compute a composite trapezoidal sum for a simple function

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  2024-04-09  Extracted from trapezoid

% Define the domain/interval
a=0; b=1; 

% Define the function
f=@(x)exp(x); 

% Define the sample points
N=8; x=linspace(a,b,N+1); 

% Evaluate the function values
y=f(x);

% Apply the composite rapezoidal rule
s=trapezoid(y,a,b,N); 
