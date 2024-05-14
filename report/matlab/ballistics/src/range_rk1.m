function [r, flag, t, tra]=range_rk1(param,v0,theta,dt,maxstep)

% RANGE_RK1 Computes the range of a shell using Euler's explicit method
%
% All time steps except the last have the same size.
% The last step is choosen to put the shell exactly on the ground.
%
% CALL SEQUENCE: [r, flag, t, tra]=range_rk1(param,v0,theta,dt,maxstep)
%
% INPUT:
%   param    a structure describing of the environment and the shell
%                param.mass   the mass of the shell
%                param.cali   the caliber of the shell
%                param.drag   a function computing the drag coeffient
%                param.atmo   a function computing the atmosphere
%                param.grav   a function computing gravity
%                param.wind   a function computing the wind
%   v0       the muzzle velocity of the shell
%   theta    the elevation of the gun in radians
%   dt       the standard time step, the last step will be shorter
%   maxstep  the maximum number of time steps allowed
%
% OUTPUT:
%    r       the computed range if flag=1, see below.
%    t       the time instances where the trajectory was sampled
%    tra     the computed trajectory, tra(:,i) corresponds to time t(i)
%               tra(1,i) is the x-component of the shells position
%               tra(2,i) is the y-component of the shells position
%               tra(3,i) is the x-component of the shells velocity
%               tra(4,i) is the y-component of the shells velocity
%    flag    flag=0 if the shell did not hit the ground
%            flag=1 if the shell hit the ground
%
% MINIMAL WORKING EXAMPLE: range_rk1_mwe1.m
%
% See also: COMPUTE_ELEVATION, COMPUTE_RANGE, RANGE_RKX

% PROGRAMMING: Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  Fall 2014   Initial programming and testing.
%  2015-09-22  Global variables m, k, and g integrated into a structure
%  2015-10-31  The structure was replaced by a variable PARAM.
%  2015-10-31  Documentation and variable names improved.
%  2016-06-22  Minor changes to the documentation, comments and formatting
%  2016-09-09  Adapted to SHELL4A. Fixed typo in MWE.
%  2016-10-26  Edited text in MWE to be compatible with call.
%  2021-11-01  Updated documentation
%  2024-03-05  Reformated the code during yearly review

% Select a simple shell model
shell=@(t,x)shell4a(param,t,x);

% Define the initial condition
tra0=[0; 0; v0*cos(theta); v0*sin(theta)];

% Allocate space for trajectory
tra=zeros(4,maxstep+1);

% Initialize the trajectory
tra(:,1)=tra0;

% Allocate space to record the time instances
t=zeros(1,maxstep+1);

% Anticipate failure or bad input.
r=NaN; flag=0; 

% Check for bad elevation
if (sin(theta)<=0)
    % The shell is fired into the ground
    r=0; flag=1; t=0; tra=tra(:,1); 
    % Quick return
    return;
end

% Loop over the time steps
for it=1:maxstep
    % Advance the clock a single time step.
    t(it+1)=it*dt;
    
    % Compute the next step on the trajectory
    tra(:,it+1)=phi1(shell,t(it),tra(:,it),dt);

    % Test to see if we are below ground level
    if (tra(2,it+1)<0)
        % ////////////////////////////////////////
        % We passed through the ground!
        % Go back to the previous instant and 
        % compute the 'exact' time step that 
        % will put the shell on the ground!
        % This is simpler than it seems. 
        % Always make a sketch!
        % ////////////////////////////////////////

        % The y-coordinate of he shell is tra(2,it),
        % The y-velocity of the shell is aux(2) where
        aux=shell(t(it),tra(:,it)); 
    
        % The 'exact' time step is therefore 
        dt=-tra(2,it)/aux(2);
        
        % Record the time of impact
        t(it+1)=t(it)+dt;
        
        % Record the point of impact
        tra(:,it+1)=phi1(shell,t(it),tra(:,it),dt);
        
        % The range has now been computed
        flag=1; break;
    end
end

% Remove any trailing zeros from output arrays
tra=tra(:,1:it+1); t=t(1,1:it+1);

% Only define the range if the shell hit the ground!
if flag==1
  % Isolate the range 
  r=tra(1,it+1);
end