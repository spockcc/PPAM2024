function [s, table]=rode(f,a,b,y0,N1,N2,kmax,method,p,sol)

% RODE  Applies Richardson's techniques to ODEs
%
% This function uses Richardson's technique to estimate the error when
% solving the initial value problem
%
%    y'(t) = f(t, y),     a <= t <=b
%     y(a) = y0
%
% using one of the standard Runge-Kutta methods.
%
% CALL SEQUENCE: 
%
%   [s, table]=rode(f, a, b, y0, N1, N2, kmax, method, p, sol)
%
% INPUT:
%   f       a user defined function
%   a,b     specifies the interval
%   y0      the initial condition
%   N1, N2  controls the total number of timesteps, see below
%   kmax    controls the number of refinements, see below
%   method  a string controlling the method used, see rk.m
%   p       the order of the method used
%   sol     an optional function which computes the true solution.
%             
% OUTPUT:
%   s       s(i,j,k) is the kth approxmation of the i component of y(t(j))
%   table   tables containing all information extracted by richardson,
%           suitable for printing with print_ode_table
%
% MINIMAL WORKING EXAMPLE(s): rode_mwe1, rode_mwe2, rode_mwe3, rode_mwe4
% 
% See also: RDIF, RINT, RK, PRINT_RODE_TABLE

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%    Dec 2012    Initial programming and testing
%    Apr 2014    Streamlining and better comments
%    Oct 2014    Modified to fit with the new Runge-Kutta code
%    2014-29-10  Optional exact solution enabled
%    2014-12-04  Variable number of fractions allowed to check behaviour
%    2014-12-05  Improved documentation prior to release of Project 3
%    2014-12-16  Bug found and fixed by several students in MWE
%    2016-06-28  Major revision during yearly review
%                  1) New minimal working examples
%                  2) New documentation
%                  3) Integration of displaytable()
%                  4) Automatic support for multiple dimensions
%                  5) Improved datalayout
%    2022-12-12  Trimmed the output to fit smaller screens.
%    2024-03-08  Simplification during yearly review
%                  1) The analysis of s has been moved to richardson
%                  2) The printing of tables moved to print_rode_table

flag=0;
% Did the user supply the exact solution for comparison purposes?
if exist('sol','var')
   flag=1;  % A solution was provided
end

% Determine the number of components in the solution
dim=size(y0,1); 

% We need at least three approximations to begin.
kmax=max(kmax,3);

% Allocate space for the solutions.
s=zeros([dim N1+1 kmax]);

% ////////////////////////////////////////
% Compute all approximation
% ////////////////////////////////////////

% On the coarsest grid there will be N1*N2 time steps.
num=N2;
for k=1:kmax
   % Compute approximation using time step h=(b-a)/(N1*num)
   [t, y]=rk(f,a,b,y0,N1,num,method); 
   % Save the computed approximation in s
   s(:,:,k)=y; 
   % Increase NUM with a factor 2. 
   num=num*2;
end

% Apply Richardson's technique to the all relevant values
%   We are interested in a specific component
%   We are interested in N1+1 distinct times
%   Therefore, there are N1+1 sequences of data to analyze

% Has the solution been provided
if (flag==1)
    val=zeros(dim,N1+1);
    for j=1:N1+1
        val(:,j)=sol(t(j));
    end
end

% Allocate space for all output
n=kmax+1;
if flag==1
  n=n+2;
end

% Allocate space for the output
table=zeros(N1+1,n,dim);

% Loop over all components
for i=1:dim
   for j=1:N1+1
        % Isolate all approximations of the ith of y(t(j))
        aux=s(i,j,:);
        % Did the user supply the solution?
        if (flag==0)
            % Compute Richardson's fraction and error estimate
            data=richardson(aux,p);
        else
            % Compute the target value
            tar=val(i,j);
            % Compute Richardson's fraction, error estimate and the exact error
            data=richardson(aux,p,tar);
        end
        % //////////////////////////////////////
        % Inject data into the overall table
        % //////////////////////////////////////
        
        % Record the time
        table(j,1,i)=t(j);
        
        % Record the "best" approximation (smallest time step)
        table(j,2,i)=data(kmax,2);
        
        % Record Richardson's fraction
        table(j,3:kmax,i)=data(3:kmax,3);
        
        % Record Richardson's error estimate for the "best" approximation
        table(j,kmax+1,i)=data(kmax,4);
        
        if (flag==1)
            % Record the actual error
            table(j,kmax+2,i)=data(kmax,5);
            % Record the comparison of Richardson's error estimate to the actual error
            table(j,kmax+3,i)=data(kmax,6);
        end
    end
end