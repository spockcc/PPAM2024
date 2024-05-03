% MAKE_SHELLS  Build drag functions for standard shells

% Defines the drag coefficient functions 
% for G1, G2, G5, G5, G8, G7 and G8 type shells
%
% The raw data has been downloaded from this address
% https://jbmballistics.com/ballistics/downloads/downloads.shtml
% 
% The original source of this data is the late Robert L. McCoy
% of US Army's Ballistics Research Laboratory
%
% The abbreviation McG refers to McCoy and the
% Gâvre Commission who defined the standard shells

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   201X-YY-ZZ Initial programming and testing
%   2024-03-04 Reformatted during yearly review

% Load the ascii file
A=importdata('mcg1.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2));
mcg1=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Load the ascii file
A=importdata('mcg2.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2)); 
mcg2=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Load the ascii file
A=importdata('mcg5.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2)); 
mcg5=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Load the ascii file
A=importdata('mcg6.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2)); 
mcg6=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Load the ascii file
A=importdata('mcg7.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2)); 
mcg7=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Load the ascii file
A=importdata('mcg8.txt');

% Construct the corresponding spline
cs=spline(A(:,1),A(:,2)); 
mcg8=@(x)ppval(cs,x);

% ////////////////////////////////////////

% Save the spline functions
save shells.mat mcg1 mcg2 mcg5 mcg6 mcg7 mcg8