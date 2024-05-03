function [x, flag, it, his, res, resnorm]=newton(f,sp)

% Solves a system of nonlinear equations using Newton's method
%
% An implementation of Newton's method for solving a non-linear equation
%
%        f(x) = 0
%
% with an initial guess x=x0. 
%
% CALL SEQUENCE:
%
% [x, flag, it, his, res, resnorm]=newton(f,param)
%
% INPUT:
%   f         a handler to the function f
%   sp        a structure with the following fields
%               sp.xval   the initial value
%               sp.eps    tolerance for absolute residual
%               sp.maxit  maximum number of iterations
%               sp.df     handler to the Jacobian
%
% OUTPUT:
%   x         the final approximation
%   flag      a flag signaling succes/failure,
%               flag = -1, if we did not converge
%               flag =  1, if we stagnated
%               flag =  2, if we have a small residual
%               flag =  3, if flag=1 and flag=2
%   it        the number of iterations completed
%   his       his(j) is the jth approximation
%   res       res(j) is the jth residual
%   resnorm   resnorm(j) is the norm of the jth residual
%
% MINIMAL WORKING EXAMPLE(s) newton_mwe1, newton_mwe2
% 
% See also: BISECTION, SECANT, ROBUST_SECANT

% PROGRAMMING by Carl Christian K. Mikkelsen (spock@cs.umu.se)
%  2014-10-20  Call sequence determined
%  2014-10-21  Initial implementation and testing
%  2014-11-20  More comments added in response to student questions
%  2015-10-16  Documentation edited
%  2016-06-27  Documentation edited. Added links to other methods
%  2016-06-27  Change code to conform to standard
%  2016-08-15  Minor changes to the documentation
%  2018-11-23  Move the minimal working examples to separate files
%  2018-11-23  Changed return codes
%  2020-11-01  Minor update of documentation
%  2024-04-03  Adapted to the standardized interface for all solvers

% Extract parameters
x0=sp.xval;
eps=sp.eps;
maxit=sp.maxit;
df=sp.df;

% Newton's method is tricky to apply, so flag=-1 is the default
flag=-1;

% Extract the dimension of the problem
n=numel(x0);

% Allocate space for approximations, residuals, and their norms
his=zeros(maxit,n); res=zeros(maxit,n); resnorm=zeros(maxit,1);

% Initialize the sequence with a column vector
x=reshape(x0,n,1);

for j=1:maxit
    % Save the current approximation into his
    his(j,:)=x';
    % Save the current residual
    y=f(x); res(j,:)=y';
    % Save the norm of the current residual
    resnorm(j)=norm(y);
    % Is the residual small enough?
    if (resnorm(j)<=eps)
        % We have converged to the specified tolerance
        flag=0; break;
    else
        % Do one step of Newton's method. 
        % This expression works for all n!
        x=x-df(x)\y;        
    end
end

% Remove any trailing zeros from output arrays
his=his(1:j,:); res=res(1:j,:); resnorm=resnorm(1:j);

% Set the number of iterations completed
it=j;