%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Graph.h"
    int yylex(void);
    void yyerror();
    extern FILE *yyin;
    extern FILE *yyout;
%}

%%
program : ;
%%

void yyerror(char *text)
{
	printf("ERROR\n");
	exit(0);
}

int main(int argc,char *argv[])
{
	yyin=fopen(argv[1],"r");
    Graph *graph = createGraph("2.edges");
    print(graph);
	// yyparse();
	return 0;
}
