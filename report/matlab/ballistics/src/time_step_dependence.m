% Shows that the computed trajectory depends on the time step

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-09 Initial programming and testing

% Load a howitzer
d20;

% Set the time step sizes, maxstep and the elevation
dt=[1 5 10 15 20]; maxstep=200; theta=45*pi/180;

% ////////////////////////////////////////////////////////////////////
%  Select solver for computing the final time step for each trajectory
% ////////////////////////////////////////////////////////////////////
solver=@robust_secant;

% Control parameters for this solver
cntl.delta=eps(1)/2;
cntl.eps=eps(1)/2;
cntl.maxit=20;

% Compute and print several approximations of the trajectory
fig=figure(); hold on;

% Plot several trajectories and construct a legend
n=numel(dt); lgd=cell(n,1);
for i=1:n
    % Compute trajectory using time step dt(i)
    [r, flag, t, tra]=range_rkx(param, v0, theta, method, dt(i), maxstep, solver, cntl);
    % Plot the computed trajectory
    plot(tra(1,:),tra(2,:),'LineWidth',2);
    % Construct a entry in the legend
    lgd{i} = strcat('dt =',num2str(dt(i))) ;
end

% Labels and grids
xl=xlabel('x (meter)'); xl.FontSize=18;
yl=ylabel('y (meter)'); yl.FontSize=18;
grid on; grid minor;

% Legend
leg=legend(lgd); 
leg.FontSize=18;

% Title
tit=title('The computed trajectory depends on the time step');
tit.FontSize=18