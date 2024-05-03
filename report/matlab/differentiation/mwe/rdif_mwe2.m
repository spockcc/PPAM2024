% RDIF_MWE2  Analyze 2nd order accurate finite difference method

% Set trial function
f=@(x)exp(x); 

% Set point where we want to estimate the derivative
x=1; 

% Define the finite difference approximation
D2=@(g,x,h)(g(x+h)-g(x-h))./(2*h); 

% Set the theoretical order of the method
p=2; 

% Set the basic stepsize
h0=0.125; 

% Set the number of times we will reduce the stepsize by a factor of 2
kmax=20; 

% Define the real derivative
df=@(x)exp(x);

% Apply Richardson's techniques
data=rdif(f,x,D2,p,h0,kmax,df);

% Obtain table parameters
tp=table_param('rdif',data);

% Print the information nicely
print_table(data,tp);

% Plot the evolution of Richardson's fraction
fig=plot_fraction(data,p);




