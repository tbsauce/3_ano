%%a
N = 1e5;    %num de experiencias
p = 0.5; %prob de sair rapaz igual a sair rapariga
n= 2;   %familias de dois filhos

n_filhos = rand(n, N) < 0.5;

pelo_menos_1_filho_rapaz = sum(n_filhos) >= 1;

probSimulacao = sum(pelo_menos_1_filho_rapaz)/ N;

fprintf("Prob de ser mais que um filho rapaz %.2f\n", probSimulacao);

%% c
n_filhos = sum(rand(n, N) < 0.5);

A = n_filhos == 2;  % ter dois filhos rapaz
B = n_filhos >= 1;   %um ser rapaz

AB = A & B;

PAB = sum(AB) /sum(B);

fprintf("Prob de ser 1 rapaz sendo o outro rapaz %.2f\n", PAB);

%% d
n_filhos = rand(n, N) < 0.5;

A = n_filhos(1,:) ==1;%1_rapaz
B = n_filhos(2,:) ==1;%2_rapaz

AB = A &B;
PBA = sum(AB)/sum(A);

fprintf("Prob de ser 1 rapaz sendo o primeiro rapaz %.2f\n", PBA);

%% e

n_filhos = sum(rand(5 , 1e5) > 0.5);

A = n_filhos >= 1;  %pelo menos e rapaz
B = n_filhos == 2;  %ter no maximo 2 rapazes

AB = A & B;

Prob = sum(AB)/sum(A);

fprintf("Prob de seno maximo 2 rapazes tendo ja um rapaz %.3f\n", Prob);
%% f

n_filhos = sum(rand(5 , 1e5) > 0.5);

A = n_filhos >= 1;  %pelo menos e rapaz
B = n_filhos >= 2;  %pelo menos 2 rapazes

AB = A & B;

Prob = sum(AB)/sum(A);

fprintf("Prob de seno maximo 2 rapazes tendo ja um rapaz %.3f\n", Prob);







