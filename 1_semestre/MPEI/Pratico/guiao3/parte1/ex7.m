%% a 

    % A B C D E F
H = [
        0   0   0   0   1/3     0;
        1   0   0   0   1/3     0;
        0   1/2 0   1   0       0;
        0   0   1   0   0       0;
        0   1/2 0   0   0       0;
        0   0   0   0   1/3     0;
    ];


x0 = [1/6; 1/6; 1/6; 1/6; 1/6; 1/6];

for i= 0: 10
    x0 = H * x0;
end

x0
% C e D

%% b

% F deadlock
% c e D spider

%% c

H = [
        0   0   0   0   1/3     1/6;
        1   0   0   0   1/3     1/6;
        0   1/2 0   1   0       1/6;
        0   0   1   0   0       1/6;
        0   1/2 0   0   0       1/6;
        0   0   0   0   1/3     1/6;
    ];

x0 = [1/6; 1/6; 1/6; 1/6; 1/6; 1/6];
for i= 0: 10
    x0 = H * x0;
end

x0

%% d

beta = 0.9;
A = beta *H + (1-beta)*(1/6* ones(6));


x0 = [1/6; 1/6; 1/6; 1/6; 1/6; 1/6];
for i= 0: 10
    x0 = A * x0;
end

x0

%% e 
x0 = [1/6; 1/6; 1/6; 1/6; 1/6; 1/6];
for i= 0: 26
    x0 = A * x0;
end

x0

% nas 10 transicoes a matriz e estacionaria ou perto


