%% a and b
N = 1e5;
T = 1000;
a = randi(T, 20, N);

for i = 1:N
    res(i) = length(unique(a(:, i))) < 20;
end

prob = sum(res)/N;

fprintf("Prob a) %.2f\n", prob);

plot(T, res);

%% b

N = 1e5;
T = 1000;
a = randi(T, 20, N);
key = 50;

for j = 1:10

    a = randi(T *100, key, N);

    for i = 1:N
        res(i) = length(unique(a(:, i))) == key;
    end

    prob(j) = sum(res)/N;
end

plot(100:100:1000,prob) 

