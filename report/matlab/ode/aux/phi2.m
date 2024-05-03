function z=phi2(f,t,y,dt)

% PHI2 Kernel for a second order explicit Runge-Kutta method
%
% Advances the solution of the ODE
%
%     y'(t) = f(t,y(t))
%
% a single time step using Heyn's method.
%
% See also: RK, PHI1, PHI3, PHI4

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se) 
%  Apr 2014   :  Initial coding and testing.
%  Oct 2014   :  Minor changes to the text.
%  2015-06-23 :  Reformated during yearly review.

% Compute auxiliary coefficients
k1=f(t,y); 
k2=f(t+dt,y+dt*k1);

% Advance the solution a single step
z=y+0.5*dt*(k1+k2);

