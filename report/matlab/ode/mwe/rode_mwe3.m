% Demonstrate Richardson's technique for a simple artillery trajectory

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07 Adapted to the use of print_rode_table

% Select mass, CONSTANT drag coefficient function and constant gravity
param=struct('mass',10,'cali',0.088,'drag',@(x)0.1879,'atmo',@(x)atmosisa(0),'grav',@(x)9.82);

% Select a slight head wind (swedish: motvind, tail wind = medvind)
param.wind=@(t,x)[-5; 0];

% Set the muzzle velocity and elevation
v0=780; theta=45*pi/180;

% Define the initial condition
y0=[0; 0; v0*cos(theta); v0*sin(theta)];

% Select the function which defines the differential equation
f=@(t,y)shell4a(param,t,y);

% Define the time interval we wish to investigate
a=0; b=50;

% Select the number of timesteps
N1=10; N2=4; 

% Select the number of approximations
kmax=5;

% Specify the method to use and the *correct* order
method='rk4'; p=4; 

% Apply Richardson's technique to our initial value problem
[s, table]=rode(f,a,b,y0,N1,N2,kmax,method,p);

% These parameters determine the layout of the table
aux.kmax=kmax;
aux.n=size(table,2);

% Obtain parameters suitable for printing
tp=table_param('rode',aux);

% Print the table(s) nicely
print_rode_table(table,tp);