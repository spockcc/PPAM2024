% Compute cube root of 2 using Newton's method

% Solve the non-linear equation
% 
%    x^3 = 2
%
% with respect to x.

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-06  Minor updated of existing script

% Define the relevant function
f=@(x)x.^3-2;

% Define the derivative of f
param.df=@(x)3*x.^2; 

% Define the initial guess
param.xval=sqrt(2); 

% Define the tolerance for the residual
param.eps=1e-15; 

% Define the maximum number of iterations
param.maxit=10;

% Apply Newton's method to the solution of the equation f(x)=1
[x, flag, it, his, res, resnorm] =newton(f,param); 

% Define the error
err=2^(1/3)-his;

% Plot e(n+1) as a function of e(n)
plot(log10(abs(err(1:it-1))),log10(abs(err(2:it))),...
    log10(abs(err(1:it-1))),log10(abs(err(2:it))),'*');

% Labels
xlabel('log_{10}(abs(e_n))'); ylabel('log_{10}(abs(e_{n+1}))');

% Grid
grid on; grid minor