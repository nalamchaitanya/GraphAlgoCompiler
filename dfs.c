#include <stdio.h>
#include "Graph.c"
Graph *graph;

void DFS(GNode* u)
{
	GNode *v;
	int i;
	u->dfsnum=1;
	printf("%d\n",u->name);
	for(i=0;i<u->length;i++)
	{
		v=u->neighbours[i];
		if(v->dfsnum==0)
		{
			DFS(v);
		}
	}
}
void main(int argc,char** argv)
{
	GNode *u;
	int i;
	graph = createGraph(argv[1]);
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		u->dfsnum=0;
	}
	u=getNode(0);
	DFS(u);
}
