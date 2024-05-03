function [x, flag, it, data]=bisection(f,sp)

% Solves a nonlinear equation using bisection
%
% Attempts to solve the non-linear equation scalar equation
%
%   f(x) = 0
%
% using the bisection algorithm.
%
% CALL SEQUENCE:
%
%   [x, flag, it, data]=bisection(f,param)
%
% INPUT:
%   f        a handler to the function f
%   sp       a structure with the following fields
%              xval     the initial bracket
%              fval     the corresponding function values
%              delta    break if abs(a(it)-b(it)) < delta
%              eps      break if abs(res(it)) < eps
%              maxit    break if it=maxit
%
% OUTPUT:
%   x        the final approximation of the root
%   flag     a flag signaling succes/failure, if flag = 
%              -1,  then the initial bracket was bad
%               0,  then the iteration did not converge
%               1,  then the last bracket has length less than delta
%               2,  then the last residual has size less than eps
%               3,  then the two previous conditions are both true
%   it       the number of iterations completed
%   data     an it by 5 array
%               data(j,1)   = j
%               data(j,2:3) = [a(j) b(j)], the jth bracket
%               data(j,4)   = his(j), the jth approximation of x
%               data(j,5)   = res(j), the the corresponding residual
%
% A bad bracket is a pair of points a, b, such that f(a)*f(b) >= 0. In this
% case, we can not conclude that there is a root strictly between a and b. 
%
% MINIMAL WORKING EXAMPLE: bisection_mwe1
%
% See also: NEWTON, SECANT, ROBUST_SECANT

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  2014-05-12  Initial programming and testing
%  2014-10-20  Call sequence and comments improved
%  2014-11-12  All arguments are now assigned values regardless of flag
%  2014-11-16  Program rewritten from scratch to clarify the logic
%  2015-09-22  Minor improvements to the documentation and comments
%  2016-06-14  Minor improvements to the documentation and comments
%  2016-06-21  Program rewritten from scratch to conform with secant family
%  2016-06-27  Integrated displaytable(). Added links to other methods.
%  2016-08-15  Minor changes to the documentation
%  2016-11-14  Fixed incomplete initialisation
%  2016-11-16  Fixed error in call sequence.
%  2016-11-25  Fixed error in call sequence documentation.
%  2017-10-25  Rename pflag to print
%  2019-11-12  Minimal working example moved to separate file
%  2024-03-09  Adjusted to the new common interface

% DEBUGGING:
%  2016-11-11  Incomplete initialization located by Hanna Konradsson
%  2016-11-15  Error in call sequence found by Mikael Johannsson

% TODO:
%   CCKM  Go over the "rare" cases again and update the documentation
%   CCKM  Allow for solution of g(f(x)) = 0, returning BOTH x and f(x)

% Extract all variables from the structure
x0=sp.xval(1);
x1=sp.xval(2);
f0=sp.fval(1);
f1=sp.fval(2);
delta=sp.delta; eps=sp.eps; maxit=sp.maxit;

% Solving nonlinear equations is hard, so assume non-convergence.
flag=0;

%--------------------------------------------------------------------------
% Sanity check of the input
%--------------------------------------------------------------------------

% In MATLAB
%    sign(x) = +1, if x is strictly positive
%    sign(x) =  0, if x is zero
%    sign(x) = -1, if x is strictly negative, 

% Protect against "rare" events!
if sign(f0)==0
    flag=2; x=x0; 
end

if sign(f1)==0
    flag=2; x=x1; 
end

if (flag==2)
    % Initialize all variables
    a=min(x0,x1); b=max(x0,x1); his=NaN; res=NaN; 
    % Set the output
    data=[1 a b his res];
    return;
end

% At this point we know that f0 and f1 have nonzero sign. Why?
if (sign(f0)*sign(f1)>0)
    % The initial bracket is bad, nothing can be said
    flag=-1; x=NaN;
    % Initialize all variables
    a=min(x0,x1); b=max(x0,x1); his=NaN; res=NaN; 
    % Set the output
    data=[1 a b his res];    
    return;
    
end

% ////////////////////////////////////////
% The is root *between* x0 and x1. Why?
% ////////////////////////////////////////

% Allocate space for all variables
a=zeros(maxit,1); b=zeros(maxit,1); his=zeros(maxit,1); res=zeros(maxit,1);

% Intialize the bracket so that alpha < beta
if x1<x0
    alpha=x1; fa=f1; beta=x0; 
else
    alpha=x0; fa=f0; beta=x1;
end

% Assume failure
flag=0;

% Main loop
for j=1:maxit
    % Record the current bracket/search interval
    a(j)=alpha; b(j)=beta;
    
    % Carefully compute the midpoint
    c=alpha+(beta-alpha)/2;
    
    % Evaluate f at the midpoint
    fc=f(c);
    
    % Save the current values
    x=c; his(j)=c; res(j)=fc;
    
    % Check for small bracket
    if abs(alpha-beta)<=delta
        flag=1;
    end
    
    % Check for small residual
    if abs(fc)<=eps
        flag=flag+2;
    end
    
    % Are we happy?
    if flag>0
        % Yes, we are happy, but a human should check the results
        break;
    end
    
    % ////////////////////////////////////////
    % We know now that we have not converged
    % ////////////////////////////////////////
    
    % Compute the next bracket
    if sign(fa)*sign(fc)==-1
        beta=c; 
    else
        alpha=c; fa=fc;
    end
end

% Remove any trailing zeros from output arrays
a=a(1:j); b=b(1:j); his=his(1:j); res=res(1:j);

% Allocate space for the output
data=zeros(j,5); 

% Finalize the output
data(:,1)=(1:j)'; data(:,2)=a; data(:,3)=b; data(:,4)=his; data(:,5)=res;

% Set the number of iterations completed
it=j;