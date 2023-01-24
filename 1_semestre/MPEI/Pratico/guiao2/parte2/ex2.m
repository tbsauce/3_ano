%% c

xi = [5 50 100];
pxi = [0.9 0.09 0.01];
b = [0 cumsum(pxi) 1];

stairs(xi, b);