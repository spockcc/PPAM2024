function [a, b, idx, flag]=find_bracket(m, val, x, y)

% FIND_BRACKET Find one or more brackets for a given value 
%
% INPUT:
%   m      find at most m brackets
%   val    the value to bracket
%   x      the array of x values
%   y      the array of y values
%   
% OUTPUT
%   a, b   arrays such that
%            (a(j), b(j)) = (x(i), x(i+1))
%          where y(i)-val and y(i+1)-val have different sign
%        
%   flag   error flag
%            flag  = -1  the input is invalid
%            flag >=  0  the number of bracket found is flag
%
% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-01 Initial programming and testing

% Determine the number of elements
nx=numel(x); 
ny=numel(y);

% Check for errors in the input
if (nx~=ny) || (m<0) || (m~=floor(m))
    a=[];
    b=[];
    idx=[];
    flag=-1;
    return;
end

% At this point we know that nx=ny is a nonnegative integer
n=nx; 

% Reshape the arrays
x=reshape(x,n,1); y=reshape(y,n,1);

% Sort the arrays consistently so that x is increasing
[x,p]=sort(x,'ascend'); y=y(p);

% Compute the signs
aux=sign(y-val);

% Allocate space for the brackets
a=zeros(m,1); b=zeros(m,1); idx=zeros(m,1);

% Initialze the pointer into a, b 
j=0;
% Process the entire table of signs
for i=1:n-1
    if aux(i)*aux(i+1)==-1
        % Sign change detected
        % Increment the number of brackets detected
        j=j+1;        
        % Extract the jth brackets       
        a(j)=x(i); b(j)=x(i+1);
        % Record the index
        idx(j)=i;
    end
    if j==m 
        break;
    end
end

% Post processing
if (j==0)
    % Reduce a and b to empty arrays
    a=[];
    b=[];
    idx=[];
else
    % Eliminate any trailing zeros
    a=a(1:j); b=b(1:j); idx=idx(1:j);
end

% Set the flag
flag=j;