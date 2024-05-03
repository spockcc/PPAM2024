% Ion trap with dampning
% Runge-Kutta methods
% The forcefield transitions smoothly to zero 

% Set the central file name
datpath='../experiments/iontrap/dat/';
fname=strcat(datpath,"iontrap_mwe3.mat");

% Check if raw data exists
if ~isfile(fname)

    % Run experiment from scracth
    fprintf("Generating raw data\n");

    % Seed the generator
    seed=2024; rng(seed);

    % Set the number of particles
    n=4;

    % Set the spatial dimension
    dim=3;

    % Set the leading dimension of the arrays
    ld=n*dim;

    % Generate position and momenta
    q0=rand(ld,1)-rand(ld,1); p0=zeros(ld,1);

    % Set the charges
    charge=ones(n,1)/16;

    % Generate initial state
    x0=[q0; p0];

    % Spring constant
    spring=5;

    % Dampning
    damp=2;

    % Scaling factor for columb potential
    scale=1;

    % Set cutoff function
    rho=0.1462; rho1=0.5*rho; rho2=0.75*rho; cut=@(x)cut2(rho1, rho2, x);
    
    % Set the forcefield: coulomb force + springs + dampning
    f=@(q,p)modified_coulomb_force(dim,n,charge,q,scale,cut)-spring*q-damp*p;

    % Set the potential
    U=@(q)coulomb_potential(dim,n,charge,q,scale)-0.5*spring*norm(q)^2;

    % Set the function that drives the ODE
    g=@(t,x)[x(ld+1:2*ld,1); f(x(1:ld,1),x(ld+1:2*ld,1))];

    % The length of the simulation
    T=10;

    % Number of methods
    nm=4;

    % Define list of integration methods
    tit=cell(4,1);
    tit{1}='rk1';
    tit{2}='rk2';
    tit{3}='rk3';
    tit{4}='rk4';

    % Set the order of the primary error term
    order=[1; 2; 3; 4];

    % Number of samples
    N1=512;

    % Number of simulations/approximations
    kmax=12;

    % Allocate space for the raw data
    raw=zeros(2*ld,N1+1,kmax,nm);

    % Allocate space for the processed data
    table=zeros(kmax,4,nm);

    % Loop over the different methods
    for j=1:nm
        % Select the method
        method=tit{j};
        % Set steps between samples
        N2=1;
        % Loop over the different timestep sizes
        for k=1:kmax
            % Progress
            cnt=k+(j-1)*kmax; disp([cnt nm*kmax]);
            
            % Run the simulation
            [t, y]=rk(g,0,T,x0,N1,N2,method);
            % Save the state vectors
            raw(:,:,k,j)=y;
            % Prepare for the next iteration
            N2=N2*2;
        end
    end
    % Save all data
    save(fname);
else
    fprintf("Loading raw data\n");
    % Load data
    load(fname);
end
% Allocate space for potential energy
pot=zeros(kmax,nm);

% Allocate space for Richardson's tables
table=zeros(kmax,4,nm);

% Parameters for printing
tp=table_param('rdif',table(:,:,1));

% Loop over the methods
for j=1:nm

    % Loop over the time steps
    for k=1:kmax
        % Extract state vectors
        y=raw(:,:,k,j);
        % Exact state vector at the end of the sim
        aux=y(:,end);
        % Extract positions and momenta
        q=aux(1:ld); p=aux(ld+1:end);
        % Compute potential energy
        pot(k,j)=U(q);

    end

    % Apply Richardson extrapolation
    table(:,:,j)=richardson(pot(:,j),order(j));

    % Compute force at the end of last simulation
    val=norm(f(q,p));

    % Display information
    fprintf('Norm of force    = %e\n',val);
    fprintf('Potential energy = %e\n',pot(kmax,j));
    fprintf('Richardson extrapolation of the potential energy\n');
    print_table(table(:,:,j),tp);
    subplot(1,nm,j); plot_fraction(table(:,:,j),order(j));
end
