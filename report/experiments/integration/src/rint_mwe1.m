% Numerical integration of a function that is everywhere smooth

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-04-09  Adapted from 5dv231ht23 taught by CCKM at UmU


% Clear the work space
clear;

% Dimensions of figures in pixel
height=360;

% Line width
lw=4;

% Fontsize
fs=16;

% Interval
a=0; b=1; 

% Function
f=@(x)exp(x); 

% Antiderivative
F=@(x)exp(x)

% Integration rule
rule=@(y,a,b,N)trapezoid(y,a,b,N); 

% Theoretical order of the method 
p=2; 

% Number of approximations
kmax=20; 

% True value of the integral 
val=F(b)-F(a);

% Apply Richardson's techniques
data=rint(f,a,b,rule,p,kmax,val);

% Obtain table parameters
tp=table_param('rdif',data);

% Print the information nicely on the screen
print_table(data,tp);

% Define path to figures
mypath='../experiments/integration/fig/';

% ////////////////////////////////////////
% Generate Figure rint_mwe1a
% ////////////////////////////////////////

% Plot the evolution of Richardson's fraction
figa=figure(); plta=plot_fraction(data,p);

% Set the fontsize for the axes
axa=figa.CurrentAxes; axa.FontSize=16; % axa.GridLineWidth=2;

% Set the linewidth for the plot
plta.LineWidth=lw;

% Set the position and size
figa.Position=[900 800 560 height];

% Save the figure
fname='rint_mwe1a.eps'; saveas(figa,strcat(mypath,fname));

% ////////////////////////////////////////
% Generate Figure rint_mwe1b
% ////////////////////////////////////////

% Plot the error and the error estimate and the comparison
figb=figure();

% Isolate the relevant columns
k=data(:,1); err=data(:,5); rel=data(:,6);

% Plot the data
hold on;
pltb1=plot(k,log10(abs(err)),'b-');
pltb2=plot(k,log10(abs(rel)),'b:');
axis([0 kmax -14 2]);
grid; lgdb=legend('log_{10}(|E_h|)','log_{10}(|E_h-R_h|/|E_h|)', ...
    'Location','SouthWest');
xlabel('k');

% Set the fontsize for the axes
axb=figb.CurrentAxes; axb.FontSize=16; % axb.GridLineWidth=2;

% Set the linewidth for the plot
pltb1.LineWidth=lw; pltb2.LineWidth=lw;

% Set the position and size
figb.Position=[900 800 560 height];

% Save the figure
fname='rint_mwe1b.eps';
saveas(figb,strcat(mypath,fname));