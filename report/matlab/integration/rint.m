function data=rint(f,a,b,rule,p,kmax,val)

% RINT Richardson's technique for numerical integration
% 
% CALL SEQUENCE: data=rint(f,a,b,rule,p,kmax,val)
%
% INPUT:
%   f       a user supplied function which calculates f(x)
%   a,b     endpoints specifying the interval in question
%   rule    the rule used to approximate the integral
%   p       the order of the method
%   kmax    an integer specifying the number of intervals to use
%   val     the exact integral (optional)
%
% OUTPUT:
%   data   an array of information
%             data(i,1) = i
%             data(i,2) = approximation of the integral using stepsize h(i)
%             data(i,3) = Richardson's fraction
%             data(i,4) = Richardson's error estimate
%          if the exact integral is supplied as val, then
%             data(i,5) = exact error
%             data(i,6) = comparision of error estimate to exact error
%
% MINIMAL WORKING EXAMPLE: rint_mwe1
%
% See also: RDIF, RODE, TRAPEZOID

% PROGRAMMING by Carl Christian K. Mikkelsen (spock@cs.umu.se) 
%  2012-12-XX  Initial programming and testing
%  2014-12-01  Streamlining and style adjusted to the new norm
%  2016-06-28  Integrated displaytable(). Improved documentation
%  2018-12-08  Overhauled to match the structure of RDIF

% Save time by only computing the function values ONCE. 
x=linspace(a,b,2^kmax+1); y=f(x);

if ~exist('val','var')
    % The exact value of the integral was not given.
    flag=0;
    % Allocate space for output
    data=zeros(kmax,4);
else
    % The exact value of the integral was given.
    flag=1;
    % Allocate space for output
    data=zeros(kmax,6);
end

% Initialize the first column of data
for i=1:kmax
    data(i,1)=i-1;
end

% Set the number of intervals and the stride between relevant values of y
N=1; stride=2^kmax;
for i=1:kmax
   data(i,2)=rule(y(1:stride:end),a,b,N); N=N*2; stride=stride/2;
end

% Compute Richardson's fractions
for i=3:kmax
    data(i,3)=(data(i-1,2)-data(i-2,2))/(data(i,2)-data(i-1,2));
end

% Compute Richardson's error estimates assuming that the order is ok
factor=2^p-1;
for i=2:kmax
    data(i,4)=(data(i,2)-data(i-1,2))/factor;
end

% Compute the actual error if exact target value is known
if (flag==1)
    % Compute the exact error
    for i=1:kmax
        data(i,5)=val-data(i,2);
        % Compare the error estimate to the exact error
        data(i,6)=(data(i,5)-data(i,4))./data(i,5);
    end
end