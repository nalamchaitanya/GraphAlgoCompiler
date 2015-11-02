/*
    Nalam V S S Krishna Chaitanya
    Interpreter
*/
#include <stdio.h>
#include <stdlib.h>
#include "Graph.h"

#ifndef INTERPRETER_H
#define INTERPRETER_H

// Initial Output.
char* outInit();

// Gives tabs.
char* giveTabs(int tabCount);

// forNodeClause
char* forNodeClause(char* var1,char* var2,int tabCount);

// forEdgeClause
char* forEdgeClause(char* var1,char* var2,char* var3,int tabCount);

// readGraphClause
char* readGraphClause(int tabCount);

// declaration of main.
char* mainDecl();

#endif
