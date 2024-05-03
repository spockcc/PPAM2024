% Find the point of impact of a shell fired from a gun

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07 Initial programing and testing

% Load the gun
d20;

% Set the elevation of the barrel of the gun
theta=74*pi/180; 

% Redefine the basic time step for a clean graph
dt=5;

% Define the initial condition
x0=[0; 0; v0*cos(theta); v0*sin(theta)];
    
% Define the function that drives the differential equation
f=@(t,x)shell4a(param,t,x);

% Define the time interval
t0=0; t1=maxstep*dt;

% Define the event function, i.e., isolate the y coordinate
g=@(x)x(2);

% Set the maximum number of events
K=2;

% Fire the shell and search for the point of impact
[t, y, count, idx]=event_location(f,t0,t1,x0,maxstep,method,g,K);

% Plot the entire trajectory
plot(y(1,:),y(2,:),y(1,:),y(2,:),'*');

% Labels
xlabel('x (meter)'); ylabel('y (meter)');

% Grids
grid on; grid minor