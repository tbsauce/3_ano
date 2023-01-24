%% a

%    9   1   3   5   3   9   FIM
T = [0   0   0   0   0   0   0
     0.5 0   0   0   0   0   0
     0.5 0   0   0   0   0   0
     0   1/3 0.6 0.4 0.5 0.3 0
     0   1/3 0   0.1 0.2 0   0
     0   1/3 0.4 0.3 0   0.3 0
     0   0   0   0.2 0.3 0.4 0];

%% b

%91xxxx9
a = 1 * 0.5;

x0 = [0; a; 0; 0; 0; 0; 0];

res = T^5 * x0;

sol = (res(1, :) + res(6, :)) * 0.4

%% c
soma = 0;
N =1e5;
for i = 0 : N
    c = crawl(T, 1, 7);
    if(length(c) == 8 && c(2)==2)
        soma = soma + 1;
    end
end

a = soma/N

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
