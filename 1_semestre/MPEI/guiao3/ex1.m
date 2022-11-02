%% a e b

pf = 0.8;
pp = 0.7;
n = 2;

x0 = [1 ; 0];

%estar presente 1, faltar 2
T = [0.7 0.8; 0.3 0.2];

res = T^n * x0;

fprintf("%f esteve presente na quarta \n", res(1,:));
fprintf("%f Nao esteve presente na quarta \n", res(2,:));

%% c

n = 15 * 2;

x0 = [1 ; 0];

%estar presente 1, faltar 2
T = [0.7 0.8; 0.3 0.2];

res = T^n * x0;

fprintf("%f esteve presente na 1 aula e na ultima\n", res(1,:))

%% d
n = 30;
x0 = [0.85 ; 0.15];
T = [0.7 0.8; 0.3 0.2];
res = x0;
for i = 1 : n-1
    res(:, i+1) = T^i * x0;
end
plot(1:1:30, res)