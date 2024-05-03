% Compute the range of shells of different types

% Clear the work space
clear;

% Load the gun
d20;

% Load all shells
load shells

% Set the number of shell types
numshell=1;

% Set the method used to integrate the trajectory
method='rk1';

% Set the order of the method
p=1;

% Appropriate file name
fname="ballistics/mwe/data/d20_mwe1.mat";

% Create a list of drag functions
f=cell(numshell,1);
f{1}=mcg7;
f{2}=mcg2;
f{3}=mcg5;
f{4}=mcg6;
f{5}=mcg1;
f{6}=mcg8;

tit=cell(numshell,1);
tit{1}='G7';
tit{2}='G2';
tit{3}='G5';
tit{4}='G6';
tit{5}='G1';
tit{6}='G8';

% Set the solver for the final timestep
solver=@robust_secant;

% Set the number of approximations
kmax=10;

% Tolerance used to control the final solve
tol=2.^(-53); 

% Check if the raw data exists
if ~isfile(fname)
    % Mark the start time
    rt=cputime;
    disp("Generating raw data");
    % Allocate space for the output
    raw_range=zeros(kmax,numshell);
    raw_theta=zeros(kmax,numshell);

    % Set the tolerance for the final solve
    cntl.eps=tol; % eps(1)/2;
    cntl.delta=tol; % eps(1)/2;
    cntl.maxit=10;

    % Loop over the different shells
    for j=1:numshell
        % Select the drag coefficient
        param.drag=f{j};
        % Set the time step and maxstep
        dt=4; maxstep=100;
        % Loop over the time step size
        for i=1:kmax
            % Display progress indicator
            disp([(j-1)*kmax+i numshell*kmax]);
            % Define the range function
            rf=@(theta)range_rkx(param, v0, theta, method, dt,...
                maxstep, solver, cntl);
            % Find the largest range
            [theta,r]=gss(rf,0,pi/2,eps(1)*pi/4,53);
            % Save the range
            raw_range(i,j)=r;
            raw_theta(i,j)=theta;
            % Reduce the timestep and increase maxstep
            dt=dt/2; maxstep=maxstep*2;
        end
    end
    % Compute the runtime
    rt=cputime-rt;
    % Save all the raw data
    save(fname);
else
    disp("Loading raw data");
    load(fname);
end

% Allocate space for the data
data=zeros(kmax,4,numshell);

% Process the data and generate the plots

% Get a handle to a new figure
fig=figure();

% Loop over the shell types
for j=1:numshell
    % Apply Richardson extrapolation
    data(:,:,j)=richardson(raw_range(:,j),p);
    % Plot the fraction
    sf=subplot(2,3,j); plot_fraction(data(:,:,j),p);
    % Set the title
    sf.Title=title(tit{j});
end
sgtitle(['log2(tol) =' num2str(log2(tol),'%d')]);