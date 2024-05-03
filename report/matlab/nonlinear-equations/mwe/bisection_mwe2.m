% It is hard to compute roots that are not simple ...

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-06  Essentially rewritten from scratch

% Define two polynomials that are identical in exact arithmetic ...
p=@(x)(x-2).^3; 
q=@(x)x.^3-6*x.^2+12*x-8;

% Define the initial bracket
a=-pi; b=pi;

% ////////////////////////////////////////
% Set common parameters
% ////////////////////////////////////////

% Set the initial bracket
bp.val=[a; b]; 

% Break if the length of a bracket is less than delta
bp.delta=0; 

% Break if absolute value of the last residual is less than eps
bp.eps=0;

% Limit the maximum number of iterations
bp.maxit=60;

% ////////////////////////////////////////
% Set parameters specific to p
bp.fval=p(bp.val);

% Solve p(x) = 0
[~, ~, ~, pdata]=bisection(p,bp);
% ////////////////////////////////////////

% ////////////////////////////////////////
% Set parameters specific to q
bp.fval=q(bp.val);

% Solve q(x) = 0
[~, ~, ~, qdata]=bisection(q,bp);
% ////////////////////////////////////////


% ////////////////////////////////////////
%  Display the output nicely
% ////////////////////////////////////////

% Obtain parameters for printing the table
tp=table_param('bisection');

% Print the tables
print_table(pdata, tp);
print_table(qdata, tp);