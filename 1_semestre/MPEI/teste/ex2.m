%% a 

load("L.mat");
N = 90;
deadEnds = find(sum(L) == 0)


%% b

for i = 1 : length(L)
    soma = sum(L(:, i));
    if(soma ~= 0)
        H(:, i) = L(:, i)/soma;
    end
end
H

%% c
for i = 1 : length(H)
    if(sum(i == deadEnds) == 1)
        H(:, i) = 1/N;
    end
end

b = 0.85;
A = b * H + (1 - b)* ((1/length(H)) * ones(length(H)));

%% d 
clear x0;
x0 = (1/length(H)) * ones(length(H), 1);
for i = 0 :8
    x0 = A * x0;
end

%% e

B = sort(x0,'descend');

B(1:3)
