function data=richardson(ah,p,tar)

% Applies Richardson's techniques to a set of approximations
%
% CALL SEQUENCE: data=richardson(ah,tar)
%   
% INPUT:
%   ah      a vector of approximations of the target value
%
%                 ah(j) = A(h(j))
%
%           where 
%
%                h(j+1) = 0.5*h(j)
% 
%  p        the order of the method used to computed ah
%  tar      the target value (optional)
%
% OUTPUT:
%   data    an m by n array where m = numel(ah) and 
%             n=4  if tar is omitted 
%             n=6  if tar is included
%
% MINIMAL WORKING EXAMPLE: rdif_mwe1
%
% SEE ALSO: rdif, rint, rode

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2024-03-07  Adapted from previous implementations from 5dv231
%   2024-03-09  Improved documentation

% Determine the number of approximations
m=numel(ah);

% Reshape the array
ah=reshape(ah,m,1);

% Allocate space for the output array
n=4;
if exist('tar','var')
    % If the target value is known, then 
    %   the error can be computed
    %   the error estimate can be compared to the error
    n=6;
end
data=zeros(m,n);

% Number the rows of data
data(:,1)=(1:m)';

% Include the original approximations in data
data(:,2)=ah;

% Compute Richardson's fraction
for i=3:m
    data(i,3)=(ah(i-1)-ah(i-2))/(ah(i)-ah(i-1));
end

% Compute Richardson's error estimate
aux=2^p-1;
for i=2:m
    data(i,4)=(ah(i)-ah(i-1))/aux;
end

% Is the target value known?
if (n==6)
    % Compute the actual error
    data(:,5)=tar-ah;
    % View Richardson's error estimate as an approximation
    % of the actual error and compute the corresponding 
    % relative error
    data(:,6)=(data(:,5)-data(:,4))./data(:,5);
end