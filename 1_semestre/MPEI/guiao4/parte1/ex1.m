%% a

N = 1e5;
alpha = ['a':'z' 'A':'Z'];
keys = genKeys(N,6, 20, alpha);
save keys.mat

%% b 

N = 1e5;
alpha = 'a':'z';
prob = load("FicheirosComplementares\prob_pt.txt");
keys_prob = genKeys(N,6, 20, alpha, prob)
save keys_prob.mat

%% functions

function keys = genKeys(N, iMin, iMax, chars, prob)
    keys = {};
    
    for n = 1 : N
        word = '';
        size=randi([iMin, iMax]);
        for i = 1 : size
            switch nargin
                case 4
                    word = [word chars(randi([1 length(chars)]))];
                case 5
                    word = [word discrete_rnd(chars, prob)];
            end
                    
        end
        keys(n) = {word};
    end         
end


function state = discrete_rnd(states, probVector)
     U=rand();
     i = 1 + sum(U > cumsum(probVector));
     state= states(i);
end