% Compute sqrt(2) using the Newton's method

% Solve the non-linear equation
% 
%    x^2 = 2
%
% with respect to x.

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-06  Minor updated of existing script

% Define the relevant function
f=@(x)x.^2-2;

% Define the derivative of f
sp.df=@(x)2*x; 

% Define the initial guess
sp.xval=1.2; 

% Define the tolerance for the residual
sp.eps=1e-15; 

% Define the maximum number of iterations
sp.maxit=10;

% Apply Newton's mehtod to the solution of the equation f(x)=2
[x, flag, it, his, res, resnorm]=newton(f,sp);