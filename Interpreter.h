/*
    Nalam V S S Krishna Chaitanya
    Interpreter
*/
#include <stdio.h>
#include <stdlib.h>
#include "Graph.h"

#ifndef INTERPRETER_H
#define INTERPRETER_H

typedef struct _Symbol
{
    int used;
    int type;
    char *name;
    int index;
}Symbol;

typedef struct _Context
{
    Symbol* symbols;

}Context;


// Initial Output.
char* outInit();

// Gives tabs.
char* giveTabs(int tabCount);

// forNodeClause
char* forNodeClause(char* var1,char* var2);

// forEdgeClause
char* forEdgeClause(char* var1,char* var2,char* var3);

// readGraphClause
char* readGraphClause(int tabCount);
#endif
