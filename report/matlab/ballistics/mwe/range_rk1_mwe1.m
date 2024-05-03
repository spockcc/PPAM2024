% Computes the range of a shell fired from the Flak-36

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2018-11-01  Adapted from existing script and including a plot
%   2024-03-04  Reformatted during yearly review

% Load a model of G7 type shell
load shells mcg7

% ////////////////////////////////////////
% Set all parameters (SI-units)
% ////////////////////////////////////////

% This is the mass of the shell
param.mass=10;

% This is the caliber of the barrel
param.cali=0.088;

% This function controls the size of the friction
param.drag=@(x)mcg7(x);

% The standard model of Earth's atmosphere
param.atmo=@(x)atmosisa(x);

% The standard acceleration due to gravity
param.grav=@(x)9.80665;

% Set the muzzle velocity and elevation
v0=780; theta=45*pi/180; 

% Select the basic time step size 
dt=1; 

% Set the maximum number of time steps
maxstep=100;

% Compute the range of the shell
[r, flag, t, tra]=range_rk1(param,v0,theta,...
    dt,maxstep);

% Plot the trajectory nicely
plot(tra(1,:),tra(2,:)); 

% Adjust axis to use the same scale
axis equal;

% Add a coarse and a fine grid
grid on; grid minor;

% Print the range
fprintf('Range of shell = %.2f meter\n',r);
