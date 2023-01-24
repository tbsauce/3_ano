p = 0.5; %probabilidade de cara
k = 6;   %numero de caras
n = 15;  %numero de lanc¸amentos

fprintf('0 ProbSimulação %f\n', coin(p,k,n));
fprintf('1 ProbSimulação %f\n', coin(p,8,20));
fprintf('2 ProbSimulação %f\n', coin(p,16,40));
fprintf('3 ProbSimulação %f\n', coin(p,60,100));

function m = coin(p,k,n)
    N= 1e5; %numero de experiencias
    lancamentos = rand(n,N) > p;
    sucessos= sum(lancamentos)>=k;
    m = sum(sucessos)/N;
end

