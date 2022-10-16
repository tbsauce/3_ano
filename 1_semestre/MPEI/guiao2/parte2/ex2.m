%% c

S = 0:4;
pxi = [0.9 0.09 0.01];
b = [0 cumsum(pxi) 1];

stairs(S, b);