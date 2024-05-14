function [x, flag, it, data]=secant(f,sp)

% Solves a nonlinear equation using the secant method
%
% Attempts to solve the nonlinear scalar equation
%
%   f(x) = 0
%
% using the secant method. 
% 
% CALL SEQUENCE:
%
%   [x, flag, data]=secant(f,sp)
%
% INPUT:
%   f        a handler to the function f
%   sp       a structure with the following fields
%              xval     the points x0 and x1 needed to start
%              fval     the corresponding function values
%              delta    break if abs(a(it)-b(it)) < delta
%              eps      break if abs(res(it)) < eps
%              maxit    break if it=maxit
%
% OUTPUT:
%   x        the final approximation
%   flag     a flag signaling succes/failure, if flag = 
%              -1,  then we had to break to avoid division by zero
%               0,  then the iteration did not converge
%               1,  then the iteration has stagnated in the sense
%                      abs(x2-x1)<delta*abs(x0)
%               2,  then abs(res(j))<eps
%               3,  then the two previous conditions are both true
%   data     an array of dimension it by 6 
%               data(j,1)   = j
%               data(j,2)   = his(j), the jth approximation of x
%               data(j,3)   = res(j), the the corresponding residual
% 
% See also: BISECTION, NEWTON, ROBUST_SECANT

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07  Extracted from robust_secant

% Extract parameters
x0=sp.xval(1);
x1=sp.xval(2);
f0=sp.fval(1);
f1=sp.fval(2);
delta=sp.delta;
eps=sp.eps;
maxit=sp.maxit;

% Allocate space for the approximations
his=zeros(maxit,1); 

% Allocate space for the residuals
res=zeros(maxit,1);
    
% Initialize the flag assuming failure
flag=0;

% Main loop
for j=1:maxit
    
    % Can we do a secant step?
    if (f0 ~= f1)
        % Yes,
        x2=x1-f1*((x1-x0)/(f1-f0));
    else
        % A secant step would cause division by zero.
        flag=-1;
        break;
    end

    %  Save this approximation
    x=x2; f2=f(x2); his(j)=x2; res(j)=f2;
    
    % Check for stagnation
    if abs(x1-x2)<delta*abs(x0)
        flag=bitset(flag,1);
    end
    
    % Check the size of the current residual
    if abs(f2)<eps
        flag=bitset(flag,2);
    end
    
    % Are we happy?
    if flag>0
        % The machine believes that convergences has been acheived ...
        % ... but a human should check the results
        break;
    end

    % Prepare for the next iteration
    x0=x1; x1=x2; f0=f1; f1=f2;
end

% Remove any trailing zeros from internal arrays
his=his(1:j); res=res(1:j);

% Allocate space for the output
data=zeros(j,3); 

% Finalize the output
data(:,1)=(1:j)'; data(:,2)=his; data(:,3)=res;

% Set the iteration count
it=j;