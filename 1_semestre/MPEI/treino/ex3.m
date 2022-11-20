%% b

        % A     C       R       T       O       Fim
T = [
        0       0.5     4/15    0.5     0       0     
        4/15    0       0       0       4/15    0
        4/15    0       0       0       4/15    0
        4/15    0       4/15    0       4/15    0
        0       0.5     4/15    0.5     0       0
        0.2     0       0.2     0       0.2     0
    ];


%% c
x = randi(5, 1, 1);
state = crawl(T, x, 6);

%% d and e and g
N = 10^6;
c = cell(1,N);
soma = 0;
size = 0;
numC = 0;
for i = 1: N
    x = randi(5, 1, 1);
    state = crawl(T, x, 6);
    if isequal([2 1 4 5 6],state)
        soma = soma + 1; 
    end
    if state(1) == 2
        size = size + length(state);
        numC = numC +1 ;
    end
    c(:, i)= {state};
end

prob = soma / N;
media = size/numC;

%% f

% 1/6 * 1/2 * 4/15 * 1/2 * 0.2



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
