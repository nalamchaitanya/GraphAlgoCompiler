/**
	Graph
**/

#include <stdio.h>
#include <stdlib.h>

#ifndef GRAPH_H
#define GRAPH_H

#define LVAL 999999999

typedef struct _GNode GNode;

typedef struct _GNode
{
	int name;
	GNode **neighbours;
	int* weights;
	int length;
	int check;
	int dist;
	int dfsnum;
	int avail;
}GNode;

typedef struct _Graph
{
	GNode *arr;
	int nodes;
	int edges;
} Graph;

//Creates a new Graph
Graph* createGraph(char* file);

//Gets a node for given name
GNode* getNode(int name);

//Add a new Node to graph
void addEdge(GNode* node1,GNode* node2,Graph* graph,int wt);

//Create a node.
GNode* createNode(int name,int n,int m,Graph *graph);

//Prints the graph.
void printGraph(Graph *graph);

// gives weight between two nodes having edge.
int weight(GNode *src,int dst);

// gives no of nodes in graph.
int nodeCount(int c);

// gives no of edges in graph.
int edgeCount(int c);

#endif
