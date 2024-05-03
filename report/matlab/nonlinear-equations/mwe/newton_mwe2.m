% Solve a system of two nonlinear equations

% Solve the non-linear equation 
%
%      x(1)^2*x(2)-3 =-2 
%      x(1) + x(2)   = 3 
%
% with respect to x=[x(1); x(2)].

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-06  Minor updated of existing script

% Define a function of two variables
f=@(x)[x(1)^2*x(2)-3; x(1)+x(2)]-[-2; 3];

% Define the Jacobian of f.
% This is 2 by 2 matrix consisting of all first order partial derivatives
param.df=@(x)[2*x(1)*x(2), x(1)^2; 1, 1];

% Define the ri
% Define the initial guess
param.xval=[1.3; 0.8];

% Define the tolerance for the residual norm  
param.eps=1e-15; 

% Define the maximum number of iterations
param.maxit=10;

% Apply Newton's method to solving the equation f(x) = 0
[x, flag, it, his, res, resnorm]=newton(f,param);
