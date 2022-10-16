%% 2
N= 1e5; %numero de experieˆncias
p = 0.5; %probabilidade de cara
k = 6; %numero de caras
n = 15; %numero de lanc¸amentos
lancamentos = rand(n,N) > p;
sucessos= sum(lancamentos)>=k;
probSimulacao= sum(sucessos)/N