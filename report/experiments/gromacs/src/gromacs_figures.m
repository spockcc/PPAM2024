% Generate figures from GROMACS experiments by Lorien Lopez-Villellas

% PROGRAMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  Spring 2024  Initial programming and testing

% Set the path to figures
figpath='../experiments/gromacs/fig/';

% Load the data
datpath='../experiments/gromacs/dat/';
fname=strcat(datpath,'gromacs_all.mat');
load(fname);

% Collect the structures containing energies into a cell array
c=cell(1,4); c{1}=C3; c{2}=C6; c{3}=O3; c{4}=O6;

% Loop over the 4 sets of data
for i=1:4

    % Extract fields from the structure
    aux=c{i}.data; field=c{i}.field; tol=c{i}.tol;

    % Rename the columns to reduce the chance of misprints
    ekin=aux(:,3); epot=aux(:,4); % etol=ekin+epot;

    % Call specialized plotting routine
    [fig, ax]=gromacs_plot(field, tol, n, ekin, epot);

    fname=strcat(field,'tol',num2str(round(-log10(tol)),'%02d'),'.eps');
    saveas(fig,strcat(figpath,fname));

end
