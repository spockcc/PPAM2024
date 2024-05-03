% SHAKEs pendulum

% Clear the workspace
clear;

% Define the pendulum 
pendulum1; 

% /////////////////////////////////////////////////////////
%   Define the time interval and the number of steps
% /////////////////////////////////////////////////////////

% Set the number of periods
np=500;

% Set the number of samples to record
N1=20*np;

% Set the number of time steps between recorded samples
N2=[10 20 40];

% Define the time interval
a=0; b=N1*period;

% /////////////////////////////////////////////////////////
%   Set parameters for the constraint solver
% /////////////////////////////////////////////////////////

% Specify the methods used
method={'newton','quasi'};

% Speficy the tolerance
tol=[1e-12,1e-4];

% Number of iterations pr. equations solved
maxit=20;

% Allocate space to store the data
data=zeros(N1+1,2,3,2);

% Loop over the method
for l=1:2
    % Loop over the columns
    for j=1:3
        % Loop over the tolerances
        for i=1:2
            [r, v, t, lambda, it, residual, flag, energy]=...
                shake(r0, v0, param, a, b, N1, N2(j), method{l}, tol(i), maxit);
            data(:,i,j,l)=energy';            
        end
    end
end


% Loop over the method
for l=1:2
    % Loop over the columns
    for j=1:3
        % Loop over the tolerances
        for i=1:2
            % Extract energy
            energy=data(:,i,j,l);
            % Plot the energy drift
            subplot(4,3,(l-1)*6+(i-1)*3+j); 
            plot((energy-energy(1))./energy(1));
        end
    end
end