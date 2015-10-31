letter  [a-zA-Z]
digit   [0-9]

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Interpreter.h"
    #include "Graph.h"
    #include "y.tab.h"
    extern YYSTYPE yylval;
    extern FILE *yyin;
    void yyerror();
%}

%%
("Graph")   {return GRAPH;}

("Node")    {return NODE;}

("int")     {return INT;}

("foreach node") {return FORNODE;}

("foreach edge")   {return FOREDGE;}

("to")      {return TO;}

("if")         {return IF;}

("print")       {return PRINT;}

("printLn")     {return PRINTLN;}

("dist"|"dfsnum"|"avail"|"name")      {return ATTR;}

("while")   {return WHILE;}

("readGraph")   {return READGRAPH;}

("function")    {return FUNCTION;}

("<"|">"|"<="|">="|"=="|"!=")   {
                                    yylval.string = strdup(yytext);
                                    return COMP;
                                }

[\"]([^\n\t\r])*[\"]    {
                            yylval.string = strdup(yytext);
                            return STRING;
                        }

({digit}*)      {yylval.number = atoi(yytext);return NUMBER;}

({letter}({letter}|{digit})*)   {yylval.string = strdup(yytext);return VARIABLE;}

[#]([^\n])*[\n]  {;}

("+"|"-"|"*"|"/"|"{"|"}")   {return *yytext;}

[\.();,]    {return *yytext;}

[ \t\n\r]   {return *yytext;}

.       {yyerror();}

%%

int yywrap(void)
{
    return 1;
}
