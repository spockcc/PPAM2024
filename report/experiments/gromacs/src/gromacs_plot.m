function [fig, ax]=gromacs_plot(field, tol, n, ekin, epot)

% Figure height in pixels
height=600;

% Linewidth
lw=2;

% Fontsize 16
fs=32;

fig=figure(); fig.Position=[100 800 1800 height];

subplot(1,2,1); 
plt1=plot(n,ekin); grid; 
xlabel('number of steps'); 
ylabel('Kinetic energy (kJ/mol)'); 

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=fs; ax.LineWidth=lw;

subplot(1,2,2); 
plt2=plot(n,epot); grid;

xlabel('number of steps');
ylabel('Potential energy (kJ/mol)');

% Set the fontsize for the axes
ax=fig.CurrentAxes; ax.FontSize=fs; ax.LineWidth=lw;

% Set the linewidth for the plot
plt1.LineWidth=lw;
plt2.LineWidth=lw;

% Set a common title
tit=sgtitle(['Force field = ' field '     constraint tolerance = ' num2str(tol,'%.2e')]);
tit.FontSize=32;