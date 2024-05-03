function z=shell4a(param,t,x)

% SHELL4A Computes the forces on a shell moving in 2 dimensions

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  Fall 2014   Initial programming and testing
%  2015-09-22  Replaced globals  m, k, g with global structure CONST
%  2015-10-31  Replaced structure CONST with variable PARAM
%  2015-12-08  Added support for general wind
%  2016-06-30  Added support for general friction. Improved comments
%  2016-09-08  Improved support for atmosphere and shell models.
%  2024-03-05  Code reformated during yearly review

% Allocate space for the output
z=zeros(4,1); 

% Isolate the state vector (position, velocity)
aux=x;

% ////////////////////////////////////////
%  Take wind into account
% ////////////////////////////////////////

if isfield(param,'wind')
    % Compute the wind at the shell's position
    w=param.wind(t,x);     
    % Compute the relative wind velocity
    aux(3)=x(3)-w(1);
    aux(4)=x(4)-w(2);
end

% Compute the *relative* wind speed
v=sqrt(aux(3)^2+aux(4)^2);

% Compute the speed of sound and density using the atmospheric model
[~, a, ~, rho]=param.atmo(aux(2));

% Compute the local Mach number (shell speed)/(speed of sound)
ma=v./a;

% Compute the cross section of the shell
A=pi*(param.cali/2)^2;

% Evaluate the drag coefficient and compute k
% such that friction force has size k*v^2
k=0.5*A*param.drag(ma).*rho;

% ////////////////////////////////////////
% Extract mass and gravity from param
% ////////////////////////////////////////

% The mass is a constant
m=param.mass;

% In general, gravity is a function of position!
g=param.grav(x);

% ////////////////////////////////////////
% Compute time derivatives
% ////////////////////////////////////////

% The derivative of the position is the
% velocity relative to the ground
z(1)=x(3); 
z(2)=x(4);

% The derivative of the velocity is the
% acceleration. 
z(3)=  -(k/m)*v*aux(3);
z(4)=-g-(k/m)*v*aux(4);