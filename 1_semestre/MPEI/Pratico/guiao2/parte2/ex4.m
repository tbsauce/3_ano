%% a 
% i
pdef = 0.3;
N = 1e5;
experiencias = sum(rand(5, N)< pdef);

xi = 0:5;
px = zeros(1,6);
for i = xi
    px(i+1) = sum(experiencias==i) / N;
end

stem(xi,px);

hold on
% ii

stairs([ -1 xi], [0 cumsum(px)]);


%iii
max_2 = px(1) + px(2) + px(3)

