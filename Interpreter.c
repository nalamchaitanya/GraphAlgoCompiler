#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Graph.h"

// Initial Output.
char* outInit()
{
	char *temp =(char*)malloc(sizeof(char)*100);
	*temp='\0';
	strcat(temp,"#include <stdio.h>\n#include \"Graph.c\"\n\n");
	return temp;
}

char* giveTabs(int tabCount)
{
	char* tab = (char*)malloc(sizeof(char)*(tabCount+1));
	memset((void*)tab,9,tabCount);
	tab[tabCount]='\0';
	return tab;
}

char* forNodeClause(char* var1,char* var2,int tabCount)
{
	char* temp=(char*)malloc(sizeof(char)*100);
	*temp='\0';
	char* tmp = (char*)malloc(sizeof(char)*50);
	strcat(temp,giveTabs(tabCount));
	sprintf(tmp,"for(%s=0;%s<graph->nodes;%s++)\n",var2,var2,var2);
	strcat(temp,tmp);
	strcat(temp,giveTabs(tabCount));
	strcat(temp,"{\n");
	strcat(temp,giveTabs(tabCount+1));
	sprintf(tmp,"%s=graph->arr+%s;\n",var1,var2);
	strcat(temp,tmp);
	return temp;
}

char* forEdgeClause(char* var1,char* var2,char* var3,int tabCount)
{
	char* temp=(char*)malloc(sizeof(char)*100);
	*temp='\0';
	char* tmp = (char*)malloc(sizeof(char)*50);
	strcat(temp,giveTabs(tabCount));
	sprintf(tmp,"for(%s=0;%s<%s->length;%s++)\n",var3,var3,var1,var3);
	strcat(temp,tmp);
	strcat(temp,giveTabs(tabCount));
	strcat(temp,"{\n");
	strcat(temp,giveTabs(tabCount+1));
	sprintf(tmp,"%s=%s->neighbours[%s];\n",var2,var1,var3);
	strcat(temp,tmp);
	return temp;
}

char* readGraphClause(int tabCount)
{
	char* temp=(char*)malloc(sizeof(char)*100);
	*temp='\0';
	strcat(temp,giveTabs(tabCount));
	strcat(temp,"Graph *graph = readGraph(argv[1]);\n");
	return temp;
}

char* mainDecl()
{
	char* temp=(char*)malloc(sizeof(char)*50);
	*temp='\0';
	strcat(temp,"void main(int argc,char** argv)\n");
	return temp;
}
