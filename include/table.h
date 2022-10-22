#ifndef TABLE_H
#define TABLE_H
#define TABLE_SIZE 1000

#include "types.h"

typedef struct {
    char *name;
    type type;
    union {
        float n;
        char *s;  
    };
} sym;

int find(char *name);
int declare(char *name, type type);
void undeclare(char *name);
int setn(char *name, float value);
float getn(char *name);
char *sets(char *name, char *value);
char *gets(char *name);
type gettype(char *name);

#endif
