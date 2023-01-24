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
experiencias = sum(conj) ==  0;

p = sum(experiencias)/N;

fprintf("Probabilidade de uma caixa não ter defeito %f\n",p);

%% b

clc;
clear;

p1 = 0.002;
p2 = 0.005;
pa = 0.01; 

n = 8;
k = 0;

p =p1 + p2 + pa - (p1 * p2) - (p1*pa) - (p2*pa) + 2 * (p1 * p2 * pa);

a = nchoosek(n,k) *p^k *(1-p)^(n-k);


fprintf("Probabilidade de uma caixa não ter defeito %f\n",a);


