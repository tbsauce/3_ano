%% a
N = 1e6;
n =20;  %dardos
m = 100;    %alvos

a = randi(m, n, N); % Matriz em que as linhas sao so dardos, o valor é o nº do alvo, repetido Nx

for i = 1:N
    res(i) = length(unique(a(:, i))) == n;
end

fprintf("Prob a) %.2f\n", sum(res)/N);

%% b
N = 1e6;
n =20;  %dardos
m = 100;    %alvos
a = randi(m, n, N); % Matriz em que as linhas sao so dardos, o valor é o nº do alvo, repetido Nx
for i = 1:N
    res(i) = length(unique(a(:, i))) <= 19;
end

fprintf("Prob b) %.2f\n", sum(res)/N);
%% c
m = 1000;
N = 1e5;
nValues = 1:10;
prob = zeros(1,10);

for n = 1 : 10
    a = randi(m, n*10, N);
    
    for i = 1:N
        res(i) = length(unique(a(:, i))) < n*10;
    end
    prob(n) = sum(res)/N;
end


subplot(1,1,1)
plot(1:10:100, prob,"g")
hold on

%%%%%

m = 10000;
N = 1e5;
prob = zeros(1,10);

for n = 1 : 10
    a = randi(m, n*10, N);
    
    for i = 1:N
        res(i) = length(unique(a(:, i))) < n*10;
    end
    prob(n) = sum(res)/N;
end

subplot(1,1,1)
plot(1:10:100, prob)

xlabel('n')
ylabel('P(n)')
title('Probabilities for m = 10000 and m = 1000')


legend("1000", "10000")

%% d
n = 200;
m = [200 500 1000 2000 5000 10000 20000 50000 100000];
N = 1e5;

for i = 1 : 9
    a = randi(m(i), n, N);
    
    for j = 1:N
        res(j) = length(unique(a(:, j))) < n;
    end
    prob(i) = sum(res)/N;
end

plot(prob, m)



