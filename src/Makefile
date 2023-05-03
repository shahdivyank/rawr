all:
	clean

parser:
	bison -v -d --file-prefix=y rawr.y
	flex rawr.lex
	gcc -o parser y.tab.c lex.yy.c -lfl

array: parser
	parser ../programs/array.rawr

break: parser
	parser ../programs/break.rawr

function: parser
	parser ../programs/function.rawr

ifelse: parser
	parser ../programs/ifelse.rawr

invalid: parser
	parser ../programs/invalid.rawr

math: parser
	parser ../programs/math.rawr

unrecognized: parser
	parser ../programs/unrecognized.rawr

while: parser
	parser ../programs/while.rawr

clean:
	rm parser y.output y.tab.c y.tab.h lex.yy.c