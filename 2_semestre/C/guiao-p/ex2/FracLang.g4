grammar FracLang;

program: stat* EOF;

stat: (print | assign) ';';

print: 'display' expr;

assign: ID '<=' expr;

expr:
        '('expr')'                      #exprParent
    |   'read' String                     #exprRead
    |   op=('+'|'-') expr               #exprUnitary
    |   expr op=('*'|':') expr          #exprMultDiv
    |   expr op=('+'|'-') expr          #exprAddSub
    |   'reduce' expr                   #exprReduce
    |   Num '/' Num                      #exprFrac
    |   Num                             #exprNum
    |   ID                              #exprID
   ;

Num:[0-9]+;
ID: [a-zA-Z0-9_]+;
String: '"' .*?'"';

WS:[ \r\n\t] -> skip;
Comment: '--' .*? '\n' -> skip;