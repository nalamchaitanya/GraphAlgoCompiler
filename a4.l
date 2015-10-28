letter  [a-zA-Z]
digit   [0-9]

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Graph.h"
    #include "y.tab.h"
    extern YYSTYPE yylval;
    extern FILE *yyin;
    void yyerror();
%}

%%


%%

int yywrap(void)
{
    return 1;
}
