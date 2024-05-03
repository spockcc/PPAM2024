% Slow computation of firing solutions for the D-20 howitzer

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2021-05-12  Initial programming and testing
%   2024-03-04  Essentially rewritten from scratch

% This scipt is solves the same problem as compute_elevation_mwe1
% However the author has choosen poorly among the available algorithms

% Define the piece of artillery
d20;

% Select a very accurate method
method='rk4';

% Distance to targets
r=(1000:1000:14000);

% ////////////////////////////////////////////////////////////////////
%  Select solver for computing the final time step for each trajectory
% ////////////////////////////////////////////////////////////////////
sf1=@bisection;

% Tolerances and maximum number of iterations
cntl.delta=1e-2;  % We cannot do error estimation unless delta is O(u)
cntl.eps=1e-2;    % We cannot do error estimation unless eps is O(u)
cntl.maxit=60;    % Is this a reasonable value?

% Define the correspoinding range function
rf2=@(theta)range_rkx(param,v0,theta,method,dt,maxstep,sf1,cntl);

% //////////////////////////////////////////////////////////////////
% Select solver for computing the firing solution for each target
% ////////////////////////////////////////////////////////////////////
sf2=@bisection;

% Tolerances and maximum number of iterations
sp2.delta=eps(1)/2;  % We cannot do error estimation unless delta is O(u)
sp2.eps=eps(1)/2;    % We cannot do error estimation unless eps is O(u)
sp2.maxit=60;        % Is a reasonable value?

% Start the clock;
start=tic;

% Compute table
[table2, count2]=compute_elevation(r,param,v0,method,dt,maxstep,sf1,cntl,sf2,sp2);

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
aux=180/pi; data2=table2; data2(:,[2 4])=data2(:,[2 4])*aux; 

% Print the table
print_table(data2, tp);

% Statistics
fprintf('\n');
fprintf('SUMMARY:\n');
fprintf('Number of targets                 : %4d\n',n);
fprintf('Number of trajectories computed   : %4d\n',count2);
fprintf('Wall time (seconds)               : %7.2f\n',time);