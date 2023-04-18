all:
	flex rawr.lex
	gcc lex.yy.c -lfl