% Computes the range of a shell fired from the PzH-2000

% Load a representation of the SPA PzH-2000
pzh2000;

% ///////////////////////////////////////////
% Specify how to compute the final time step
% ///////////////////////////////////////////

% This is a subtle question ...
solver=@bisection;
cntl.delta=eps(1)/2;
cntl.eps=eps(1)/2;
maxit=60;

% ////////////////////////////////////////
% Set time step and elevation
% ////////////////////////////////////////

% Set the elevation of the barrel of the gun
theta=60*pi/180; 

% Compute range r and trajectory tra of shell
[r, flag, t, tra]=range_rkx(param,v0,theta,...
    method,dt,maxstep,solver,cntl);

% ////////////////////////////////////////
% Generate a nice plot of the trajectory
% ////////////////////////////////////////

% Get the corners of the screen
screen=get(groot,'Screensize'); 

% Get the width and height of the screen (pixels)
sw=screen(3); sh=screen(4);

% Get a handle to a new figure
hFig=gcf;

% Set the position of the desired window
set(hFig,'Position',[0 sh/4 sw/2 sh/2]);

% Plot the trajectory of the shell.
plot(tra(1,:),tra(2,:),tra(1,:),tra(2,:),...
    'o','MarkerFaceColor','r','MarkerSize',8); 

% Turn on grid lines 
grid on; grid minor; 

% Set the axis
axis([0,26000,0,14000]);

% Print the range
fprintf('Range of shell = %.2f meter\n',r);