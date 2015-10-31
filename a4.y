%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Graph.h"
    int yylex(void);
    void yyerror();
    extern FILE *yyin;
    extern FILE *yyout;
    char *str;
    int tabCount;
%}

%union
{
    int number;
	char* string;
};

%token GRAPH INT NODE;
%token FORNODE FOREDGE IF;
%token VARIABLE PRINT PRINTLN;
%token TO WHILE FUNCTION;
%token ATTR NUMBER COMP;

%%

program:
        block program               {
                                        char* temp = (char*)malloc(sizeof(char)*10000);
                                        *temp='\0';
                                        strcat(temp,$1);
                                        strcat(temp,$2);
                                        $$=temp;
                                    }
        | block                     {
                                        $$=$1;
                                    }
        ;

block:
        FUNCTION fdecl '{' statements '}'   {
                                                char *temp = (char*)malloc(sizeof(char)*1000);
                                                *temp ='\0';
                                                strcat(temp,$2);
                                                strcat(temp,"{");
                                                strcat(temp,$4);
                                                strcat(temp,"}\n");
                                                $$=temp;
                                                tabCount--;
                                            }

fdecl:
        VARIABLE '(' args ')'           {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            *temp ='\0';
                                            strcat(temp,"void ");
                                            strcat(temp,$1.string);
                                            strcat(temp,"(");
                                            strcat(temp,$3);
                                            strcat(temp,")\n");
                                            tabCount++;
                                        }

args:
        vdecl ',' args                  {

                                        }
        |                               {

                                        }
        ;

vdecl:
        INT VARIABLE                    {}
        | NODE VARIABLE                   {}
        ;

statements:
            INT varlist ';'             {}
            | NODE varlist ';'            {}
            | lval '=' expr ';'       {}
            | FORNODE VARIABLE '{' statements '}' {}
            | FOREDGE VARIABLE TO VARIABLE '{' statements '}' {}
            | IF '(' boolExpr ')' '{' statements '}'  {}
            | WHILE '(' boolExpr ')' '{' statements '}'   {}
            | printStmt ';'                  {}
            | READGRAPH '(' ')' ';'         {}
            |
            ;

varlist:
            VARIABLE ',' varlist    {}
            |                       {}
            ;
lval:
        VARIABLE                    {}
        | VARIABLE '.' ATTR         {}
        ;

expr:
        E                {}

E:
    T EP                {}
    ;

EP:
    '+' T EP            {}
    | '-' T EP            {}
    |                   {}
    ;

T:
    F TP                {}
    ;

TP:
    '*' F TP            {}
    | '/' F TP            {}
    |                   {}
    ;

F:
    lval                {}
    | NUMBER             {}
    | '(' E ')'         {}
    ;

boolExpr:
    expr COMP expr        {}
    ;

printStmt:
    PRINT lval          {}
    | PRINT STRING      {}
    | PRINTLN lval      {}
    | PRINTLN STRING    {}
    ;
%%

void yyerror()
{
	printf("ERROR\n");
	exit(0);
}

int main(int argc,char *argv[])
{
	yyin=fopen(argv[1],"r");
    graph = createGraph("2.edges");
    str =(char*)malloc(sizeof(char)*10000);
    *str='\0';
    strcat(str,outInit());
    tabCount=0;
    // print(graph);
    // printf("%d\n",weight(2,0,graph) );
	yyparse();
	return 0;
}
