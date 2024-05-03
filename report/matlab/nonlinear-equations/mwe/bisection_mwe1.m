% Compute sqrt(2) using bisection

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

% Set the initial bracket
bp.xval=[a; b]; 

% Compute the corresponding function values
bp.fval=f(bp.xval);

% Break if the length of a bracket is less than delta
bp.delta=1e-15; 

% Break if absolute value of the last residual is less than eps
bp.eps=1e-15;

% Limit the maximum number of iterations
bp.maxit=60;

% Apply the bisection method to narrow the search interval
[x, flag, ~, data]=bisection(f,bp);

% ////////////////////////////////////////
%  Display the output nicely
% ////////////////////////////////////////

% Obtain parameters for printing the table
tp=table_param('bisection');

% Print the table
print_table(data, tp);
