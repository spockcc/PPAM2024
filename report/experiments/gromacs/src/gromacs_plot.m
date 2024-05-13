function [fig, ax]=gromacs_plot(field, tol, n, ekin, epot)



fig=figure(); fig.Position=[100 800 1800 600];

subplot(1,2,1); 
plt1=plot(n,ekin); grid; 
xlabel('number of steps'); 
ylabel('Kinetic energy (kJ/mol)'); 

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=14; ax.LineWidth=2;

subplot(1,2,2); 
plt2=plot(n,epot); grid;

xlabel('number of steps');
ylabel('Potential energy (kJ/mol)');

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=14; ax.LineWidth=2;

% Set the linewidth for the plot
plt1.LineWidth=2;
plt2.LineWidth=2;

% Set a common title
tit=sgtitle(['Forcefield = ' field '     constraint tolerance = ' num2str(tol,'%.2e')]);
tit.FontSize=20;