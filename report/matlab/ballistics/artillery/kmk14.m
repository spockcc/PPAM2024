% 420 mm heavy siege gun ("Dicke Bertha"), Germany, WWI

% Data extracted from:
% https://en.wikipedia.org/wiki/Big_Bertha_%28howitzer%29

% Ensure that the shell models are loaded
load shells

% Set the mass of the shell
param.mass=820;

% Caliber in meters
param.cali=0.420;

% Select projectile type G1 (based on visual comparison by CCKM)
param.drag=@(x)mcg1(x);

% Select standard atmosphere
param.atmo=@(x)atmosisa(x);

% Select standard gravity
param.grav=@(x)9.80665;

% Select muzzle velocity
v0=400; 

% Select method and time step for integration
method='rk1'; dt=1; 

% Select maximum number of timesteps
maxstep=1000;

% Display header
fprintf('"Dicke Bertha" firing G1 shells loaded\n\n');