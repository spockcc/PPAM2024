% 155 mm self-propelled howitzer, Germany, current era

% Data extracted from:
% http://www.navweaps.com/Weapons/WNGER_61-52_MONARC.htm

% Ensure that the shell models are loaded
load shells

% Set the mass of the shell
param.mass=44.5;

% Caliber in meters
param.cali=0.155;

% Select projectile type G7 (based on visual comparison by CCKM)
param.drag=@(x)mcg7(x);

% Select standard atmosphere
param.atmo=@(x)atmosisa(x);

% Select standard gravity
param.grav=@(x)9.80665;

% Select muzzle velocity
v0=945; 

% Select method and time step for integration
method='rk1'; dt=1; 

% Select maximum number of timesteps
maxstep=1000;

% Print header
fprintf('PzH-2000 firing G7 shells (boat-tail) loaded\n\n');