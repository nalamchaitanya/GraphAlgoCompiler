#include <stdio.h>
#include "Graph.c"

Graph *graph;

void main(int argc,char** argv)
{
	graph = createGraph(argv[1]);
	GNode *u,*v,*w;
	int contn,wt,i,j;
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		u->dist=999999999;
	}
	w=getNode(0);
	w->dist=0;
	contn=1;
	while(contn==1)
	{
		contn=0;
		for(i=0;i<graph->nodes;i++)
		{
			u=graph->arr+i;
			for(j=0;j<u->length;j++)
			{
				v=u->neighbours[j];
				wt=weight(u,v);
				if(u->dist+wt<v->dist)
				{
					v->dist=u->dist+wt;
					contn=1;
				}
			}
		}
	}
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		printf("%d",u->name);
		printf(" ");
		printf("%d\n",u->dist);
	}
}
