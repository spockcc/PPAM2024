% Compute sqrt(2) using the secant method

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07  Essentially rewritten from scratch

% Define the function for which a root is sought
f=@(x)x.^2-2; 

% Define the initial search interval
a=0; 
b=2;

% ////////////////////////////////////////
% Set all parameters
% ////////////////////////////////////////

% Set the first pair of approximations
sp.xval=[a; b]; 

% Compute the corresponding function values
sp.fval=f(sp.xval);

% Break if the length of a bracket is less than delta
sp.delta=1e-15; 

% Break if absolute value of the last residual is less than eps
sp.eps=1e-15;

% Limit the maximum number of iterations
sp.maxit=60;

% Use the secant method to solve f(x)=0
[x, flag, ~, data]=secant(f,sp);

% ////////////////////////////////////////
%  Display the output nicely
% ////////////////////////////////////////

% Obtain parameters for printing the table
tp=table_param('secant');

% Print the table
print_table(data, tp);
