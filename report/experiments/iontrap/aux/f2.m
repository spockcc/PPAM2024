function [y, yp]=f2(x)

% Evaluate f1 at x
[y1, y1p]=f1(x);

% Evaluate f1 at 1-x;
[z1, z1p]=f1(1-x);


% Smooth transition function that transitions from 0 to 1.
y=y1./(y1+z1);

% Derivative
yp=(y1p.*(y1+z1)-y1.*(y1p-z1p))./(y1+z1).^2;
