function [r, flag, t, tra]=range_rkx(pp,v0,theta,method,dt,maxstep,solver,cntl)

% RANGE_RKX Computes the range of a shell using a Runge-Kutta method
%
% All time steps have the same size, except the last that is
% adjusted to put the shell exactly on the ground.
%
% CALL SEQUENCE: 
%  
%   [r, flag, t, tra]=range_rkx(pp, v0, theta, method, dt, maxstep, solver, cntl)
%
% INPUT:
%   pp        the physical parameters
%                pp.mass   the mass of the shell
%                pp.cali   the caliber of the shell
%                pp.drag   a function computing the drag coeffient
%                pp.atmo   a function computing the atmosphere
%                pp.grav   a function computing gravity
%                pp.wind   a function computing the wind
%   v0        the muzzle velocity of the shell
%   theta     the elevation of the gun in radians
%   method    a string naming the method used, see rk for options
%   dt        the basic time step, the final time step will be shorter
%   maxstep   the maximum number of time steps
%   solver    a handler to function for solving nonlinear equations
%   cntl      a structure of parameters for the solver
%                cntl.delta    controls the error
%                cntl.epsilon  controls the residual
%                cntl.maxit    controls maximum number of iterations
%
% OUTPUT:
%   r        if flag=1, then r = the computed range, if flag=1 
%            if flag=0, then r = NaN 
%   t        the time instances where the trajectory was approximated
%   tra      the computed trajectory, y(:,i) corresponds to time t(i)
%               tra(1,i) is the x-component of the shells position
%               tra(2,i) is the y-component of the shells position
%               tra(3,i) is the x-component of the shells velocity
%               tra(4,i) is the y-component of the shells velocity
%    flag    if flag=1, then the shell hit the ground
%            if flag=0, then the shell did not hit the ground
%
% MNIMAL WORKING EXAMPLE: range_rkx_mwe1
%
% See also: COMPUTE_ELEVATION, COMPUTE_RANGE, RANGE_RK1

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  Fall 2014   Initial programming and testing
%  2015-09-22  Globals m, k, and g integrated into structure CONST
%  2015-10-31  Replaced structure CONST with mandatory PARAM
%  2015-10-31  Minor error in the inline comments fixed during yearly review
%  2015-11-01  Extended the description of the initial condition
%  2015-12-08  Added support for wind to shell4.m
%  2016-06-22  Adapted routine to improved bisection method
%  2016-06-23  Added logical check for bad elevations
%  2016-09-09  Adapted to more flexible SHELL4A
%  2020-11-01  Minor update to the documentation.
%  2024-03-04  Added a parameter that controls the final time step

%//////////////////////////////////////////////////////////////////////////
% Select the relative tolerance being use by the nonlinear solver
%//////////////////////////////////////////////////////////////////////////

% Select a shell model, feeding it the parameters of the simulation
shell=@(t,x)shell4a(pp,t,x);

% Define the initial condition; 
% There are four coordinates:
%  1st coor. is the x coordinate of the muzzle of the gun
%  2nd coor. is the y coordinate of the muzzle of the gun
%  3rd coor. is the x coordinate of the velocity of the shell when it exits
%  4th coor. is the y coordinate of the velocity of the shell when it exits

% With these choices the muzzle is at (0,0).
tra0=[0; 0; v0*cos(theta); v0*sin(theta)];

% Allocate space for trajectory
tra=zeros(4,maxstep+1);

% Initialize the trajectory
tra(:,1)=tra0;

% Allocate space to record the time instances
t=zeros(1,maxstep+1);

% Anticipate failure or bad input.
r=NaN; flag=0; 

% Check for 'bad' elevation
if (sin(theta)<=0)
    % The shell is fired into the ground
    r=0; flag=-1; t=0; tra=tra(:,1); 
    % Quick return
    return;
end

% Pickup the method to use.
switch lower(method)
    case 'rk1'
        phi=@phi1;
    case 'rk2'
        phi=@phi2;
    case'rk3'
        phi=@phi3;
    case 'rk4'
        phi=@phi4;
    otherwise   
        fprintf('Invalid method specified! Aborting\n'); return;
end

% Loop over the time steps
for it=1:maxstep
    % Advance the clock a single time step
    t(it+1)=it*dt;
  
    % Advance the solution a single step using the selected method.
    tra(:,it+1)=phi(shell,t(it),tra(:,it),dt);
    
    % Test to see if we are below ground level, tra(2,it+1)<0
    if (tra(2,it+1)<0)
        %------------------------------------------------------------------
        % We passed through the ground! Go back and compute the time step 
        % which will put the shell exactly on the ground.
        %------------------------------------------------------------------
        
        % Isolate the last point above ground level.
        z0=tra(:,it); t0=t(it);

        % Define the function psi(x) which isolates the y coordinate 
        % of the shell after a step of size x*dt.
        psi=@(x)[0 1 0 0]*phi(shell,t0,z0,x*dt);

        % ///////////////////////////////////
        % Parameters for the nonlinear solver
        % ///////////////////////////////////
        
        % A bracket or just a pair of points
        sp.xval=[0; 1];
        
        % The corresponding function values
        sp.fval=tra(2,it:it+1);
        
        % Upon reflection this is not trivial either
        sp.delta=cntl.delta;
        
        % Choosing epsilon is not a trivial matter
        % ... and further analysis is required
        sp.eps=cntl.eps*abs(tra(2,it+1)-tra(2,it));
        
        % Maximum number of iteration
        sp.maxit=cntl.maxit;
        
        % Find the 'exact' timestep which will put the shell on the ground
        rho=solver(psi,sp);
        
        % Calculate the 'exact' point of impact; 
        sp=phi(shell,t0,z0,rho*dt);
        
        % Save the time and point of impact
        t(it+1)=t0+rho*dt; tra(:,it+1)=sp;

        % The range has now been computed, signal succes ...
        flag=1; 
        
        % ... and break from the for-loop.
        break;
    end
end

% Remove any trailing zeros from output arrays
tra=tra(:,1:it+1); t=t(1,1:it+1);

% Only define the range if the shell hit the ground !!!
if flag==1
  % Isolate the range 
    r=tra(1,it+1);
end