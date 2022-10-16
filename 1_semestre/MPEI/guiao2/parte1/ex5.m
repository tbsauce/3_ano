%% a
face_dado = 6;
n_lancamentos = 2;
N = 1e5;
experiencias = randi([1,6], 2, N);

A = sum(sum(experiencias) == 9)/N;
B = sum(mod(experiencias(1,:),2) == 0)/N;
C = sum(sum(experiencias == 5) >=1)/N;
D = sum(sum(experiencias == 1) == 0)/N;


fprintf("PA) %f \n", A);
fprintf("PB) %f \n", B);
fprintf("PC) %f \n", C);
fprintf("PD) %f \n", D);
