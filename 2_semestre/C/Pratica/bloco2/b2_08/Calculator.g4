grammar Calculator;

program:
		stat* EOF
	;
stat:
		expr? NEWLINE
	|	assignement? NEWLINE
	;

assignement: 
		ID '=' expr
		;
expr:
		op=('+'|'-') expr			#ExprIntegerSignal
	|	expr op=('*'|'/'|'%') expr	#ExprMultDivMod
	|	expr op=('+'|'-') expr		#ExprAddSub
	| 	ID 							#ExprId
	|	Integer						#ExprInteger
	|	'(' expr ')'				#ExprParent
	;

ID: [a-zA-Z_]+;
Integer: [0-9]+;	// implement long integers
NEWLINE: '\r'? '\n';
WS: [ \t]+ -> skip;
COMMENT: '#' .*? '\n' -> skip;
