%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Graph.h"
    #include "Interpreter.h"
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
%token <string> VARIABLE PRINT PRINTLN;
%token TO WHILE FUNCTION;
%token <string> ATTR COMP READGRAPH STRING;
%token <number> NUMBER;
%type <string> program block fdecl params vdecl statements statement args varlist lval expr E EP T TP F boolExpr printStmt;

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
        VARIABLE '(' params ')'           {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            *temp ='\0';
                                            strcat(temp,"void ");
                                            strcat(temp,$1);
                                            strcat(temp,"(");
                                            strcat(temp,$3);
                                            strcat(temp,")\n");
                                            tabCount++;
                                        }

params:
        vdecl ',' params                  {
                                            char *temp = (char*)malloc(sizeof(char)*100);
                                            *temp ='\0';
                                            strcat(temp,$1);
                                            strcat(temp,",");
                                            strcat(temp,$3);
                                            $$=temp;
                                        }
        |                               {
                                            $$="";
                                        }
        ;

vdecl:
        INT VARIABLE                    {
                                            char *temp = (char*)malloc(sizeof(char)*20);
                                            *temp ='\0';
                                            strcat(temp,"int ");
                                            strcat(temp,$2);
                                            $$=temp;
                                        }
        | NODE VARIABLE                 {
                                            char *temp = (char*)malloc(sizeof(char)*20);
                                            *temp ='\0';
                                            strcat(temp,"Node* ");
                                            strcat(temp,$2);
                                            $$=temp;
                                        }
        ;

statements:
        statement statements        {
                                        char *temp = (char*)malloc(sizeof(char)*20);
                                        *temp ='\0';
                                        strcat(temp,$1);
                                        strcat(temp,$2);
                                        $$=temp;
                                    }
        |                           {$$="";}
        ;
statement:
            INT varlist ';'             {
                                            char *temp = (char*)malloc(sizeof(char)*20);
                                            *temp ='\0';
                                            strcat(temp,giveTabs(tabCount));
                                            strcat(temp,"int ");
                                            strcat(temp,$2);
                                            strcat(temp,";\n");
                                            $$=temp;
                                        }
            | NODE varlist ';'          {
                                            char* temp = (char*)malloc(sizeof(char)*20);
                                            *temp ='\0';
                                            strcat(temp,giveTabs(tabCount));
                                            strcat(temp,"Node* ");
                                            strcat(temp,$2);
                                            strcat(temp,";\n");
                                            $$=temp;
                                        }
            | lval '=' expr ';'         {
                                            char *temp = (char*)malloc(sizeof(char)*20);
                                            *temp ='\0';
                                            strcat(temp,giveTabs(tabCount));
                                            strcat(temp,$1);
                                            strcat(temp,"=");
                                            strcat(temp,$3);
                                            strcat(temp,";\n");
                                            $$=temp;
                                        }
            | FORNODE VARIABLE ':' VARIABLE {tabCount++;}'{' statements '}'{tabCount--;}  {
                                                        char *temp = (char*)malloc(sizeof(char)*1000);
                                                        *temp ='\0';
                                                        strcat(temp,forNodeClause($2,$4));
                                                        strcat(temp,$7);
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"}\n");
                                                        $$=temp;
                                                    }
            | FOREDGE VARIABLE TO VARIABLE ':' VARIABLE {tabCount++;}'{' statements '}'{tabCount--;} {
                                                        char *temp = (char*)malloc(sizeof(char)*1000);
                                                        *temp ='\0';
                                                        strcat(temp,forEdgeClause($2,$4,$6));
                                                        strcat(temp,$9);
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"}\n");
                                                        $$=temp;
                                                    }
            | IF '(' boolExpr ')' {tabCount++;}'{' statements '}'{tabCount--;}  {
                                                        char *temp = (char*)malloc(sizeof(char)*1000);
                                                        *temp ='\0';
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"if(");
                                                        strcat(temp,$3);
                                                        strcat(temp,")\n");
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"{\n");
                                                        strcat(temp,$7);
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"}\n");
                                                        $$=temp;
                                                    }
            | WHILE '(' boolExpr ')' {tabCount++;} '{' statements '}' {tabCount--;}  {
                                                        char *temp = (char*)malloc(sizeof(char)*2000);
                                                        *temp ='\0';
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"while(");
                                                        strcat(temp,$3);
                                                        strcat(temp,")\n");
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"{\n");
                                                        strcat(temp,$7);
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"}\n");
                                                        $$=temp;
                                                    }
            | printStmt ';'                 {
                                                char *temp = (char*)malloc(sizeof(char)*30);
                                                *temp ='\0';
                                                strcat(temp,giveTabs(tabCount));
                                                strcat(temp,$1);
                                                strcat(temp,";\n");
                                                $$=temp;
                                            }
            | READGRAPH '(' ')' ';'         {$$=readGraphClause(tabCount);}
            | VARIABLE '(' args ')' ';'     {
                                                char *temp = (char*)malloc(sizeof(char)*30);
                                                *temp ='\0';
                                                strcat(temp,giveTabs(tabCount));
                                                strcat(temp,$1);
                                                strcat(temp,"(");
                                                strcat(temp,$3);
                                                strcat(temp,");\n");
                                                $$=temp;
                                            }
            ;

args:
    expr ',' args                   {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,$1);
                                    strcat(temp,",");
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    |                           {
                                    $$="";
                                }
    ;

varlist:
            VARIABLE ',' varlist    {
                                        char* temp = (char*)malloc(sizeof(char)*50);
                                        *temp='\0';
                                        strcat(temp,$1);
                                        strcat(temp,",");
                                        strcat(temp,$3);
                                        $$=temp;
                                    }
            |                       {
                                        $$="";
                                    }
            ;

lval:
        VARIABLE                    {
                                        char* temp = (char*)malloc(sizeof(char)*10000);
                                        *temp='\0';
                                        $$=temp;
                                    }
        | VARIABLE '.' ATTR         {
                                        char* temp = (char*)malloc(sizeof(char)*10000);
                                        *temp='\0';
                                        $$=temp;
                                    }
        ;

expr:
        E                {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }

E:
    T EP                {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

EP:
    '+' T EP            {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | '-' T EP            {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    |                   {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

T:
    F TP                {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

TP:
    '*' F TP            {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | '/' F TP            {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    |                   {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

F:
    lval                {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | NUMBER             {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | '(' E ')'         {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

boolExpr:
    expr COMP expr        {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    ;

printStmt:
    PRINT lval          {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | PRINT STRING      {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | PRINTLN lval      {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
    | PRINTLN STRING    {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    $$=temp;
                                }
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
    /*graph = createGraph("2.edges");*/
    str =(char*)malloc(sizeof(char)*10000);
    *str='\0';
    strcat(str,outInit());
    tabCount=0;
    // print(graph);
    // printf("%d\n",weight(2,0,graph) );
	yyparse();
	return 0;
}
