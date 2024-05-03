% Generates a valid configuration for a chain of particles

% Initialize the random generator
rng(2022);

% Set the number of atoms
n=15;

% Set the number of bonds
m=n-1;

% Set the bond lengths
l=(1:m); l=mod(l,2)+1;

% Set the dimension of the vector space
dim=3;

% Include this information in the parameters
param.dim=dim;

% Define the parameters of the chain
param.n=n;
param.l=l;

% Define the constraint function
g=@(q)chain(param,q);

% Define the Jacobian of the constraint function
dg=@(q)chain_jacobian(param,q);

% Add the constraint function and the Jacobian to the parameters
param.g=g;
param.dg=dg;

% Initialize the position of the atoms
q0=rand(dim*n,1)-rand(dim*n,1);

% Set the tolerance and maxit
tol=1e-14; maxit=100;

% Initialization
[q, flag, it, his, res]=initq(q0, param, tol, maxit);

if (dim==2 || dim==3)
    % Plot the solution
    for i=1:it+1
        aux=reshape(his(:,i),dim,n);
        % Plot the location of the atoms
        if (dim==3)
            plot3(aux(1,:),aux(2,:),aux(3,:),'-*');
        end
        if (dim==2)
            plot(aux(1,:),aux(2,:),'-*');
        end
        % Finalize the graphics
        s=strcat("i = ",num2str(i)," res = ",num2str(res(i))); title(s); grid; xlabel('x'); ylabel('y'); zlabel('z');
        % Pause 1 second before the next iteration
        pause(1);
    end
end
