%% b

% deserto oceano foresta urbano

T = [
       0.4  0.2 0.25 0.25;
       0.2  0.4 0.25 0.25;
       0.2  0.2 0.25 0.25;
       0.2  0.2 0.25 0.25
    ];


%% c

x0 = [0 ; 1; 0; 0];
res = T^7 *x0; 
res(3 , :)


%% d


M = [ T - eye(length(T));
    ones(1, length(T))];

x= [zeros(length(T), 1); 1];

u = M\x

%% e 

%DDxxxFF

a = 0.25 * 0.4; 

x0 = [a; 0 ; 0 ; 0];

res = T^4 * x0

sol = res(3, :) * 0.25




