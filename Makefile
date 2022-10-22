CC=gcc
LFLAGS=-lm
DEBUG=-g #-DDEBUG
OUT=compiler
OUTDIR=bin/
OBJDIR=obj/
IGNORE=#-Wno-format

all: obj bin parser lexer compile #run

obj:
	@mkdir obj

bin:
	@mkdir bin

parser: parser.y
	bison -d parser.y; mv parser.tab.c $(OBJDIR); mv parser.tab.h $(OBJDIR)

lexer: lexer.l
	flex lexer.l; mv lex.yy.c $(OBJDIR)

table: src/table.c
	cd src; $(CC) $(DEBUG) $(IGNORE) -c *.c -I../include/; mv table.o ../$(OBJDIR)

compile: $(OBJDIR)/lex.yy.c $(OBJDIR)/parser.tab.c table
	cd $(OBJDIR); $(CC) $(DEBUG) $(IGNORE) lex.yy.c parser.tab.c table.o $(LFLAGS) -o $(OUT); mv compiler ../$(OUTDIR)

#run: compile
#	cd $(OUTDIR); ./$(OUT)

clean:
	cd $(OBJDIR); rm *; cd ../$(OUTDIR); rm $(OUT)
