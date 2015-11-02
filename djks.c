#include <stdio.h>
#include "Graph.c"

Graph *graph;

void main(int argc,char** argv)
{
	graph = createGraph(argv[1]);
	GNode *u,*v,*w;
	int i,j,wt,k,min,len;
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		u->dist=999999999;
		u->avail=1;
	}
	u=getNode(0);
	u->dist=0;
	len=edgeCount(0);
	i=0;
	while(i<len)
	{
		min=999999999;
		for(k=0;k<graph->nodes;k++)
		{
			w=graph->arr+k;
			if(w->avail==1&&w->dist<min)
			{
				min=w->dist;
				u=w;
			}
		}
		for(j=0;j<u->length;j++)
		{
			v=u->neighbours[j];
			if(v->avail==1)
			{
				wt=weight(u,j);
				if(u->dist+wt<v->dist)
				{
					v->dist=u->dist+wt;
				}
			}
		}
		u->avail=0;
		i=i+1;
	}
	for(i=0;i<graph->nodes;i++)
	{
		u=graph->arr+i;
		printf("%d",u->name);
		printf(" ");
		printf("%d\n",u->dist);
	}
}
