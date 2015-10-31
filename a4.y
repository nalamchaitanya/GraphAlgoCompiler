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
        FUNCTION fdecl {tabCount++;}'{' statements '}'{tabCount--;}   {
                                                char *temp = (char*)malloc(sizeof(char)*1000);
                                                *temp ='\0';
                                                strcat(temp,$2);
                                                strcat(temp,"{");
                                                strcat(temp,$5);
                                                strcat(temp,"}\n");
                                                $$=temp;
                                            }

fdecl:
        VARIABLE '(' params ')'         {
                                            if(strcmp($1,"main")==0)
                                                $$="void main(int argc,char** argv)\n";
                                            else
                                            {
                                                char *temp = (char*)malloc(sizeof(char)*100);
                                                *temp ='\0';
                                                strcat(temp,"void ");
                                                strcat(temp,$1);
                                                strcat(temp,"(");
                                                strcat(temp,$3);
                                                strcat(temp,")\n");
                                                $$=temp;
                                            }
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
                                                        strcat(temp,forNodeClause($2,$4,tabCount));
                                                        strcat(temp,$7);
                                                        strcat(temp,giveTabs(tabCount));
                                                        strcat(temp,"}\n");
                                                        $$=temp;
                                                    }
            | FOREDGE VARIABLE TO VARIABLE ':' VARIABLE {tabCount++;}'{' statements '}'{tabCount--;} {
                                                        char *temp = (char*)malloc(sizeof(char)*1000);
                                                        *temp ='\0';
                                                        strcat(temp,forEdgeClause($2,$4,$6,tabCount));
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
            | READGRAPH '(' ')' ';'         {$$="Graph *graph = readGraph(argv[1]);\n";}
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
                                        char* temp = (char*)malloc(sizeof(char)*20);
                                        *temp='\0';
                                        strcat(temp,$1);
                                        $$=temp;
                                    }
        | VARIABLE '.' ATTR         {
                                        char* temp = (char*)malloc(sizeof(char)*20);
                                        *temp='\0';
                                        strcat(temp,$1);
                                        strcat(temp,"->");
                                        strcat(temp,$3);
                                        $$=temp;
                                    }
        ;

expr:
        E                       {
                                    $$=$1;
                                }

E:
    T EP                        {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,$1);
                                    strcat(temp,$2);
                                    $$=temp;
                                }
    ;

EP:
    '+' T EP                    {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"+");
                                    strcat(temp,$2);
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    | '-' T EP                  {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"-");
                                    strcat(temp,$2);
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    |                           {$$="";}
    ;

T:
    F TP                        {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,$1);
                                    strcat(temp,$2);
                                    $$=temp;
                                }
    ;

TP:
    '*' F TP                    {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"*");
                                    strcat(temp,$2);
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    | '/' F TP                  {
                                    char* temp = (char*)malloc(sizeof(char)*10000);
                                    *temp='\0';
                                    strcat(temp,"/");
                                    strcat(temp,$2);
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    |                           {$$="";}
    ;

F:
    lval                        {
                                    $$=$1;
                                }
    | NUMBER                    {
                                    char* temp = (char*)malloc(sizeof(char)*10);
                                    sprintf(temp,"%d",$1);
                                    $$=temp;
                                }
    | '(' E ')'                 {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"(");
                                    strcat(temp,$2);
                                    strcat(temp,")");
                                    $$=temp;
                                }
    ;

boolExpr:
    expr COMP expr              {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,$1);
                                    strcat(temp,$2);
                                    strcat(temp,$3);
                                    $$=temp;
                                }
    ;

printStmt:
    PRINT lval                  {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"printf(\"%d\",");
                                    strcat(temp,$2);
                                    strcat(temp,");");
                                    $$=temp;
                                }
    | PRINT STRING              {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"printf(\"%s\",");
                                    strcat(temp,$2);
                                    strcat(temp,");");
                                    $$=temp;
                                }
    | PRINTLN lval              {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"printf(\"%d\n\",");
                                    strcat(temp,$2);
                                    strcat(temp,");");
                                    $$=temp;
                                }
    | PRINTLN STRING            {
                                    char* temp = (char*)malloc(sizeof(char)*100);
                                    *temp='\0';
                                    strcat(temp,"printf(\"%s\n\",");
                                    strcat(temp,$2);
                                    strcat(temp,");");
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
	str =(char*)malloc(sizeof(char)*10000);
    *str='\0';
    strcat(str,outInit());
    tabCount=0;
	yyparse();
	return 0;
}
