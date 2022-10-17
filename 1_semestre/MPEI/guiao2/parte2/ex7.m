%% a
l = 15;

k = 0;

final = (l.^k/factorial(k))* exp(-1*l)

%% b

l = 15;

k = 10;
final =0;
for i = 0 : k
    final = final + (l.^k/factorial(k))* exp(-1*l);
end

final = 1 - final