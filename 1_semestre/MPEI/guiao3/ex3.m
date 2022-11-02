%% a
T = rand(20, 20);

for i = 1 : 20
    c(i) = sum(T(:,i));
end
c;
% n e estocatica

%% b

T = rand(20, 20);

for i = 1 : 20
    c = sum(T(:,i));
    T(:,i) = T(:, i) /c;
end

x0 = zeros(20,1);
x0(1)=1;

%pode se fazer de qualquer maneira
res1 = T^2 *x0;
res1(20,1);

res = T^2;
res(20,1)

res = T^5; 
res(20,1)
res = T^10; 
res(20,1)
res = T^100; 
res(20,1)