%u.data 
%user   movie   rate    time
% -> utilizadores que avaliaram conjuntos similares de filmes

% Código base para deteção de pares similares
udata=load('u.data');       % Carrega o ficheiro dos dados dos filmes

% Fica apenas com as duas primeiras colunas
u=udata(1:end,1:2); 
clear udata;

% Lista de utilizadores
users = unique(u(:,1));     % Extrai os IDs dos utilizadores
Nu= length(users);          % Número de utilizadores

% Constrói a lista de filmes para cada utilizador
Set= cell(Nu,1);            % Usa células
for n = 1:Nu                % Para cada utilizador
    % Obtém os filmes de cada um
    ind = find(u(:,1) == users(n));
    % E guarda num array. Usa celulas porque utilizador tem um numero
    % diferente de filmes. Se fossem iguais podia ser um array
    Set{n} = [Set{n} u(ind,2)];
end

tic
K=50;
MinHashValue=inf(Nu,K);

for i=1:Nu
    conjunto=Set{i};
    for j=1:length(conjunto)
        chave = char(conjunto(j));
        hash=zeros(1,K);
        for kk=1:K
            chave=[chave num2str(kk)];
            hash(kk)=DJB31MA(chave,127);
        end
        MinHashValue(i,:)=min([MinHashValue(i,:);hash]);
    end
end
 fprintf('Tempo calculo min hash: %f\n',toc);
% Calcula a distancia de Jaccard entre todos os pares pela definição.
tic
J=zeros(Nu,Nu);               % array para guardar distancias
h= waitbar(0,'Calculating');
for n1= 1:Nu
    waitbar(n1/Nu,h);
    for n2= n1+1:Nu
        %similaridade de Jaccard
        %simJ = length(intersect(Set{n1}, Set{n2})) / length(union(Set{n1}, Set{n2})); 
        %Distancia de Jaccard = 1 - similaridade de Jaccard
        %distJ = 1 - simJ; 
        J(n1,n2) = sum(MinHashValue(n1,:)~=MinHashValue(n2,:))/K;
    end
end
save 'J.mat' J
delete(h)
fprintf('Tempo calculo das distancias dadas por min hash: %f segundos\n',toc);
tic
% Com base na distancia, determina pares com
% distancia inferior a um limiar pre-definido
threshold =0.4;         % limiar de decisao
% Array para guardar pares similares (user1, user2, distancia)
SimilarUsers= zeros(1,3);
k= 1;
for n1= 1:Nu
    for n2= n1+1:Nu
        if J(n1,n2)<=0.4
            SimilarUsers(k,:)= [users(n1) users(n2) J(n1,n2)];
            k= k+1;
        end
    end
end
fprintf('Tempo calculo dos users mais similares: %f segundos\n',toc);
fprintf('Num pares mais similares= %d\n',size(SimilarUsers,1));
SimilarUsers