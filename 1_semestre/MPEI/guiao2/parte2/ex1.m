%% a 

xi = 1:6;
p = ones(1,6)/6;

stem(xi,p),xlabel('x'),ylabel('px(x)')


%% b

xi = 0:7;
p = ones(1,6)/6;
b = [0 cumsum(p) 1]

stairs(xi,b),xlabel('x'),ylabel('Fx(x)')