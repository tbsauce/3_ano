%% a

p = 1/1000;
N = 1e5;
experiencias = sum(rand(8000, N)< p);

xi = 0:8000;
px = zeros(1,8000);
for i = xi
    px(i+1) = sum(experiencias==i) / N;
end

px(7)


%% b
p = 1/1000;
n = 8000;
l = n * p;
k = 7;

final = (l.^k/factorial(k))* exp(-1*l);