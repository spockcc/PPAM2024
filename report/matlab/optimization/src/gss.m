function [x, y, flag, it, a, b]=gss(f, a0, b0, delta, maxit)

% Golden Section Search for the maximum of a unimodal function
%
% CALL SEQUENCE: 
%
%   [x, y, flag, it, a, b]=gss(f, a0, b0, delta, maxit)
%   
% INPUT:
%   f       a handle to the function f
%   a0, b0  specifices the initial search interval
%   delta   break when search interval is shorter than delta
%   maxit   break after at most maxit iterations
%
% OUTPUT:
%   x       the midpoint of the final search interval
%   y       the corresponding function value, y = f(x)
%   flag    standard success indicator,
%              flag = 0, final interval is too long
%              flag = 1, final interval is shorter than delta
%   it      number of iterations completed.
%   a, b    the ith search interval was [a(i), b(i)]
%          
% MINIMAL WORKING EXAMPLE: gss_mwe1

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2018-11-16   Adapted from experimental routine XGSS
%   2024-03-09   Updated documentation during yearly review

% Finding maxima is not trivial, so assume failure
flag=0;

% Ensure that a0<=b0
if (a0>b0) 
    % Swap the points a0 and b0
    aux=a0; a0=b0; b0=aux;
end

% Define the number phi = (sqrt(5) - 1)/2 = 0.6180 ..
lambda=(sqrt(5)-1)/2;

% Compute the new points in the interval from a0 to b0
x1=lambda*a0+(1-lambda)*b0;  % x1 is 39.20% of the way from a0 to b0
x2=(1-lambda)*a0+lambda*b0;  % x2 is 61.80% of the way from a0 to b0

% Compute the corresponding function values
f1=f(x1);
f2=f(x2);

% Save space for the search intervals
a=zeros(1,maxit); b=zeros(1,maxit);

% Initialize the search intervals
a(1)=a0; b(1)=b0;

% Main loop
for it=1:maxit

    % Isolate the current search interval
    alpha=a(it); beta=b(it);
    
    % Check for convergence
    if abs(alpha-beta)<delta
        % The bracket is sufficiently short in the absolute sense
        flag=1;
        % Break out of the for loop
        break;        
    end
    
    % Do we have room for more iterations?
    if it<maxit
        
        % Main logic which compares function values f1 and f2
        if f1>f2
            % The new search interval will be (alpha,x2) as it contains x1
            a(it+1)=alpha; b(it+1)=x2;
            % Moreover, the current value of x1 becomes the NEW x2
            x2=x1; f2=f1;
            % The new value of x1 has to be computed ...
            x1=lambda*alpha+(1-lambda)*x2;
            % ... and the new value of f1 has to be computed
            f1=f(x1);
        else
            % The new search interval will be (x1,beta) as it contains x2
            a(it+1)=x1; b(it+1)=beta;
            % Moreover, the current value of x2 become the NEW x1
            x1=x2; f1=f2;
            % The new of x2 has to be computed ...
            x2=(1-lambda)*x1+lambda*beta;
            % ... and the new value of f2 has to be computed
            f2=f(x2);
        end
   end
end
   
% Eliminate any trailing zeros
a=a(1:it); b=b(1:it);

% Return the midpoint of the last search bracket
x=a(end)+(b(end)-a(end))/2;

% Return the corresponding function value
y=f(x);