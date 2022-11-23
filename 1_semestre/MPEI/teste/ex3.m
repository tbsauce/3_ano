%% a
%folha de teste
%% b 

        % 1     3       5       7       9       Fim
T = [
        0      0.25     0       0.25    0       0;
        1/3    0        0.5     0       3/8     0;
        1/3    0.25     0       0.25    0       0;
        1/3    0        0.5     0       3/8     0;
        0      0.25     0       0.25    0       0;
        0      0.25     0       0.25    0.25    0;
    ];

%% c

%esolha do estado inicial
% [1 2 3 4 5] -> 1 3 5 7 9
stateInicial =  discrete_rnd([1 2 3 4 5], [1/4; 1/8; 1/4; 1/4; 1/8]);


state = crawl(T, stateInicial, 6);
% 5 4 1 4 6 -> 9 7 1 7 FIM

%% d  & e & g
N = 10^6;
c = cell(1,N);
soma = 0;
size = 0;
numC = 0;
for i = 1: N
    stateInicial =  discrete_rnd([1 2 3 4 5], [1/4; 1/8; 1/4; 1/4; 1/8]);
    state = crawl(T, stateInicial, 6);
    if isequal([4 1 3 2 5 6],state)
        soma = soma + 1; 
    end
    if state(1) == 2
        size = size + length(state);
        numC = numC +1 ;
    end
    c(:, i)= {state};
end

prob = soma / N
media = size/numC

%% f
% 7     1      5    3      9    Fim
% 1/4 * 1/4 * 1/3 * 1/2 * 1/4 * 1/4 = 1/1536

%% functions
function [state] = crawl(H, first, last)
     state = [first];
     while (1)
          state(end+1) = nextState(H, state(end));
          if ismember(state(end), last) 
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