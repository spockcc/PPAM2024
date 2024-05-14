function [x, flag, it, data]=robust_secant(f,sp)

% Solves a nonlinear equation using a bisection/secant hybrid
%
% Attempts to solve the nonlinear scalar equation
%
%   f(x) = 0
%
% using a hybrid between the bisection method and the secant method. This 
% method combines the robustness of the bisection method with the rapid 
% local convergence of the secant method. The function requires a bracket
% around the root and computes a sequence of brackets of decreasing length.
% Secant steps are accepted only if they do not leave the current bracket. 
% If a secant step is impossible or if it would leave the current bracket
% a bisection step is completed instead.
% 
% CALL SEQUENCE:
%
%   [x, flag, it, data]=robust_secant(f,sp)
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
%   x        the final approximation
%   flag     a flag signaling succes/failure, if flag = 
%              -1,  then the initial bracket was bad, see below
%               0,  then the iteration did not converge
%               1,  then the last bracket has length less than delta
%               2,  then the last residual has size less than eps
%               3,  then the two previous conditions are both true
%   data     an array of dimension it by 6 datastructure contain these fields
%               data(j,1)   = j
%               data(j,2:3) = [a(j) b(j)], the jth bracket
%               data(j,4)   = his(j), the jth approximation of x
%               data(j,5)   = res(j), the the corresponding residual
%               data(j,6) 
%                    = 1, if a secant step was completed
%                    = 2, if a secant step would leave the bracket
%                    = 3, if a secant step would cause division by zero               
%
% A *bad* bracket is a pair of points a, b, such that f(a)*f(b) >= 0. In 
% such a case, we can not conclude that there is a root strictly between 
% a and b. 
% 
% See also: BISECTION, NEWTON, SECANT

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  2016-06-17  Initial programming and testing
%  2016-06-21  Made several changes
%               1) User must compute f0 and f1 outside the function 
%               2) Every number computed is recorded 
%               3) Improved organization of logic and comments
%  2016-06-27  Integrated displaytable(). Added links to other methods
%  2016-08-15  Minor changes to the documentation
%  2021-05-11  Created the data structure, moved print to dedicated routine
%  2021-12-15  Early release without the PrintTable function to save time.
%  2024-03-09  Adapted to the standardized interface for all solvers

% ////////////////////////////////////////
% Sanity check of the input
% ////////////////////////////////////////

% In MATLAB
%    sign(x) = +1, if x is strictly positive
%    sign(x) =  0, if x is zero
%    sign(x) = -1, if x is strictly negative, 

% Extract parameters
x0=sp.xval(1);
x1=sp.xval(2);
f0=sp.fval(1);
f1=sp.fval(2);
delta=sp.delta;
eps=sp.eps;
maxit=sp.maxit;

% Test if the initial bracket is bad
if (sign(f0)*sign(f1)>=0)
    % The initial bracket is bad, nothing can be said
    % Humans have a tendency to ignore flags. 
    % By setting x=NaN we will get their attention ...
    % ... even if they ignore the flag.
    x=NaN; flag=-1; 
    % Set the internal variables
    a=min(x0,x1); b=max(x0,x1); his=NaN; res=NaN;
    % Set the output
    data=[1 a b his res];
    % Immediate return 
    return;
end


% ////////////////////////////////////////
% The is root *between* x0 and x1. Why?
% ////////////////////////////////////////

% Allocate space for the brackets
a=zeros(maxit,1); b=zeros(maxit,1); 

% Allocate space for the approximations
his=zeros(maxit,1); 

% Allocate space for the residuals
res=zeros(maxit,1);

% Allocate space for recording the steps made
status=zeros(maxit,1);

% Intialize the bracket so that alpha < beta
if x1<x0
    alpha=x1; fa=f1; beta=x0; % fb=f0; We never access fb
else
    alpha=x0; fa=f0; beta=x1; % fb=f1; By design, fa*fb<0, so we do not need fb.
end
    
% Initialize the flag assuming failure
flag=0;

% Main loop
for j=1:maxit
    
    % Preserve the current bracket
    a(j)=alpha; b(j)=beta;
    
    % Can we do a secant step?
    if (f0 ~= f1)
        % Yes, then do a experimental secant step
        x2=x1-f1*((x1-x0)/(f1-f0));
        % Does this step fall outside the current bracket?
        if (x2 <= alpha) || (beta<=x2)
            % Yes, it does. Replace x2 with a bisection step
            x2=alpha+(beta-alpha)/2;
            % Record that we did a bisection step
            status(j)=2;
        else
            % No, record that we did a secant step
            status(j)=1;
        end
        
    else
        % A secant step would cause division by zero. Do a bisection step!
        x2=alpha+(beta-alpha)/2;
        % Record that we avoided a division by zero
        status(j)=3;
    end

    % ///////////////////////////////////////
    %   x2 must be in the current bracket
    % ///////////////////////////////////////
    
    %  Save this approximation
    x=x2; f2=f(x2); his(j)=x2; res(j)=f2;
    
    % Check the length of the current bracket
    if abs(alpha-beta)<delta
        flag=bitset(flag,1);
    end
    
    % Check the size of the current residual
    if abs(f2)<eps
        flag=bitset(flag,2);
    end
    
    % Are we happy?
    if flag>0
        % The machine believes that we have converged
        % ... but a human should check the results
        break;
    end

    % ///////////////////////////////////////
    %   We need more iterations
    % ///////////////////////////////////////
    
    % Rebracket the root
    if (sign(fa)*sign(f2)==-1)
        % We continue with the interval (alpha,x2)
        beta=x2; %fb=f2; By design, we have fa*fb<0, so fb is not needed
    else
        % We continue with the interval (x2,beta)
        alpha=x2; fa=f2;
    end
    
    % Prepare for the next iteration
    x0=x1; x1=x2; f0=f1; f1=f2;
end

% Remove any trailing zeros from output arrays
a=a(1:j); b=b(1:j); his=his(1:j); res=res(1:j); status=status(1:j);

% Allocate space for the output
data=zeros(j,6); 

% Finalize the output
data(:,1)=(1:j)'; data(:,2)=a; data(:,3)=b; data(:,4)=his; data(:,5)=res; data(:,6)=status;

% Set the iteration count
it=j;