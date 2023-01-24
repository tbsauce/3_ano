%% a
clc;
clear;

p1 = 0.002;
p2 = 0.005;
pa = 0.01; 

N = 1e5;
n = 8;
experiencias1 = rand(n, N) < p1;
experiencias2 = rand(n, N) < p2;
experiencias3= rand(n, N) < pa;
conj = experiencias3 | experiencias2 |experiencias1;
experiencias = sum(conj) >= 1;

p = sum(experiencias)/N;

fprintf("Probabilidade de uma caixa ter defeito em 1 brinquedo %f\n",p);

%% b

clc;
clear;

p1 = 0.002;
p2 = 0.005;
pa = 0.01; 

N = 1e5;
n = 8;
experiencias1 = rand(n, N) < p1;
experiencias2 = rand(n, N) < p2;
experiencias3= rand(n, N) < pa;
conj = experiencias3 == 1 & experiencias2 == 0 & experiencias1 == 0;
experiencias = sum(conj) >= 1;

p = sum(experiencias)/N;

fprintf("Probabilidade de uma caixa ter um briquedo com defeito apenas na montagem %f\n",p);
