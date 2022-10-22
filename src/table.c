#include <string.h>
#include <stdio.h>
#include "table.h"
#include "stdlib.h"

extern int yylineno;
int last = 0;
sym table[TABLE_SIZE];

int find(char *name) {
    for(int i = 0; i < last; i++) {
        if(strcmp(name, table[i].name) == 0) return i;
    }

    return -1;
}

int declare(char *name, type type) {
    int pos = find(name);

    if(pos == -1) {
        sym s;
        s.name = strdup(name);
        s.n = 0;
        s.type = type;
        table[last++] = s;
#ifdef DEBUG
        printf("[INFO]: variable '%s' declared!\n", name);
#endif
        return last - 1;
    }

    //strdup pra passar do lexer pro parser causa vazamento de memória se não for liberado agora
    free(name);

    return pos;
}

int setn(char *name, float value) {
    int pos = find(name);

    if(pos == -1) {
        fprintf(stderr, "Error on line %d, use of undeclared variable\n", yylineno);
        return -1;
    }
    
    if(table[pos].type != INT && table[pos].type != CHAR && table[pos].type != FLOAT) {
        fprintf(stderr, "Error on line %d, variable %s is not of type INT or similar\n", yylineno, name);
        return rand();
    }

    table[pos].n = value;
    #ifdef DEBUG
    printf("[INFO]: variable '%s', at pos %d, now has value %d\n", table[pos].name, pos, value);
    #endif
    return pos;
}

float getn(char *name) {
    int pos = find(name);
    if(pos < 0 || pos >= last) {
        fprintf(stderr, "Error on line %d, use of undeclared variable %s\n", yylineno, name);
        return rand();
    }

    if(table[pos].type != INT && table[pos].type != CHAR && table[pos].type != FLOAT) {
        fprintf(stderr, "Error on line %d, variable %s is not of type INT or similar\n", yylineno, name);
        return rand();
    }

#ifdef DEBUG
    printf("[INFO]: read variable '%s' with value %d\n", table[pos].name, table[pos].value);
#endif
    return table[pos].n;
}

char* sets(char *name, char *value) {
    int pos = find(name);

    if(pos == -1) {
        fprintf(stderr, "Error on line %d, use of undeclared variable %s\n", yylineno, name);
        return NULL;
    }
    
    if(table[pos].type != STRING) {
        fprintf(stderr, "Error on line %d, variable %s is not of type STRING or similar\n", yylineno, name);
        return NULL;
    }

    size_t length = sizeof(char) * strlen(value) + 1;
    if(length == 0) {
        return NULL;
    }

    table[pos].s = (char*)malloc(length);
    char *s = value + 1;
    int c = 0;
    while(s[c] != '"') {
        table[pos].s[c++] = s[c];
    }
    free(value);
    #ifdef DEBUG
    printf("[INFO]: variable '%s', at pos %d, now has value %d\n", table[pos].name, pos, value);
    #endif
    return table[pos].s;
}

char *gets(char *name) {
    int pos = find(name);
    
    if(pos < 0 || pos > last) {
        fprintf(stderr, "Error on line %d, use of undeclared variable %s\n", yylineno, name);
        return NULL;
    }

    return table[pos].s;
}

type gettype(char *name) {
    int pos = find(name);

    if(pos < 0 || pos > last) {
        fprintf(stderr, "Error on line %d, use of undeclared variable %s\n", yylineno, name);
        return UNDEFINED;
    }

    return table[pos].type;
}