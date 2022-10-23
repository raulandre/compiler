%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "../include/table.h"
#include "../include/types.h"

extern int yylineno;
void yyerror(char *s) { printf("Error on line %d, %s\n", yylineno, s); }
int yywrap() { return 1; }

void dyn_print(char *name);

extern int yylex();
%}

%union {
  float n;
  char *s;
  void *u;
}

%type <s> ID
%type <n> NUM
%type <n> TYPE
%type <u> statement
%type <u> DO
%type <n> exp
%type <n> LETTER
%type <s> STR

%token ID NUM SEMI PRINT SUM SUB MUL DIV OB CB PEQU MEQU TEQU DEQU
       QUIT DO END ATTRIB TYPE SQUOTE LETTER STR POW TIDY
%left SUM SUB
%right MUL DIV POW
%start S

%%

S : %empty
  | S statement
  ;

statement: TYPE ID SEMI { declare($2, $1); }
        | TYPE ID ATTRIB exp SEMI { declare($2, $1); if(setn($2, $4) == -1) undeclare($2); }
        | TYPE ID ATTRIB STR SEMI { declare($2, $1); if(sets($2, $4) == NULL) undeclare($2); }
        | ID ATTRIB exp SEMI { setn($1, $3); }
        | ID ATTRIB STR SEMI { sets($1, $3); }
	| ID PEQU exp SEMI { setn($1, getn($1) + $3); }
	| ID MEQU exp SEMI { setn($1, getn($1) - $3); }
	| ID TEQU exp SEMI { setn($1, getn($1) * $3); }
	| ID DEQU exp SEMI { setn($1, getn($1) / $3); }
        | PRINT ID SEMI { dyn_print($2); }
        | PRINT STR SEMI { char *s = $2 + 1; int c = 0; while(s[c] != '"') putc(s[c++], stdout); putc('\n', stdout); }
        | PRINT exp SEMI { printf("%f\n", $2); }
        | TIDY ID SEMI { if(gettype($2) == STRING) { char *s = gets($2); if (s != NULL) free(s); } }
	| QUIT SEMI { puts("Goodbye!\n"); exit(0); }  
        | DO S END
        ;

exp : NUM { $$ = $1; }
    | LETTER { $$ = $1; }
    | ID { $$ = getn($1); }
    | exp SUM exp { $$ = $1 + $3; }
    | exp SUB exp { $$ = $1 - $3; }
    | exp MUL exp { $$ = $1 * $3; }
    | exp DIV exp { $$ = $1 / $3; }
    | exp POW exp { $$ = pow($1, $3); }
    | SUB exp { $$ = -$2; }
    | OB exp CB { $$ = $2; }
    ;
%%

int main() {
    yyparse();
}

void dyn_print(char *name) {
  type t = gettype(name);

  switch(t) {
    case INT: printf("%d\n", (int)getn(name)); break;
    case CHAR: printf("%c\n", (int)getn(name)); break;
    case FLOAT: printf("%f\n", (float)getn(name)); break;
    case STRING: printf("%s\n", gets(name)); break;
    default: break;
  }
}
