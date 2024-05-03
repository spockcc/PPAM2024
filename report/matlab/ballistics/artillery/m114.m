% M114 155 mm howitzer, USA, WWII

% Data extracted from
% https://en.wikipedia.org/wiki/M114_155_mm_howitzer

% Ensure that the shell models are loaded
load shells

% Set the mass of the shell
param.mass=41.86;

% Caliber in meters
param.cali=0.15471;

% Select projectile type G7 (based on visual comparison by CCKM)
param.drag=@(x)mcg7(x);

% Select standard atmosphere
param.atmo=@(x)atmosisa(x);

% Select standard gravity
param.grav=@(x)9.80665;

% Select muzzle velocity
v0=563; 

% Select method and time step for integration
method='rk1'; dt=1; 

% Select maximum number of timesteps
maxstep=1000;

% Print header
fprintf('M114 155mm howitzer firing G7 shells (boat-tail) loaded\n\n');