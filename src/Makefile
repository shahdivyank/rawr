all:
	bison -v -d --file-prefix=y rawr.y
	flex rawr.lex
	g++ -std=c++11 -o generator y.tab.c lex.yy.c -lfl