function y=f2(x)

% Smooth transition function between 1 and 0
y=f1(x)./(f1(x)+f1(1-x));
