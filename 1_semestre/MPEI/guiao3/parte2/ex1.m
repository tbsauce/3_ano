%% a 

H = [
        0.8     0       0       0.3     0;
        0.2     0.6     0       0.2     0;
        0       0.3     1       0       0;
        0       0.1     0       0.4     0;
        0       0       0       0.1     1;
    ];

N = 1e5;
soma1 = 0;
soma2 = 0;
soma4 = 0;
somados3 = 0;
somados5 = 0;

for i = 1: N
    soma1 = soma1 + length(crawl(H, 1, [3 5]));
    soma2 = soma2 + length(crawl(H, 2, [3 5]));
    soma4 = soma4 + length(crawl(H, 4, [3 5]));
end

a1 = (soma1/N)-1
a2 = (soma2/N)-1
a4 = (soma4/N)-1

%so faco para um exemplo visto que e igual para todos

for i= 1: N
    m1 = crawl(H, 1, [3 5]);
    if(m1(:, length(m1)) == 3)
        somados3 = somados3 + 1;
    end
    if(m1(:, length(m1)) == 5)
        somados5 = somados5 + 1;
    end
end

b3 = somados3/N
b5 = somados5/N


%% b
T = [
        0.8     0       0.3     0     0;
        0.2     0.6     0.2     0     0;
        0       0.1     0.4     0     0;
        0       0.3     0       1     0;
        0       0       0.1     0     1;
    ];
N = 10000;
c = cell(N, 1);
 

for i = 1 : N
    x = randi(3, 1, 1);
    c(i, :) = {crawl(T, x, [4 5])};
end

tamanho = cellfun("length", c);
min = intmax;
max = intmin;

for i = 1:N
    if tamanho(i, :) > max
        max = tamanho(i, :);
    end
    if tamanho(i, :) < min
        min = tamanho(i, :);
    end
end

min 

max

%% functions
function [state] = crawl(H, first, last)
     state = [first];
     while (1)
          state(end+1) = nextState(H, state(end));
          if ismember(state(end), last) % verifies if state(end) is absorving
              break;
          end
     end
end

function state = nextState(H, currentState)
     probVector = H(:,currentState)';
     n = length(probVector);
     state = discrete_rnd(1:n, probVector);
end

function state = discrete_rnd(states, probVector)
     U=rand();
     i = 1 + sum(U > cumsum(probVector));
     state= states(i);
end
