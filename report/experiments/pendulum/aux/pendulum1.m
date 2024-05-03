% Defines a pendulum that moves in a plane

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-04-26 Adapted from existing code


% Define the dimension of the vector space
dim=2;

% Define the mass of the particle
mass=1;

% Define the constant of gravity
grav=9.82;

% Define the potential
phi=@(x)mass*grav*x(dim);

% Define the constant forcefield
f=@(x)[0; -mass*grav];

% Define the length of the pendulum
l=1;

% Define the point where the pendulum is attached
s=[0; l];

% Define the constraint function
g=@(r)0.5*(l^2-norm(s-r)^2);

% Define the Jacobian of the constraint function
dg=@(r)(s-r)';

% Compute theoretical period
period=2*pi*sqrt(l/grav);

% //////////////////////////////////////////////////////////////
%  The initial condition of the system
% //////////////////////////////////////////////////////////////

% Initial position of the pendulum.
r0=[0; 0];

% Initial velocity of the pendulum.
v0=[1; 0];

% ///////////////////////////////////////////////////////////
%  Describe the physics
% ///////////////////////////////////////////////////////////

% Set the dimension of the vector space
param.dim=dim;

% Number of constraints
param.m=1;

% Number of atoms
param.n=1;

% Mass of particles
param.mass=mass;

% Potential
param.phi=phi;

% Forcefield
param.f=f;

% Constraint function
param.g=g;

% Jacobian of constraint function
param.dg=dg;