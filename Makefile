all: parser lexer compile run

parser: parser.y
	bison -d parser.y; mv parser.tab.c obj/; mv parser.tab.h obj/

lexer: lexer.l
	flex lexer.l; mv lex.yy.c obj/

table: src/table.c
	cd src; gcc -c *.c -I../include/; mv table.o ../obj/

compile: obj/lex.yy.c obj/parser.tab.c table
	cd obj; gcc -g lex.yy.c parser.tab.c table.o -lm -o compiler; mv compiler ../bin/

run: compile
	cd bin

clean:
	cd obj; rm *; cd ../bin/; rm compiler