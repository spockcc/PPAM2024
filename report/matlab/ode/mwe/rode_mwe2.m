% Demonstrate Richardson's technique for a simple 2D problem

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07 Adapted to the use of print_rode_table

% Define the interval
a=0; b=1;

% Select the function which defines the differential equation
f=@(t,y)[-y(2); y(1)]; 

% Specify the initial condition
y0=[1; 0];

% Select the number of timesteps
N1=10; N2=10; 

% Select the number of approximations
kmax=7;

% Specify the method to use and the *correct* order
method='rk2'; p=2; 

% The exact solution can be computed 
sol=@(t)[cos(t); sin(t)];

% Apply Richardson's techniques to our initial value problem
[s, table]=rode(f,a,b,y0,N1,N2,kmax,method,p,sol);

% These parameters determine the layout of the table
aux.kmax=kmax;
aux.n=size(table,2);

% Obtain parameters suitable for printing
tp=table_param('rode',aux);

% Print the table(s) nicely
print_rode_table(table,tp);