%% a
% folha de teste
%% b
        %A      B       C       D
T = [
        0.1     0.3     0.4     0.3;
        0.3     0.1     0.25    0.3;
        0.3     0.3     0.1     0.2;
        0.3     0.3     0.25    0.2;
    ];

%% c

x0= [1/4;1/4;1/4;1/4];

res = T^10 * x0;

res(2, :)


%% d

M = [ T - eye(length(T));
    ones(1, length(T))];

x= [zeros(length(T), 1); 1];

u = M\x;


sol = res(2, :) * 60 * 6


%% e 

x0= [1/4;1/4;1/4;1/4];

res = T^2 * x0;

A = res(1) *  0.3 * 0.1 * 0.3;

x0 = [A ; 0 ; 0; 0];

sol = T^2 * x0

sum(sol)
