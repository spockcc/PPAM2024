% PLOT_SHELLS  Plot drag functions for standard shells
%
% Plot the drag coefficient functions for the 
% G1, G2, G5, G5, G8, G7 and G8 type shells

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   201X-YY-ZZ Initial programming and testing
%   2024-03-04 Updated and reformatted

% Load the shell functions
load shells;

% Define a range of Mach numbers
ma=linspace(0,5,1001);

% Get coordinates of the corners of the screen
screen=get(groot,'Screensize'); 

% Get width and height of the screen (pixels)
sw=screen(3); sh=screen(4);
 
% Get a handle to the current figure
hFig=gcf; clf;

% Set the size and position of the figure
set(hFig,'Position',[sw/4 sh/4 sw/2 sh/2]);

% ////////////////////////////////////////
% Plot the drag coefficient functions 
% ////////////////////////////////////////

subplot(2,3,1); plot(ma,mcg1(ma)); 
title('g1 drag coefficient'); axis([0,5,0,0.7]);
xlabel('Mach number'); grid;

subplot(2,3,2); plot(ma,mcg2(ma)); 
title('g2 drag coefficient'); axis([0,5,0,0.7]);
xlabel('Mach number'); grid;

subplot(2,3,3); plot(ma,mcg5(ma)); 
title('g5 drag coefficient'); axis([0,5,0,0.7]);
xlabel('Mach number'); grid;

subplot(2,3,4); plot(ma,mcg6(ma)); 
title('g6 drag coefficient'); axis([0,5,0,0.7]); 
xlabel('Mach number'); grid;

subplot(2,3,5); plot(ma,mcg7(ma)); 
title('g7 drag coefficient'); axis([0,5,0,0.7]); 
xlabel('Mach number'); grid;

subplot(2,3,6); plot(ma,mcg8(ma)); 
title('g8 drag coefficient'); axis([0,5,0,0.7]); 
xlabel('Mach number'); grid;