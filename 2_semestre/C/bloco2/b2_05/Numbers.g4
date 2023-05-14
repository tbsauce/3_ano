grammar Numbers;

program: text * EOF;

text: line+ NEWLINE;

line: Integer ' - ' Word;

Word: [a-zA-Z]+;
Integer: [0-9]+;

NEWLINE: '\r'? '\n';
WS: [ \t]+ -> skip;
COMMENT: '#' .*? '\n' -> skip;