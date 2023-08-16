grammar CalFrac;

program : stat* EOF;

stat:   print   #ExprPrint
    |   assign  #Exprassign
        ;

print: 'print' expr EOL;

assign: expr '->' ID EOL;

expr:   
     	op=('+'|'-') expr			#ExprIntegerSignal
	|	expr op=('*'|':') expr	    #ExprMultDiv
	|	expr op=('+'|'-') expr		#ExprAddSub
	| 	ID 							#ExprId
    |   Integer '/' Integer         #ExprFrac
    |	Integer						#ExprInteger
	|	'(' expr ')'				#ExprParent
    ;



EOL: [;];
ID: [a-zA-Z_]+;
Integer: [0-9]+;
WS : [ \t\r\n]+ -> skip;
COMMENT: '//' .*? '\n' -> skip;