function [t, y, count, idx]=event_location(f,t0,t1,y0,maxstep,method,g,K)

% Event location for ordinary differential equations
%
% Solve the differential equation
%
%   y'(t) = f(t,y(t)),
%   y(t0) = y0
%
% while searching for events of the type
%
%   g(y(t)) = 0 (*)
%
% where g is a real value function. 
%
% This function is based on the RK function and the call sequence is very 
% similar.
%
% CALL SEQUENCE:
%
%    [t, y, count, idx]=event_location(f,t0,t1,y0,N,method,g,K)
%
% INPUT:
%   f         a handler to the function f, see below.
%   t0, t1    the time interval is [t0,t1]          
%   y0        is the initial condition, i.e. y(t0) = y0
%   maxstep   the basic time step is (t1-t0)/N
%   method    a string which specifies the method
%               'rk1' : the explicit Euler method
%               'rk2' : Heun's method aka the improved Euler method
%               'rk3' : a third order accurate Runge-Kutta method.
%               'rk4' : the classical 4th order Runge-Kutta method.
%   g         a handler to a real valued function
%   K         return at most K solutions of (*)
% 
% OUTPUT:
%    t      a vector containing at most N+K+1 points in time
%    y      y(:,i) is the approximation of the solution at time t(i).
%    count  the number of events recorded
%    idx    the indices in t and y of the events recorded
%
% NOTES:
%   a) It is assumed that the function f returns a COLUMN vector!
%
% MINIMAL WORKING EXAMPLE: event_location_mwe1
%
% See also: RK

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se) 
%  2015-09-21  Initial programming
%  2015-09-22  Improved inline documentation
%  2015-11-22  Extended call sequence and added minimum working example
%  2016-05-22  Improved inline documentation and formatting
%  2016-05-22  Adapted routine to improved bisection method

% TODO: 
% The game SCORCHED reveals that there are unresolved problems as shells can
% pass straight through the narrow hills. The problem is that the event
% function has the same sign on both sides of the hill, so there is no sign
% change to trigger a search for a zero. 
%   1) Obtain a smooth representation of the solution between data points
%   2) Determine the range of the event function between data points
%   3) Find zeros of the derivative
% Point 1) is relatively easy and there is at least two sensible choices
% involving third order polynomials
%   a) match values and derivatives at the endpoints
%   b) match values at the end points, and match both value and derivative
%      at the midpoint
% Points 2) and 3) are substantionally harder to automate.
% 
% A possibility it to approximate the composition of the event function
% with the trajectory with a cubic polynomial. Then the analysis could be
% automated. This requires the derivative of the event function.


% Force the initial condition to be a COLUMN vector; 
s=numel(y0); y0=reshape(y0,s,1); 

% Define the basic stepsize dt;
dt=(t1-t0)/maxstep;

% The instances where we record approximations are stored in t
t=zeros(1,maxstep+K+1); 

% Allocate space for storing the solution
y=zeros(s,maxstep+K+1); 

% Save the initial condition 
t(1)=t0; y(:,1)=y0;

% Point to the first column
col=1;

% Evaluate the event function at the initial point and record the sign
g0=g(y0); s0=sign(g0);

% Index to the events
idx=zeros(1,K);

% Choose the appropriate method to integrate the ODE
switch lower(method)
    case 'rk1'
        phi=@phi1;
    case 'rk2'
        phi=@phi2;
    case 'rk3'
        phi=@phi3;
    case 'rk4'
        phi=@phi4;
    otherwise
        disp('Unknown method specified. RK1 selected by default');
        phi=@phi1;
end

% Initialize the event counter
count=0;

for i=1:maxstep
    % Compute the current time
    tau=(i-1)*dt;
    % Advance the current approximation a single time step 
    aux=phi(f,tau,y(:,col),dt);
    % Evaluate the event function at the new point and record the sign
    g1=g(aux); s1=sign(g(aux));

    % Check for PROPER changes in the sign
    if s0==0
        % In general, this is branch is exceedingly rare. 
        % It does however happen regularly in artillery computations. 
        % If the event function is zero iff the shell is on the ground, 
        % and if the muzzle of the gun is on the ground, then an event
        % occurs initially. It is however, exceedingly unlikely that
        % the shell will land on the ground after an INTEGER number of time
        % steps of a FIXED side.
      
        % Increase the event count
        count=count+1;
        
        % Save the location of the event
        idx(count)=col;
        
    else
        
        if (s0*s1==-1)
            
            %------------------------------------------------------------------
            % We know that g(y(tau)) and g(y(tau+dt)) have different sign
            % By continity, there is an x in (0,1) such that
            %
            %     g(y(tau + x*dt) = 0
            %
            % We are now going to approximate x using the bisection algorithm
            %------------------------------------------------------------------
            
            % Define a function to feed to the bisection algorithm
            psi=@(x)g(phi(f,tau,y(:,col),x*dt));
            
            % Set parameters for bisection
            bp.xval=[0; 1];
            bp.fval=[g0; g1];
            % This is a delicated question ...
            % ... and the analysis is not complete
            bp.delta=eps(1)/2;
            % This is a delicated question ...
            % ... and the analysis is not complete
            bp.eps=eps(1)/2*(abs(g1-g0));
            
            % This is enough for the worst case scenario
            bp.maxit=53;
            
            % Hunt for a solution between tau and tau+dt
            rho=bisection(psi,bp);
            
            % OPEN PROBLEMS:
            %  a) Decide if the termination criteria are sensible (hard)
            %     Contact spock@cs.umu.se if you solve this
            %  b) Replace solver with user defined routine (easy)
            %  c) Record iteration counts to document improvement (easy)
            
            % Save the corresponding time and point
            t(col+1)=tau+rho*dt; y(:,col+1)=phi(f,tau,y(:,col),rho*dt);
            
            % Advance the column pointer
            col=col+1;
            
            % Advance the event counter
            count=count+1;
            
            % Save the location of the event
            idx(count)=col;
        end
    end
    
    % Have we found enough events?
    if (count<K)
        % Record data
        t(col+1)=i*dt; y(:,col+1)=aux;    
    else
        % K events have been found, stop immediately
        break;   
    end
    
     % Prepare for the next iteration
    g0=g1; s0=s1; 
    
    % Increase the column counter
    col=col+1;
end

% Remove any trailing zeros from output arrays
t=t(1:col); y=y(:,1:col);