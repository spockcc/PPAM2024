% COMPUTE_RANGE_MWE1 Computes a table of ranges for the Flak36 

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2017-10-24 Extracted from compute_range
%   2024-02-28 Adapted to the separation of computing/printing
%   2024-03-04 Allows user-defined solution of the final timestep

% Load a representation of the Flak 36
% flak36;
d20;
load shells
param.drag=@(x)mcg6(x);

% Specify muzzle elevation in degrees and convert to radian
deg=0:1:90; theta=deg*pi/180;

% Define the solver used to compute the last time step of each trajectory
solver=@robust_secant; 
cntl.delta=eps(1)/2; 
cntl.eps=eps(1)/2;
cntl.maxit=60;

% Finally, produce the table of ranges
[table, flag]=compute_range(param, v0, theta, method, dt, maxstep, solver, cntl);

% ////////////////////////////////////////
% Prepare for printing
% ////////////////////////////////////////

% Convert the elevation from radians to degrees
data=[table(:,1)*180/pi,table(:,2),table(:,3)];

% Obtain predefined parameters for formating the table
tp=table_param('compute_range');

% Print the table
print_table(data,tp);

rf=@(theta)range_rkx(param, v0, theta, method, dt, maxstep, solver, cntl);