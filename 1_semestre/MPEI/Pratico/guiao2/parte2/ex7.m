%% a
lamb = 15;

k = 0;

final = (lamb.^k/factorial(k))* exp(-lamb)

%% b

lamb = 15;

k = 10;
final =0;
for i = 0 : k
    final = final + (lamb.^i/factorial(i))* exp(-lamb);
end
 
final = 1 - final