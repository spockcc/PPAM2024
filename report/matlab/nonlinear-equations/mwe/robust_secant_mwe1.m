% Compute sqrt(3) using the robust secant method

% Define the function for which a root is sought
% Clearly the solutions are +sqrt(3) and -sqrt(3)
f=@(x)x.^2-3; 

% Define the search interval
sp.xval=[0 2];
sp.fval=f(sp.xval);

% Break if the length of the search bracket is less than delta
sp.delta=1e-15; 

% Break if the absolute value of the residual is less than epsilon
sp.eps=1e-15;

% Set the maximum number of iterations before aborting the search
sp.maxit=60; 

% Apply the robust secant method to narrow the search interval
[x, flag, it, data]=robust_secant(f,sp);

% ////////////////////////////////////////
%  Display the output nicely
% ////////////////////////////////////////

% Obtain parameters for printing the table
tp=table_param('robust_secant');

% Print the table
print_table(data, tp);
