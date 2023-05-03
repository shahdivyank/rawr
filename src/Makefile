all:
	clean

lexer_parser:
	bison -v -d --file-prefix=y rawr.y
	flex rawr.lex
	gcc -o parser y.tab.c lex.yy.c -lfl

array: lexer_parser
	parser ../programs/array.rawr

break: lexer_parser
	parser ../programs/break.rawr

function: lexer_parser
	parser ../programs/function.rawr

ifelse: lexer_parser
	parser ../programs/ifelse.rawr

invalid: lexer_parser
	parser ../programs/invalid.rawr

math: lexer_parser
	parser ../programs/math.rawr

unrecognized: lexer_parser
	parser ../programs/unrecognized.rawr

while: lexer_parser
	parser ../programs/while.rawr

clean:
	rm parser y.output y.tab.c y.tab.h lex.yy.c