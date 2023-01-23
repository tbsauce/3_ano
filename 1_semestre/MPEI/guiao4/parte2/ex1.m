n = 8000;
m = 1000;
m2 = 10000;
k = 3;

fid = fopen('wordlist-preao-20201103.txt','r');
dicionario = textscan(fid,'%s');
fclose(fid);
dicionario = dicionario{1,1};

BF = init(n);
%ex1
for i = 1:m
    BF = insert(dicionario{i}, BF, k);
end

%ex2
contador = 0;
for i = 1:m
    check = valid(dicionario{i}, BF, k);
    if ~check
        contador = contador + 1;
    end
end
fprintf('No. false negativos = %d\n', contador);

%ex3
contador = 0;
for i = m + 1: m + m2
    check = valid(dicionario{i}, BF, k);
    if check
        contador = contador + 1;
    end
end
fprintf('Pec. falsos positivos = %.2f%%\n', 100*contador/m2);
%ex4
fprintf('Pec. falsos positivos teórica = %.2f%%\n', 100*(1-exp(-k*m/n))^k);



%% funtions

function BF = init(n)
    BF = false(1,n);
end

function BF = insert(elemento, BF, k)
    n = length(BF);
    for i = 1:k
        elemento = [elemento num2str(i)];
        elemento
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        BF(h) = true;
    end
end

function check = valid(elemento, BF, k)
    n = length(BF);
    check = true;
    for i = 1:k
        
        elemento = [elemento num2str(i)];
        h = DJB31MA(elemento, 127);
        h = mod(h,n) + 1; %para dar valor entre 1 e n para por no BF
        if ~BF(h)
            check = false;
            break;
        end
    end
end





