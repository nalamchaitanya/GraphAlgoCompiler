#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Graph.h"

extern Graph *graph;

//Creates a new Graph.
Graph* createGraph(char* file)
{
	FILE *fp = fopen(file,"r");
	int n,m;
	fscanf(fp,"%d %d\n",&n,&m);
	Graph* graph = (Graph*)malloc(sizeof(Graph));
	graph->arr = (GNode*)malloc(sizeof(GNode)*n);
	int i,src,dst,wt;
	for(i=0;i<n;i++)
		createNode(i,n,m,graph);

	for(i=0;i<m;i++)
	{
		fscanf(fp,"%d %d %d\n",&src,&dst,&wt);
		addEdge(graph->arr+src,graph->arr+dst,graph,wt);
	}
	graph->nodes = n;
	graph->edges = m;
	return graph;
}

//Add a new Edge to graph
void addEdge(GNode* node1,GNode* node2,Graph* graph,int wt)
{
	node1->neighbours[node1->length]=node2;
	node1->weights[node1->length]=wt;
	node1->length++;
	return;
}

GNode* createNode(int name,int n,int m,Graph *graph)
{
	GNode* node;
	node = graph->arr+name;
	node->name = name;
	node->neighbours = (GNode**)malloc(sizeof(GNode*)*(m/2));
	node->weights=(int*)malloc(sizeof(int)*(m/2));
	node->length = 0;
	node->check = 0;
	return node;
	// graph->index++;
}

void print(Graph *graph)
{
	int i,j;
	for(i=0;i<graph->nodes;i++)
	{
		printf("%d : ",i);
		for(j=0;j<graph->arr[i].length;j++)
		{
			printf("%d ",graph->arr[i].neighbours[j]->name);
		}
		printf("\n");
	}
	return;
}

// gives weight between two nodes having edge.
int weight(GNode *src,GNode *dst)
{
	int i,j;
	for(i=0;i<src->length;i++)
	{
		if(dst->name==src->neighbours[i]->name)
			return src->weights[i];
	}
	return -1;
}

//Gets a node for given name
GNode* getNode(int name)
{
	return graph->arr+name;
}
