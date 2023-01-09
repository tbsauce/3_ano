%%reseting
clear;
clc;
%% read data files
%reads u.data 1st 2 columns
load("u.data");
uData=u(1:end,1:2); 

%reads Films.txt
allMoviesBin = readcell('u_item.txt', 'Delimiter','\t');

%all users
users = unique(u(:,1)); % Extrai os IDs dos utilizadores
Nu = length(users); % Numero de utilizadores
%% Encontra Filmes de todos os users

Set = cell(Nu,1); % Usa celulas
for n = 1:Nu % Para cada utilizador
    % Obtem os filmes de cada um
    ind = find(u(:,1) == users(n));
    % E guarda num array. Usa celulas porque utilizador tem um numero
    % diferente de filmes. Se fossem iguais podia ser um array
    Set{n} = [Set{n} u(ind,2)];
end

%% MinHashValue

K = 50;  % Número de funções de dispersão
MinHashValue = inf(Nu,K);
for i = 1:Nu
    conjunto = Set{i}; 
    for j = 1:length(conjunto)
        chave = char(conjunto(j));
        hash = zeros(1,K);
        for kk = 1:K
            chave = [chave num2str(kk)];
            hash(kk) = DJB31MA(chave,127);
        end
        MinHashValue(i,:) = min([MinHashValue(i,:); hash]);  % Valor minimo da hash para este título
    end
end

%% Saving data
save 'data' 'Set' 'users' 'allMoviesBin' 'MinHashValue'

