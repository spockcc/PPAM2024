% Compute the maximum range of the D-20 using different shells and RK1
%
% To generate the figures that fit in the manuscript leave ppam2024=true.
% If you want all possible figures, set ppam2024=false


% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.um.se
%   Spring 2024   Initial programming and testing

% Clear the work space
clear;

% Logical switch
ppam2024=true;

% Height of a single row of figures in pixels
height=300;

% Line width
lw=2;

% Fontsize
fs=16;

% Define the howitzer, atmosphere, gravity
d20;

% Load all shells
load shells

% Set the number of shell types
numshell=6;

% Set the method used to integrate the trajectory
method='rk1';

% Set the order of the method
p=1;

% Set path to data and figures
datpath='../experiments/maxrange/dat/';
figpath='../experiments/maxrange/fig/';

% Set file name
fname='maxrange_rk1.mat'; 
fname=strcat(datpath,fname);

% Create a list of drag functions
f=cell(numshell,1);
f{1}=mcg1;
f{2}=mcg2;
f{3}=mcg5;
f{4}=mcg6;
f{5}=mcg7;
f{6}=mcg8;

tit=cell(numshell,1);
tit{1}='G1';
tit{2}='G2';
tit{3}='G5';
tit{4}='G6';
tit{5}='G7';
tit{6}='G8';

% Set the solver for the final timestep
solver=@bisection;

% Set the number of approximations
kmax=12;

% Array for tolerances
aux=4:7:53; numtol=numel(aux); tol=2.^(-aux);

% Check if the raw data exists
if ~isfile(fname)
    % Mark the start time
    rt=cputime;
    disp("Generating raw data");
    % Allocate space for the output
    raw_range=zeros(kmax,numshell,numtol);
    raw_theta=zeros(kmax,numshell,numtol);
    % Loop over the different tolerance
    for t=1:numtol
        % Set the tolerance for the final solve
        cntl.eps=tol(t); % eps(1)/2;
        cntl.delta=tol(t); % eps(1)/2;
        cntl.maxit=60;

        % Loop over the different shells
        for j=1:numshell
            % Select the drag coefficient
            param.drag=f{j};
            % Set the time step and maxstep
            dt=4; maxstep=100;
            % Loop over the time step size
            for i=1:kmax
                % Display progress indicator
                disp([(t-1)*numshell*kmax+(j-1)*kmax+i numtol*numshell*kmax]);
                % Define the range function
                rf=@(theta)range_rkx(param, v0, theta, method, dt,...
                    maxstep, solver, cntl);
                % Find the largest range
                [theta,r]=gss(rf,0,pi/2,eps(1)*pi/4,53);
                % Save the range
                raw_range(i,j,t)=r;
                raw_theta(i,j,t)=theta;
                % Reduce the timestep and increase maxstep
                dt=dt/2; maxstep=maxstep*2;
            end
        end
    end
    % Compute the runtime
    rt=cputime-rt;
    % Save all the raw data and the runtime
    save(fname,'raw_range','raw_theta','rt');
else
    disp("Loading raw data");
    load(fname);
end

% Allocate space for the data
data=zeros(kmax,4,numshell,numtol);

if (ppam2024==false)

    % Process all data and generate the plots
    for t=1:numtol
        % Get a handle to a new figure
        fig=figure();
        % Plan where to put the figure
        q=floor((t-1)/4); r=(t-1)-4*q;
        % Position on screen
        fig.Position=[10+r*300 650-q*600 840 2*height];
        % Loop over the shell types
        for j=1:numshell
            % Apply Richardson extrapolation
            data(:,:,j,t)=richardson(raw_range(:,j,t),p);
            % Plot the fraction
            sf=subplot(2,3,j); plt=plot_fraction(data(:,:,j,t),p);
            % Set the title
            sf.Title=title(tit{j});
            
            % Set the fontsize for the axes
            ax=fig.CurrentAxes; ax.FontSize=fs; % ax.GridLineWidth=2;
            
            % Set the linewidth for the plot
            plt.LineWidth=lw;
        end
        % Set the title
        sgtitle(['log_2(tol) =' num2str(log2(tol(t)),'%d')]);
        
        % Save the figures
        fname=strcat(figpath,'maxrange_rk1_tol',...
            num2str(-log2(tol(t)),'%02d'),'.eps');
        saveas(fig,fname);
    end
    
else
    
    % Process all data, but only generate plots for G5, G6, G7
    for t=1:numtol
        % Get a handle to a new figure
        fig=figure();
        % Plan where to put the figure
        q=floor((t-1)/4); r=(t-1)-4*q;
        % Position on screen
        fig.Position=[10+r*300 650-q*600 840 height];
        % Loop over the shells
        for j=1:numshell
            % Apply Richardson extrapolation
            data(:,:,j,t)=richardson(raw_range(:,j,t),p);
            % Only generate plots for G5, G6, G7
            if (3<=j && j<=5)
                % Plot the fraction
                sf=subplot(1,3,j-2); plt=plot_fraction(data(:,:,j,t),p);
                % Set the title
                sf.Title=title(tit{j});
                
                % Set the fontsize for the axes
                ax=fig.CurrentAxes; ax.FontSize=fs; % ax.GridLineWidth=2;
                
                % Set the linewidth for the plot
                plt.LineWidth=lw;
            end
        end
        % Set the title
        sgtitle(['log_2(tol) =' num2str(log2(tol(t)),'%d')]);
        
        % Save the figures
        fname=strcat(figpath,'maxrange_rk1_tol',...
            num2str(-log2(tol(t)),'%02d'),'.eps');
        saveas(fig,fname);
    end
    
end

% Obtain table parameters
tp=table_param('rdif',data(:,:,1,numtol));

% Print Richardson's data for the smallest value of tol.
for j=1:numshell
    fprintf('%s\n',tit{j});
    print_table(data(:,:,j,numtol),tp);
    fprintf('\n\n');
end

% Generate the table for the paper
fprintf('Shell type  Maximum range (m) Error estimate (m)\n')
for j=1:numshell
    fprintf('    %2s           %.0f                %.1f \n',tit{j},data(kmax,2,j,numtol),data(kmax,4,j,numtol));
end