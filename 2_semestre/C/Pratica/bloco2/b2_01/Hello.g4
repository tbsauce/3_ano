grammar Hello ;
more: any* EOF;
any : bye | grettings;
bye : 'bye' ID+;
grettings : 'hello' ID+;
ID : [a-zA-Z]+ ; 
WS : [ \t\r\n]+ -> skip;
