#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Graph.h"

// Initial Output.
char* outInit()
{
	char *temp =(char*)malloc(sizeof(char)*1000);
	*temp='\0';
	strcat(temp,"#include <stdio.h>\n#include \"Graph.h\"\n\n");
	return temp;
}

char* giveTabs(int tabCount)
{
	char* tab = (char*)malloc(sizeof(char)*(tabCount+1));
	memset((void*)tab,9,tabCount);
	tab[tabCount]='\0';
	return tab;
}

char* forNodeClause(char* var1,char* var2)
{
	return NULL;
}

char* forEdgeClause(char* var1,char* var2,char* var3)
{
	return NULL;
}

char* readGraphClause(int tabCount)
{
	return NULL;
}
