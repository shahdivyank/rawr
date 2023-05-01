all:
	bison -v -d --file-prefix=y rawr.y
	flex rawr.lex
	gcc -o rawr y.tab.c lex.yy.c -lfl