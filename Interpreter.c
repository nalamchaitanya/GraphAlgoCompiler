#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Graph.h"
extern int tabCount;
// Initial Output.
char* outInit()
{
	char *temp =(char*)malloc(sizeof(char)*1000);
	*temp='\0';
	strcat(temp,"#include <stdio.h>\n#include \"Graph.h\"\n\n");
	return temp;
}

char* giveTabs()
{
	char* tab = (char*)malloc(sizeof(char)*(tabCount+1));
	memset(tab,9,tabCount);
	tab[tabCount]='\0';
	return tab;
}
