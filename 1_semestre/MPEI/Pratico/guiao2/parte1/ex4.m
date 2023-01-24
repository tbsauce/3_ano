p = 0;
pessoas = 1;
N = 1e3;
while p < 0.5
  pessoas = pessoas + 1;
  aniversarios = randi([1,365], pessoas, N)
  sum = 0;
  for i = 1:N
      if length(unique(aniversarios(:, i))) ~= pessoas
          sum = sum + 1;
      end
  end
  p = sum / N;
end
fprintf("A) %d pessoas", pessoas);


%% b
p = 0;
pessoas = 1;
N = 1e3;
while p < 0.9
  pessoas = pessoas + 1;
  aniversarios = randi([1,365], pessoas, N)
  sum = 0;
  for i = 1:N
      if length(unique(aniversarios(:, i))) ~= pessoas
          sum = sum + 1;
      end
  end
  p = sum / N;
end
fprintf("B) %d pessoas", pessoas);