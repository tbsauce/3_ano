lamb = 0.02;   %por pagina
lamb = lamb * 100;

k = 1;
final = 0;
for i = 0 : k
    final = final + (lamb.^i/factorial(i))* exp(-lamb);
end

fprintf("%d",final);

