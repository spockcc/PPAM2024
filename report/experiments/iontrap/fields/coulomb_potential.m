function y=coulomb_potential(dim, n, q, r, k)

% Computes the potential energy of a collection of charged particles
%
% CALL SEQUENCE: y=columb_potential(dim, n, q, r, k)
%
% INPUT:
%   dim  the dimension of the vector space, say, dim=2 or dim=3
%   n    number of particles
%   q    q(i) is the charge of particle i
%   r    vector of positions, 
%          r(dim*(i-1)+1:dim*i) 
%        is the position of particle i
%   k    a constant used to scale the potential (optional)
%
% OUTPUT:
%   y    the potential energy of the system, see below
%
% The potential energy is merely the sum
%
%   y=k*sum_{i=1}^{n-1} [q(i)*[sum_{j=i+1}^n q(j)/norm(r(i)-r(j),2)]]
%
% In SI units the constant k is 
% 
%   k = 1/(4*pi*epsilon_0) 
%
% where epsilon_0 is the vacuum permittivity and
% 
%   epsilon_0 approx 8.854 187 812 813 times 10^(-12) F/m
%
%
% MINIMAL WORKING EXAMPLE: TODO
 
% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2022-02-01 Initial programming and testing
%   2022-08-03 Added support for finite dimensional vector spaces
%   2024-03-12 Improved documentation 


% Initialize the potential 
y=0;

% Loop over all pairs of particles
for i=1:n-1
    % Isolate the vector r(i)
    ri=r(dim*(i-1)+1:dim*i); 
    % Initialize the local accumulator
    aux=0;
    % Loop over all particles with a higher index
    for j=i+1:n
        % Isolate the vector r(j)
        rj=r(dim*(j-1)+1:dim*j); 
        % Compute the vector from atom i to atom j
        rij=rj-ri;
        % Added the contribution from the pair (i,j)
        aux=aux+q(j)/norm(rij,2);
    end
    % Perform the necessary scaling
    y=y+q(i)*aux;
end

% Perform the final scaling
y=k*y;