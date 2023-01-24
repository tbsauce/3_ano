%%reseting
clear;
clc;
%% read data files

%reads u.data 
load("u.data");

%reads Films.txt
listMoviesBin = readcell('u_item.txt', 'Delimiter','\t');
movie_genre = ["" "unknown" "Action" "Adventure" "Animation" "Children's" "Comedy" "Crime" "Documentary" "Drama" "Fantasy" "Film-Noir" "Horror" "Musical" "Mystery" "Romance" "Sci-fi" "Thriller" "War" "Western"];

%generos de boolean para text
for i=1 : length(listMoviesBin)
    listMovies(i,1)=listMoviesBin(i,1);
    k=1;
    for j=2 : length(listMoviesBin(i,:))
        if isequal(listMoviesBin{i,j},1)
            k = k+1;
            listMovies(i,k) = {movie_genre(1,j)};
        end
    end
end


%all users
users = unique(u(:,1)); % Extrai os IDs dos utilizadores
Nu = length(users); % Numero de utilizadores

fprintf("Read Done!\n");
%% Encontra Filmes de todos os users

Set = cell(Nu,1);
for n = 1:Nu
    % Obtem os filmes de cada user
    ind = find(u(:,1) == users(n));
    Set{n} = [Set{n} u(ind,2) u(ind,3)];
end
fprintf("Filmes do Users Done!\n");

%% Counting bloom filter
for i=1:length(u)
    vec{i,1} = u(i,2);
end

n =length(vec) * 8;
m = length(vec);
k = 5;

BF = init(n);

for i = 1:m
    BF = insert(vec{i}, BF, k);
end

fprintf("Counting Bloom Filter Done!\n");

%% usersByMovie

K = 200;  % Número de funções de dispersão
usersByMovie = inf(Nu,K);
for i = 1:Nu
    conjunto = Set{i};
    for j = 1:length(conjunto)
        idx = find(u(:,1) == users(i) & u(:,2) == conjunto(j));
        if( u(idx,3) >= 3)
            chave = char(conjunto(j));
            hash = zeros(1,K);
            for kk = 1:K
                chave = [chave num2str(kk)];
                hash(kk) = DJB31MA(chave,127);
            end
            usersByMovie(i,:) = min([usersByMovie(i,:); hash]);  % Valor minimo da hash para este titulo
        end
    end
end

fprintf("usersByMovie Done!\n");
%% moviesByGenero

K = 200;  % Número de funções de dispersão
moviesByGenero = inf(length(listMovies),K);
for j = 1:length(listMovies)
    for l =2 : length(listMovies(j,:))
        if ~isa(listMovies{j,l}, "double")
            chave = char(listMovies{j,l});
        end
        hash = zeros(1,K);
        for kk = 1:K
            chave = [chave num2str(kk)];
            hash(kk) = DJB31MA(chave,127);
        end
        moviesByGenero(j,:) = min([moviesByGenero(j,:); hash]);  % Valor minimo da hash para este genero
    end
end

fprintf("Genero Done!\n");

%% usersByMovie Shingles

shingleSize = 3;
K = 200;  % Número de funções de dispersão
textShingles = inf(length(listMovies),K);
for j = 1:length(listMovies)
    word = lower(listMovies{j,1});
    shingles = {};
    for i = 1: length(word) - shingleSize +1
        shingles{i} = word(i:i+shingleSize-1);
    end 

    for i =1 :length(shingles)
        chave = char(shingles{i});
        hash = zeros(1,K);
        for kk = 1:K
            chave = [chave num2str(kk)];
            hash(kk) = DJB31MA(chave,127);
        end
        textShingles(j,:) = min([textShingles(j,:); hash]);  % Valor minimo da hash para este shingle
    end
end

fprintf("Shingles Done!\n");
%% Saving data
save 'data' 'Set' 'users' 'listMovies' 'usersByMovie' 'moviesByGenero' 'textShingles' 'BF'

%% funtions Bloom Filter

function BF = init(n)
    BF = zeros(1,n);
end

function BF = insert(elemento, BF, k)
    n = length(BF);
    for i = 1:k
        elemento = [elemento num2str(i)];
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        BF(h) = BF(h) + 1;
    end
end

