function [table, flag]=compute_range(pp, v0, theta, method, dt, maxstep, solver, cntl)

% COMPUTE_RANGE Computes the range as function of the elevation
%
% CALL SEQUENCE: 
%
%   [table, flag]=compute_range(pp,v0,theta,method,dt,maxstep,solver,cntl)
%
% INPUT:
%   pp        the physical parameters
%                pp.mass   the mass of the shell
%                pp.cali   the caliber of the shell
%                pp.drag   a function computing the drag coeffient
%                pp.atmo   a function computing the atmosphere
%                pp.grav   a function computing gravity
%                pp.wind   a function computing the wind
%   v0        the muzzle velocity of the gun
%   theta     an array of elevations of dimension 1
%   method    a string describing the method used to compute the trajectory
%   dt        the length of all but the final time step
%   maxstep   the maximum number of time steps allowed
%   solver    a handler to function for solving nonlinear equations
%   cntl      a structure of parameters for the solver
%                cntl.delta    controls the error
%                cntl.epsilon  controls the residual
%                cntl.maxit    controls maximum number of iterations
% OUTPUT:
%   table     a two dimensional array, such that
%               table(j,1) = theta(j)
%               table(j,2) = the range obtained with elevation theta(j)
%               table(j,3) = the corresponding flight time 
%   flag      if flag =  1, then everything went smoothly
%             if flag = -j, then execution failed using elevation j
%
% Failures are often caused by small values of MAXSTEP
%
% MINIMAL WORKING EXAMPLE: compute_range_mwe1
%
% See also: RANGE_RK1, RANGE_RKX

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  Fall 2014 : Initial programming and testing
%  2015-09-22: Integrated global variables m, k, g into structure
%  2015-09-22: Minor improvement of documentation
%  2015-10-31: Replaced structure const with mandatory PARAM
%  2016-06-27: Integrated displaytable()
%  2016-09-09: Adapted function to SHELL4A
%  2024-03-01: Removed printing
%  2024-03-04: Introduced control over the final time step

% Reshape and sort the array containing the elevations
m=numel(theta); theta=reshape(theta,m,1); theta=sort(theta,'ascend');

% Artillery computations are not trivial, but let us be optimistic :)
flag=1;

% Initialize the table
table=zeros(m,3);

% Number of decimal digits of m 
num=floor(log10(m)+1);
fprintf('Computing %*d trajectories\n',num,m);

% Loop over the input angles
for j=1:m 
    % Print a dot to mark the current progress
    fprintf('.');
    % Compute the ith range
    [r, rf, t, ~]=range_rkx(pp, v0, theta(j), method, dt, maxstep, solver, cntl);
    % Save the elevation
    table(j,1)=theta(j);
    % But .... did the shell hit the ground?
    if (rf==0) 
        % Failure!
        % A more advanced routine would double maxstep and try again!
        % What is the physical meaning of maxstep*dt?
        fprintf('Insufficient flight time allocated for elevation = %f',theta(j));
        % Here we signal failure ....
        flag=-j;
        % Record NaN because humans often forget to check flags
        table(j,2)=NaN; table(j,3)=NaN;
        % ... and break out of the loop
        break;
    else
       % Success! Save the computed values
       table(j,2)=r; table(j,3)=t(end);
    end    
end

% Remove any trailing zeros from output arrays
table=table(1:j,:);

% Skip a few lines
fprintf('\n\n');