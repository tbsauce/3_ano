%% a

N = 1e5;
alpha = ['a':'z' 'A':'Z'];
prob = load("C:\Users\telmo\Desktop\3_ano\1_semestre\MPEI\guiao4\FicheirosComplementares\prob_pt.txt")
genKeys(N,6, 20, alpha, prob);
%% functions

function keys = genKeys(N, iMin, iMax, chars, prob)
    keys = {};
    
            for n = 1 : N
                word = "";
                size=randi([iMin, iMax]);
                for i = 1 : size
                    switch nargin
                        case 4
                            word = word + chars(randi([1 length(chars)]));
                        case 5
                            
                end
                keys(n) = {word};
            end
        

            
    end
    
end