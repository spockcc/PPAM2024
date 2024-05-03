function v=initv(q0, v0, param)

% Find a velocity that is compatible with the hidden constraint
%
%     Dg(q0)v_0 = 0
%
% INPUT:
%   q0     the initial position of the atoms
%   v0     initial guess for a compatible velocity
%   param  a structure such that
%             param.dg is the Jacobian
%
% OUTPUT:
%   v      a velocity vector that is compatible with the hidden constraint.  
%
% MINIMAL WORKING EXAMPLE: TODO

% PROGRAMMING by Carl Christian Kjelgaard Mikkelsen (spock@cs.umu.se)
%   2022-XX-YY  Initial programming and testing
%   2022-08-03  Completed the internal documentation
%
% REMARK: It is the responsiblilty of the user to ensure that the
% dimensions match.

% Isolate the Jacobian
dg=param.dg;

% Evaluate the Jacobian at q0;
A=dg(q0);

% Determine an orthogonal basis for the null space of A
Q=null(full(A));

% Project v0 onto N(A);
v=Q*(Q'*v0);