function f=modified_coulomb_force(dim,n,q,r,k,g)

% Compute the forces acting on a collection of charge particles
%
% CALL SEQUENCE: f=modified_coulomb_force(dim,n,q,r,k,g)
%
% INPUT:
%   dim  the dimension of the vector space
%   n    the number of particles
%   q    q(i) is the charge of particle i
%   r    r(dim*(i-1)+1:dim*i) is the location of particle i
%   k    is a scaling constant, see below
%   g    handle, scaling function, see below
%
% OUTPUT:
%   f    f(dim*(i-1)+1:dim*i) is the total force acting on particle i
%
% The force acting on particle i is given by
%
%  f(i) = k*q(i)*sum_{j \not i} [q(j)/norm(r(i)-r(j),2)^3]*(r(i)-r(j))
%
% In SI units the constant k is k = 1/(4*pi*epsilon_0)
%
% MINIMAL WORKING EXAMPLE: TODO

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2022-03-01 Initial programming and testing
%   2022-08-03 Added support for finite dimensional vector spaces

% Initialize the output
f=zeros(dim*n,1);

% Auxiliary array of zeros
z=zeros(dim,1);

% Main loop
for i=1:n-1
    % Isolate indices for simplicity's sake
    ai=dim*(i-1)+1; bi=dim*i;
    % Isolate the position of particle i
    ri=r(ai:bi); 
    % Nullify the accumulator for f(ii)
    aux=z; 
    % Precompute scaling factor
    kqi=k*q(i);
    % Inner loop
    for j=i+1:n
        % Isolate indices for simplicity's sake
        aj=dim*(j-1)+1; bj=dim*j;
        % Isolate the vector from atom j to atom i
        rji=ri-r(aj:bj);
        % Compute the norm
        nrji=norm(rji);
        % Compute the force by particle j on particle j
        fji=kqi*q(j)/nrji^3*rji;
        % Apply the scaling
        fji=fji*g(nrji);
        % Add the force to the accumulator for f(ii)
        aux=aux+fji;
        % Subtract the force from fj
        f(aj:bj)=f(aj:bj)-fji;
    end
    % Update f(ii)
    f(ai:bi)=f(ai:bi)+aux;
end