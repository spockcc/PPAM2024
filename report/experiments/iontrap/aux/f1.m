function [y, yp]=f1(x)

% Initialize output
y=zeros(size(x)); yp=zeros(size(x));

% Identify positive x
idx=(x>0);

% Modify the corresponding y values
y(idx)=exp(-1./x(idx));
yp(idx)=y(idx)./x(idx).^2;