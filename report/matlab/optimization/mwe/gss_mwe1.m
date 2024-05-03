% Finds the maximum of a simple function

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-09   Added plot commands

% Define interval
alpha=0; beta=1;

% Define target function, obvious maximum at x=0.5
f=@(x)x.*(1-x);

% Set tolerance
tol=1e-15;

% Set maximum number of iterations
maxit=100;

% Run the experimental version of gss
[x, y, flag, it, a, b]=gss(f,alpha,beta,tol,maxit);

% ////////////////////////////////////////
%   Plot the function and the maximum
% ////////////////////////////////////////

% Sample points
xval=linspace(alpha,beta,129);

% Function values
fval=f(xval);

% Plot the results
plot(xval,fval,x,y,'*'); 

% Labels
xlabel('x'); ylabel('y');

% Grids
grid on; grid minor; 

% Title
title('Locating the maximum of a simple function');