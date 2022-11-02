%% a 

T = [1/3 1/4 0; 1/3 11/20 1/2 ; 1/3 1/5 1/2]

c1 = sum(T(:,1));
c2 = sum(T(:,2));
c3 = sum(T(:,3));

fprintf("c1 %d c2 %d c3 %d",c1,c2,c3);

%% b e c

A = 60;
B = 15;
C = 15;

x0 = [A ;B ;C]

n = 30;

res = T^n * x0

%% d

x0 = [30; 30;30];

n = 30;

res = T^n * x0
