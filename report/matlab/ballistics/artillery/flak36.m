% 88 mm anti-aircraft gun, Germany, WWII
% Data extracted from:
% https://en.wikipedia.org/wiki/8.8_cm_Flak_18/36/37/41

% Ensure that the shell models are loaded
load shells

% Set the mass of the shell
param.mass=9.2;

% Caliber in meters
param.cali=0.088;

% Select projectile type G6 (based on visual comparison by CCKM)
param.drag=@(x)mcg6(x);

% Select standard atmosphere
param.atmo=@(x)atmosisa(x);

% Select standard gravity
param.grav=@(x)9.80665;

% Select muzzle velocity
v0=840; 

% Select method and time step for integration
method='rk1'; dt=0.25; 

% Select maximum number of timesteps
maxstep=800;

% Print header
fprintf('Flak 36 anti-aircraft gun firing G6 shells loaded\n\n');