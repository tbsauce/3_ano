%% reseting
clear;
clc;

%% starts app
load data.mat;
user = 0;
appFuntion(user, users, Set, listMovies, usersByMovie, moviesByGenero, textShingles, BF);

%% APP
function appFuntion(user, users, Set, listMovies, usersByMovie, moviesByGenero, textShingles, BF)
    while(1)
        clc;
        if (user == 0)
            tmp = input('Insert User ID (1 to 943): ');
            if (tmp< 1 || tmp>943)
                fprintf('User ID must be between 1 and 943!');
                pause(2);
            else
                user = tmp;
            end
        else
            option = input(['1 - Your Movies' ...
                            '\n2 - Suggestion of movies based on other users' ...
                            '\n3 - Suggestion of movies based on already evaluated movies' ...
                            '\n4 - Search Title' ...
                            '\n5 - Exit' ...
                            '\nSelect choice: ']);
        
            switch option
                case 1
                     fprintf("Option 1 was selected!\n");
                     pause(1);
                     yourMovies(user, Set, listMovies, BF);
                case 2
                     fprintf("Option 2 was selected!\n");
                     pause(1);
                     otherUserSugestions (length(users), usersByMovie, user, Set, listMovies);
                case 3
                     fprintf("Option 3 was selected!\n");
                     pause(1);
                     movieGenreSugestions (length(listMovies), moviesByGenero, user, Set, listMovies)
                case 4
                      fprintf("Option 4 was selected!\n");
                      pause(1);
                      clc;
                      titleSearch(length(listMovies), textShingles, listMovies)
                case 5
                    return
            end
            if(option<=5 && option >=1)
                user = 0;
            end
        end
    end
end

%% yourMovies Function
function yourMovies(user, Set, listMovies, BF)
    k = 5;
    fprintf('\nFilmes vistos:\n');
    for i = 1:length(Set{user})
        fprintf('%s , ID:%d , CBF: %d\n', listMovies{Set{user}(i)}, Set{user}(i), couting(Set{user}(i), BF, k));
    end
    pause;
end

%Bloom Filter Funtion
function count = couting(elemento, BF, k)
    n = length(BF);
    count = 0;
    for i = 1:k
        elemento = [elemento num2str(i)];
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        count = BF(h);
    end
end

%% otherUserSugestions
function otherUserSugestions (Nu, usersByMovie, user, Set, listMovies)
    K = 200;
    J=zeros(1,Nu);               % array para guardar distancias
    h= waitbar(0,'Calculating');
    for n= 1:Nu
        waitbar(n/Nu,h);
        if user ~= n
            J(1, n) = sum(usersByMovie(user,:)~=usersByMovie(n,:))/K;
        end
    end
    delete(h)
    %ordena
    [~, sortedJ] = sort(J);
    %o primeiro elemento e o propeio logo da zero e n conta
    %escolhe os 3 mais pequenos e mais similares
    
    SimilarUsers = [sortedJ(2) sortedJ(3) sortedJ(4)];

    moviesToPrint = [];
    for i = 1: length(SimilarUsers)
        for n = 1:length(Set{SimilarUsers(i)})
            if (~ismember(Set{SimilarUsers(i)}(n), Set{user})) && ~ismember(Set{SimilarUsers(i)}(n), moviesToPrint)
                moviesToPrint = [moviesToPrint Set{SimilarUsers(i)}(n)];
            end
        end
    end

    if ~isempty(moviesToPrint)  
        for i = 1:length(moviesToPrint)  % Display dos filmes sugeridos
           fprintf('%s , ID:%d\n', listMovies{moviesToPrint(i)}, moviesToPrint(i));
       end
    else
        fprintf('\nNão Existe Filmes\n');
    end
    pause;
end

%% movieGenreSugestions
function movieGenreSugestions (Nm, moviesByGenero, user, Set, listMovies)
    K = 200;
    count = 0;
    h= waitbar(0,'Calculating');
    for n1=1: length(Set{user})
        waitbar(n1/length(Set{user}),h);
        if(Set{user}(n1,2) >= 3)
            count = count + 1;
            temp = [];
            n1 = Set{user}(n1,1);
            J{count, 1} = n1;
            for n2= 1:Nm
                if(n2 ~= n1 && ~ismember(n2,Set{user}(:,1)))
                    jaccard = sum(moviesByGenero(n1,:)~=moviesByGenero(n2,:))/K;
                    if(jaccard <= 0.9)
                        temp = [temp n2];
                    end
                end
            end
            J{count, 2} = temp;
        end
    end

    delete(h)


    counter = zeros(1,Nm);
    for h = 1: Nm
        for j=1:length(J)
            if(ismember(h, J{j, 2}))
                counter(:,h) = counter(:,h) + 1;
            end
        end
    end

    %ordena
    [~, sortedJ] = sort(counter);
    %o primeiro elemento e o propeio logo da zero e n conta
    %escolhe os 2 mais pequenos e mais similares
    nMovies = 2;
    for i = 0: nMovies-1
        fprintf('%s , ID:%d\n', listMovies{sortedJ(end - i)}, sortedJ(end - i));
    end
    pause;
end

%% titleSearch
function titleSearch (Mn, textShingles, listMovies)

    title = lower(input("Type a Movie: ", "s"));
    shingleSize = 3;
    K = 200;
    shingles = {};
    for i = 1: length(title) - shingleSize +1
        shingles{i} = title(i:i+shingleSize-1);

    end

       
    usersByMovieFind = inf(1,K);
    for i =1 :length(shingles)
        chave = char(shingles(i));
        hash = zeros(1,K);
        for kk = 1:K
            chave = [chave num2str(kk)];
            hash(kk) = DJB31MA(chave,127);
        end
        usersByMovieFind(1,:) = min([usersByMovieFind(1,:); hash]);  % Valor minimo da hash para este genero
    end

    flag = false;
    J=zeros(1,Mn);   
    for n= 1:Mn
        J(1, n) = sum(textShingles(n,:)~=usersByMovieFind(1,:))/K;
    end

    [~, sortedJ] = sort(J);
    for j= 1: 5
        if~(J(1,sortedJ(j)) == 1)
            flag = true;
            fprintf("%s, ID:%d\n", listMovies{sortedJ(j)}, sortedJ(j));
        end
    end

    if(~flag)
        fprintf("Pesquisa Impossivel\n");
    end
    pause;
end


