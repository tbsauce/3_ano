%% a

T = [
        0.7    0.2     0.1;
        0.2    0.3     0.5;
        0.3    0.3     0.4
    ]';

%% b
    
x0=[1;0;0];

n = [1 2];

for i = 1 : length(n)
    res(:,i ) = T^n(1, i) * x0;
end

res
fprintf("Segundo terceiro dia estar sol %f\n", res(1,1) * res(1,2));

%% c

x1=[1;0;0];     %dia1

x2 = T  * x1;   %dia 2

x2linha = [0.7 ; 0.2 ; 0];   %dia 2 forcando n chover

x2linha = x2linha / sum(x2linha);

x3 =  T * x2linha;      %dia 3 tendo considerando n ter chovido

fprintf("Nem segundo nem no terceiro chover %f\n",sum(x2(1:2)) * sum(x3(1:2)));

%% d
clear res
for i = 1:30
    res(:,i) = T^i * x0;
end

res = [x0 res];
fprintf("Numero de dias de sol em janeiro %f\n", sum(res(1, :)));
fprintf("Numero de dias de nuvens em janeiro %f\n", sum(res(2, :)));
fprintf("Numero de dias de chuva em janeiro %f\n", sum(res(3, :)));

%% e

x0=[0;0;1];

for i = 1:30
    res(:,i) = T^i * x0;
end

res = [x0 res];
fprintf("Numero de dias de sol em janeiro %f\n", sum(res(1, :)));
fprintf("Numero de dias de nuvnes em janeiro %f\n", sum(res(2, :)));
fprintf("Numero de dias de chuva em janeiro %f\n", sum(res(3, :)));


%% f
clear res
x0=[0;0;1];

for i = 1:30
    res(:,i) = T^i * x0;
end

res = [x0 res];
fprintf("Numero de dores comecando em chuva em janeiro %f\n", sum(res(1, :)) * 0.1);
fprintf("Numero de dores comecando em chuva em janeiro %f\n", sum(res(2, :)) * 0.3);
fprintf("Numero de dores comecando em chuva em janeiro %f\n", sum(res(3, :)) * 0.5);
clear res
x0=[1;0;0];

for i = 1:30
    res(:,i) = T^i * x0;
end

res = [x0 res];
fprintf("Numero de dores comecando em sol em janeiro %f\n", sum(res(1, :)) * 0.1);
fprintf("Numero de dores comecando em sol em janeiro %f\n", sum(res(2, :)) * 0.3);
fprintf("Numero de dores comecando em sol em janeiro %f\n", sum(res(3, :)) * 0.5);




