function z=phi1(f,t,y,dt)

% PHI1 Kernel for Euler's explicit method of order 1
%
% Advances the solution of the ODE 
%
%     y'(t) = f(t,y(t))
%
% a single time step using Euler's explicit method.
%
% See also: RK, PHI2, PHI3, PHI4

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se) 
%  Apr 2014   :  Initial coding
%  Oct 2014   :  Minor changes to the text.
%  2015-06-23 :  Reformated during yearly review.

% Compute the auxiliary coefficient
k1=f(t,y); 

% Advance the solution a single time step
z=y+dt*k1;

