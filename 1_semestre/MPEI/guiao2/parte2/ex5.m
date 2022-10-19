
N = 1e5;

p = logspace(-3, log10(1), 100); % 0 a 1
aviao2 = zeros(1,100);
aviao4 = zeros(1,100);

for i = 1 : length(p)
    aviao2(i)= sum(sum(rand(2, N) < p(i)) >= 1)/N;
    aviao4(i)= sum(sum(rand(4, N) < p(i)) >= 2)/N;
end

crash2 = sum(aviao2)/100;
crash4 = sum(aviao4)/100;

fprintf("crash do aviao de 2 motores-> %f\n",crash2);
fprintf("crash do aviao de 4 motores-> %f\n",crash4);


