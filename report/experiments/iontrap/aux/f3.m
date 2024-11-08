function [y, yp]=f3(a,b,x)

% Function
[y, zp]=f2((x-a)./(b-a));

% Derivative using the chain rule
yp=zp./(b-a)