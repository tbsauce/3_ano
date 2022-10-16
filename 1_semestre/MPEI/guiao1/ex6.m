%%codigo a

%simulacao
N= 1e5; %numero de experiencias
p = 0.3; %probabilidade com defeito
k = 3;   %numero pretendido
n = 5;  %numero selecionado
lancamentos = rand(n,N) < p;
sucessos= sum(lancamentos)==k;
m = sum(sucessos)/N;

%calculo analitico
nchoosek(5, 3) * p ^ k * (1-p)^(n-k);

%% codigo b

N= 1e5; %numero de experiencias
p = 0.3; %probabilidade com defeito
k = 2;   %numero pretendido
n = 5;  %numero selecionado
lancamentos = rand(n,N) < p;
sucessos= sum(lancamentos)<=k;
m = sum(sucessos)/N;
lancamentos(1,:);

%histogram(sum(lancamentos));

