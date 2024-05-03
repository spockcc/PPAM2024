% Fast computation of firing solutions for the D-20 howitzer

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2021-05-12  Initial programming and testing
%   2024-03-04  Essentially rewritten from scratch

% Define the piece of artillery
d20;

% Distance to targets
r=(1000:1000:14000);

% ////////////////////////////////////////////////////////////////////
%  Select solver for computing the final time step for each trajectory
% ////////////////////////////////////////////////////////////////////
sf1=@robust_secant;

% Control parameters for the first solver
cntl.delta=eps(1)/2;
cntl.eps=eps(1)/2;
cntl.maxit=53;

% Define the correspoinding range function
rf1=@(theta)range_rkx(param,v0,theta,method,dt,maxstep,sf1,cntl); disp(rf1);

% ////////////////////////////////////////////////////////////////////
% Select solver for computing the firing solution for each target
% ////////////////////////////////////////////////////////////////////
sf2=@robust_secant;

% Tolerances and maximum number of iterations
sp2.delta=eps(1)/2;       % Why is this parameter set to zero?
sp2.eps=eps(1)/2;         % Why should this be the kill radius of the shell?
sp2.maxit=20;             % Is this always a reasonable value?

% Start the clock;
start=tic;

% Compute table
[table1, count1]=compute_elevation(r,param,v0,method,...,
    dt,maxstep,sf1,cntl,sf2,sp2);

% Stop the clock
time=toc(start);

% Number of targets
n=numel(r);

% ////////////////////////////////////////////////////////////////////
% Print the table
% ////////////////////////////////////////////////////////////////////

% Obtain predefined parameters for how to format the table
tp=table_param('compute_elevation');

% Convert the elevations from radians to degrees
aux=180/pi; data1=table1; data1(:,[2 4])=data1(:,[2 4])*aux; 

% Print the table
print_table(data1, tp);

% Statistics
fprintf('\n');
fprintf('SUMMARY:\n');
fprintf('Number of targets                 : %4d\n',n);
fprintf('Number of trajectories computed   : %4d\n',count1);
fprintf('Wall time (seconds)               : %7.2f\n',time);