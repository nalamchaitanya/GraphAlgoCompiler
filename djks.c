#include <stdio.h>
#include "Graph.h"

Graph *graph;

void main(int argc,char** argv)
{
	graph = createGraph(argv[1]);
	GNode *u,*v,*w,*x;
	int i,j,wt,k,min;
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		u->dist=999999999;
		u->avail=1;
	}
	u=getNode(0);
	u->dist=0;
	for(i=0;i<graph->nodes;i++)
	{
		x=graph->arr+i;
		min=999999999;
		for(k=0;k<graph->nodes;k++)
		{
			w=graph->arr+k;
			if(w->avail==1)
			{
				if(w->dist<min)
				{
					min=w->dist;
					u=w;
				}
			}
		}
		for(j=0;j<u->length;j++)
		{
			v=u->neighbours[j];
			if(v->avail==1)
			{
				wt=weight(u,v);
				if(u->dist+wt<v->dist)
				{
					v->dist=u->dist+wt;
				}
			}
		}
		u->avail=0;
	}
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		printf("%d\n",u->dist);
	}
}
