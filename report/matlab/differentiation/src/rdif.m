function data=rdif(f,x,D,p,h0,kmax,df)

% RDIF Applies Richardson's technique to numerical differentiation
% 
% CALL SEQUENCE:  data=rdif(f,x,D,p,h0,kmax,df)
%
% INPUT:
%   f      a handler to a real function of a real variable
%   x      a single scalar in the domain of f
%   D      a handler to a function that approximates f'
%   p      the order of the principal error term
%   h      the largest stepsize
%   kmax   the number of different stepsizes to explore
%   df     (optional) a handler to the exact derivative
%
% OUTPUT:
%   data   an array of information
%             data(i,1) = i
%             data(i,2) = D(f,x,h(i))
%             data(i,3) = Richardson's fraction
%             data(i,4) = Richardson's error estimate
%          if the exact derivative supplied as df, then
%             data(i,5) = exact error
%             data(i,6) = (exact error - error estimate)/(exact error)
%
% MINIMAL WORKING EXAMPLE: rdif_mwe1, rdif_mwe2
%
% See also: RINT, RODE, RICHARDSON

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%  2014-11-27  Initial programming and testing
%  2014-12-02  Bug fixed in calculating number of significant digits
%              Added a list of operators and trial functions 
%  2016-06-30  Integrated displaytable().
%  2016-12-07  Removed unused output arguments
%  2016-12-07  Added variable count to output arguments
%  2018-11-28  Printing moved to MWE as a matter of principle
%  2024-04-08  Calculations off-loaded to richardson


% Did the user supply a handler to the exact derivive in the input?
if ~exist('df','var')
    % The derivative was not included
    flag=0;
else
    % The derivative was included
    flag=1;
    % Compute the target value
    tar=df(x);
end

% Compute approximations
ah=zeros(kmax,1);

% Compute kmax different approximations of the derivative
h=h0;
for i=1:kmax
    ah(i)=D(f,x,h); h=h/2;
end

% Apply Richardson's techniques
if (flag==0)
    data=richardson(ah,p);
else
    data=richardson(ah,p,tar);
end