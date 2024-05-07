% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-05-07 Programming and testing finalized

% Load the data
datpath='../experiments/gromacs/dat/';
fname=strcat(datpath,'gromacs_all.mat');
load(fname);

% Collect the structures containing energies into a cell array
cnt=4; c=cell(1,cnt); c{1}=O3; c{2}=O6; c{3}=C3; c{4}=C6; 

% HYPOTHESIS:
% The computed total energy satisfies
%  A = T + C1/n^p + C2*n
% where n is the number of time steps used to cover the interval
% and p is an integer.
% 
% This corresponds to a scheme that is pth order accurate in the 
% timestep, while accumulating rounding errors proportional to the 
% number of steps.

% Models tested
% Model M1 has p = 1
% Model M2 has p = 2

% We will do a least squares fit of the data.

% Isolate the number of equations and reshape n
m=numel(n); n=reshape(n,m,1);


% Selection of data points
% zoom = 1 narrows the selection to common time steps
% zoom = 0 uses all available data
zoom=0;

% Specify lowest and highest number of points
if (zoom==1)
    low=250; high=2100;
else
   low=0; high=Inf;
end

% Isolate the desired data points
idx=find(low<n & n < high); n=n(idx); m=numel(idx);

% Define the matrix corresponding to model M1
A1=zeros(m,3);
A1(:,1)=ones(m,1);
A1(:,2)=n;
A1(:,3)=1./n;

% Define the matrix corresponding to model M2
A2=zeros(m,2); 
A2(:,1)=ones(m,1); 
A2(:,2)=n;
A2(:,3)=1./n.^2; 

% Compute QR factorizations prior to least squares solve
[Q1, R1]=qr(A1);
[Q2, R2]=qr(A2);

% Allocate space for the componentwise relative residuals
mres1=zeros(cnt,1); % Residuals for model M1
mres2=zeros(cnt,1); % Residuals for model M2

% Process the data
for i=1:cnt
    % Isolate the kinetic and potential enecnbgy
    ekin=c{i}.data(idx,3);
    epot=c{i}.data(idx,4);
    % Compute total energy
    etol=epot+ekin;
   
    % Calculations for model M1
    % Solve A1x=etol in the least squares sense
    x1=R1\(Q1'*etol); 
    % Compute residual
    r1=etol-A1*x1; 
    % Compute componentwise relative residual
    res1=r1./etol;
    % Compute the largest value of res
    mres1(i)=norm(res1,'inf');

    % Calculations for model M2
    % Solve A2x=etol in the least squares sense
    x2=R2\(Q2'*etol); 
    % Compute residual
    r2=etol-A2*x2; 
    % Compute componentwise relative residual
    res2=r2./etol;
    % Compute the largest value of res
    mres2(i)=norm(res2,'inf');
end

% Compare the quality of M1 to M2
aux=(mres1<mres2);
% Display results
fprintf('Forcefield   tol        M1           M2          M1<M2\n');
for i=1:cnt
    fprintf('%10s   %6.2e   %10.4e   %10.4e   %2d\n',c{i}.field,c{i}.tol,mres1(i),mres2(i),aux(i));
end