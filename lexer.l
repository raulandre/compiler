%{
#include "parser.tab.h"
#include "../include/table.h"
#include "../include/types.h"
%}

%x SCOMMENT
%x COMMENT
%option yylineno

%%

[ \n\r\t]+ { ; }
"println" { return PRINTLN; }
"print" { return PRINT; }
"quit" { return QUIT; }
"tidy" { return TIDY; }
"{" { return DO; }
"}" { return END; }
"int" { yylval.n = INT; return TYPE; }
"char" { yylval.n = CHAR; return TYPE; }
"float" { yylval.n = FLOAT; return TYPE; }
"string" { yylval.n = STRING; return TYPE; }
[a-zA-Z_][a-zA-Z_\-0-9]* { yylval.s = strdup(yytext); return ID; } 
"'"[a-zA-Z ]"'" { yylval.n = yytext[1]; return LETTER; }
\"(\\.|[^"\\])*\" { yylval.s = strdup(yytext); return STR; }
"0x"[0-9A-F]+ { yylval.n = strtol(yytext, NULL, 16); return NUM; }
"0b"[01]+ { yylval.n = strtol(yytext + 2, NULL, 2); return NUM; }
"0"[0-7]+ { yylval.n = strtol(yytext, NULL, 8); return NUM; }
[0-9]+\.[0-9]+ { yylval.n = atof(yytext); return NUM; }
[0-9]+ { yylval.n = atoi(yytext); return NUM; }
"=" { return ATTRIB; }
[;] { return SEMI; }
[+] { return SUM; }
[-] { return SUB; }
[*] { return MUL; }
[/] { return DIV; }
[(] { return OB; }
[)] { return CB; }
"^" { return POW; }
"+=" { return PEQU; }
"-=" { return MEQU; }
"*=" { return TEQU; }
"/=" { return DEQU; }
"'" { return SQUOTE; }
"//" { BEGIN(SCOMMENT); }
<SCOMMENT>[\n] { BEGIN(INITIAL); }
<SCOMMENT>. { }
"/*" { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>. { }
<<EOF>> { exit(0); }
. { printf("Error on line %d, unrecognized token '%s'\n", yylineno, yytext); exit(1); }

%%
