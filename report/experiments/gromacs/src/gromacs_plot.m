function [fig, ax]=gromacs_plot(field, tol, n, ekin, epot, etol)

fig=figure(); fig.Position=[100 800 1800 400];

subplot(1,3,1); 
plt1=plot(n,ekin); grid; 
xlabel('number of steps'); 
ylabel('Kinetic energy (kJ/mol)'); 

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=20; ax.LineWidth=2;

subplot(1,3,2); 
plt2=plot(n,epot); grid;

xlabel('number of steps');
ylabel('Potential energy (kJ/mol)');

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=20; ax.LineWidth=2;

subplot(1,3,3); 
plt3=plot(n,etol); grid;
xlabel('number of steps');
ylabel('Total energy (kJ/mol)');

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=20; ax.LineWidth=2;

% Set the linewidth for the plot
plt1.LineWidth=2;
plt2.LineWidth=2;
plt3.LineWidth=2;

% Set a common title
tit=sgtitle(['Forcefield = ' field '     constraint tolerance = ' num2str(tol,'%.2e')]);
tit.FontSize=20;