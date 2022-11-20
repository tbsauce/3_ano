%% a

load("L.mat");
sum(L);

%% b 

for i = 1 : length(L)
    soma = sum(L(:, i));
    if(soma ~= 0)
        H(:, i) = L(:, i)/soma;
    end
end

sum(H);

%% c tenho de corrigit dead heand?
b = 0.85;
A = b * H +(1 - b)* ((1/length(H)) * ones(length(H)));

%% d

x0 = (1/length(H)) * ones(length(H), 1);
for i = 0 : 100000 
    x0 = A * x0;
end

x0
