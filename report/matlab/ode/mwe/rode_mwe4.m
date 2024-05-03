% Demonstrate Richardson's technique for a *real* artillery trajectory

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07 Adapted to the use of print_rode_table

% Display a note of caution
fprintf('When you change this script (and you should) you can easily get results that are hard to interpret!!!\n');

% Load parameters for the Flak36 AA gun
flak36;

% Define the interval
a=0; b=80;

% Select the function which defines the differential equation
f=@(t,y)shell4a(param,t,y);

% Select elevation for the shot
theta=pi/4;

% Specify the initial condition
y0=[0; 0; v0*cos(theta); v0*sin(theta)];

% Select the number of timesteps
N1=16; N2=4; 

% Select the number of approximations
kmax=7;

% Specify the method to use and the *correct* order
method='rk1'; p=1; 

% Apply Richardson's techniques to our initial value problem
[s, table]=rode(f,a,b,y0,N1,N2,kmax,method,p);

% These parameters determine the layout of the table
aux.kmax=kmax;
aux.n=size(table,2);

% Obtain parameters suitable for printing
tp=table_param('rode',aux);

% Print the table(s) nicely
print_rode_table(table,tp);