grammar StrLang;

program: stat * EOF;

stat: assing | print | expr;

assing: ID ':' expr;

print: 'print' expr;

expr: '('expr')'                          #exprParent
    | 'trim' expr                   #exprTrim
    | expr op=('+' | '-') expr      #exprCalc
    | expr '/' expr '/' expr        #exprSubs
    |'input''('expr ')'           #exprScan
    | String                        #exprString
    | ID                            #exprID
;
ID: [a-zA-Z0-9_]+;
String: '"'.*?'"';
WS: [ \n\t\r] -> skip;
Comment: '//' .*? '\n' -> skip;


