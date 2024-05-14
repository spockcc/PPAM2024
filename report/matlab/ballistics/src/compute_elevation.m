function [table, count]=compute_elevation(r,param,v0,method,dt,maxstep,sf1,cntl,sf2,sp2)

% COMPUTE_ELEVATION Find pairs of firing solutions
%
% CALL SEQUENCE:
%
%   [table, count]=compute_elevation(r,param,v0,method,dt,maxstep,sf1,cntl,sf2,sp2)
%
% INPUT:
%   r         array of distances to targets
%   param     a structure describing the shell and the environment
%              see range_rkx for details
%   v0        the muzzle velocity of the gun
%   method    the method used to integrate the trajectories
%               see rk for options
%   dt        the standard time step
%   maxstep   the maximum number of time steps per trajectory
%   sf1       handler to a function used to solve for the final time step
%   cntl      a structure of parameters for the solver
%                cntl.delta    controls the error
%                cntl.epsilon  controls the residual
%                cntl.maxit    controls maximum number of iterations
%   sf2       handler to a function used to solve for elevations
%   sp2       structure controlling the behavior of sf2
%               sp2.delta  absolute error tolerance
%               sp2.eps    absolute residual tolerance
%               sp2.maxit  maximum number of iterations allowed
%
% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-05  Initial programming and testing

% Determine the number of targets
m=numel(r);

% Sort the targets in ascending order
r=sort(reshape(r,m,1));

% Number of test trajectories
n=9; 

% Prepare for a number of test firings
psi=linspace(0,pi/2,n);

% Compute an auxiliary table that is used to obtain crude brackets
aux=compute_range(param,v0,psi,method,dt,maxstep,sf1,cntl);

% Initialize the number of trajectories computer
count=n;

% Allocate space for the table
table=zeros(m,5);

% Number of decimal digits of m 
num=floor(log10(m)+1);
fprintf('Computing firing solutions for %*d targets \n',num,m);

% Main loop over the targets
for i=1:m
    fprintf('.'); 

    % Save the ith range in the table
    table(i,1)=r(i);
    
    % Residual for the ith target
    res=@(theta)r(i)-range_rkx(param,v0,theta,method,dt,maxstep,sf1,cntl);
 
    % Find brackets for the low and high trajectories
    [a, b, idx]=find_bracket(2, r(i), aux(:,1), aux(:,2));
    
    % Set the brackets and the residuals
    sp2.xval=[a(1); b(1)];
    sp2.fval=r(i)-aux(idx(1):idx(1)+1,2);
       
    % ////////////////////////////////////////
    % Compute the low elevation
    % ////////////////////////////////////////
        
    % Find the low elevation
    [theta, ~, it]=sf2(res,sp2);       
    
    % Compute the flight time
    [~, ~, t, ~]=range_rkx(param,v0,theta,method,dt,maxstep,sf1,cntl);
        
    % Save the results
    table(i,2)=theta;
    table(i,3)=t(end);
    
    % Update the number of trajectories computed
    count=count+it+1;
    
    % ////////////////////////////////////////
    % Compute the high elevation
    % ////////////////////////////////////////
    
    % Set the brackets and the residuals
    sp2.xval=[a(2); b(2)];
    sp2.fval=r(i)-aux(idx(2):idx(2)+1,2);
    
    % Compute the high elevation
    theta=sf2(res,sp2);
   
    % Compute the flight time
    [~, ~, t, ~]=range_rkx(param,v0,theta,method,dt,maxstep,sf1,cntl);
    
    % Save the result
    table(i,4)=theta;
    table(i,5)=t(end);
    
    % Update the number of trajectories computed
    count=count+it+1;
    
end

if (m>0)
    fprintf('\n\n');
end