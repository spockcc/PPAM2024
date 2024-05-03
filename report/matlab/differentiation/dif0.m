function data=dif0(f,x,h0,maxit)

% DIF0  Illustrates subtractive cancellation in numerical differentiation
%
% CALL SEQUENCE:  data=dif0(f,x,h,maxit)
%
% INPUT:
%   f      a handler to a function computing f(x)
%   x      a single point
%   h0     the initial stepsize
%   maxit  the number of approximations to compute
%
% OUTPUT:
%   data   an array such that
%             data(i,1) = i
%             data(i,2) = h(i)
%             data(i,3) = f(x+h(i))-f(x)
%             data(i,4) = data(i,3)/h(i)
%
% WARNING: This routine is for educational purposes only. It *will* fail
% spectacularly, because it will experience subtractive cancellation.
%
% PSEUDOCODE: Kincaid and Cheney: "Numerical Analysis", 2nd Edition.
%
% MINIMAL RUNNING EXAMPLE: dif0_mwe1

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2015-XX-YY  Initial programming and testing
%   2016-06-30  Minor reformatting and integration of displaytable()
%   2018-11-22  Printing moved to MWE as a matter of principle
%   2023-11-24  Fixed misprint in documentation

% Compute f at the given point x
F1=f(x);

% Allocate space for arrays
data=zeros(maxit,4);

% Initialize the stepsize
h=h0;

for i=1:maxit
    % Record the index and stepsize
    data(i,1)=i; data(i,2)=h; 
    % Evaluate f at x+h and record the result
    F2=f(x+h); 
    % Form the difference and record the result
    d=F2-F1; data(i,3)=d;
    % Compute and record the finite difference approximation
    r=d/h; data(i,4)=r;
    % Reduce the step size a factor of two
    h=h/2;
end