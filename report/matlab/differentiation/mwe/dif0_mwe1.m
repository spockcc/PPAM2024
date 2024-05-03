% Numerical differentiation of exp

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2018-11-28  Initial development and testing
%   2024-03-06  Adapted to the new print_table function

% /////////////////////////////////////////////////////////////////////////
%   Compute approximations of the derivative
% /////////////////////////////////////////////////////////////////////////

% Define the function
f=@(x)exp(x);

% Define the point of interest
x=1;

% Define the initial step size
h0=1;

% Define the number of approximations to compute
maxit=54;

% Compute approximations of the derivative
data=dif0(f,x,h0,maxit);


% /////////////////////////////////////////////////////////////////////////
%   Generate a table of all computed information
% /////////////////////////////////////////////////////////////////////////

% Get table paramenter
tp=table_param('dif0');

% Print the table
print_table(data, tp);

% /////////////////////////////////////////////////////////////////////////
%   Generate plot of relative error
% /////////////////////////////////////////////////////////////////////////

% Define derivative
df=@(x)exp(x);

% Evaluate the exact derivative f'(x)
T=f(x);

% Isolate the stepsizes used to compute the approximations
h=data(:,2);

% Isolate the computed approximations
A=data(:,4);

% Compute the relative error
R=(T-A)./A; 

% Display the relative error as a function of the stepsize
plot(log10(h),log10(abs(R))); 

% Display appropriate labels and add grids
xlabel('log10 stepsize'); ylabel('log10(abs(relative error))');

% Enable grids
grid on; grid minor;