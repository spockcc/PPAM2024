% Compute the velocity of a stone falling through a homogeneous atmosphere

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07 Initial programing and testing

% Set the function that drives the differential equation
f=@(t,x)x.^2-1; 

% Specify the time interval
t0=0; t1=3; 

% Set the initial condition
x0=0; 

% Specify number of sample points
N1=30; 

% Specify the number time steps betweeen sample points
N2=10; 

% Select the method used to solve the problem
method='rk2';

% Approximate the solution of the initial value problem
[t, y]=rk(f,t0,t1,x0,N1,N2,method);

% Display the computed solution
plot(t,y,t,y,'*'); xlabel('t'); ylabel('y');

% Grids
grid; grid minor;