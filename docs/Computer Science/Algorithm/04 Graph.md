# Chapter 4 Graph

## 4.1 基本概念

- 有限可空的边集 $E$ 和有限非空的点集 $V$ 组成图 $G=\{V, E\}$；
- 无向图/Undirected Graph：边没有方向，也就是 $(u, v) = (v, u)$；
- 有向图/Directed Graph：边有方向，也就是 $(u, v) \neq (v, u)$；
- Tip：数据结构基础中不考虑自环/Self Loop和多重边/Multigraph；
- 完全图/Complete Graph：任意两个点之间都有边；


## 4.2 图的表示

- 邻接矩阵/Adjacency Matrix
    ```C
    #define MaxVertexNum 100
    int G[MaxVertexNum][MaxVertexNum];
    // 1 for connected, 0 for unconnected
    ```

- 邻接表/Adjacency List
    ```C
    typedef struct ArcNode {
        int adjvex;
        int weight;
        struct ArcNode *next;
    } ArcNode;                // 边表结点 
  
    typedef struct VNode {    // 顶点表结点
        VertexData data;
        ArcNode *first;       // 指向第一个邻接点
    } VNode, AdjList[MaxVertexNum];
  
    typedef struct {
        AdjList vertices;     // 邻接表，存储图中所有顶点
        int vexnum, arcnum;
    } ALGraph;
    ```

## 4.3 图的建立

- 邻接矩阵
    ```C
    void BuildGraph(ALGraph *G) {
        int ne, nv;
        scanf("%d %d", &nv, &ne);
        int u, v, w;
        for(int i = 0; i < ne; i++) {
            scanf("%d %d %d", &u, &v, &w);
            G->G[V][W] = G->G[W][V] = w;
        }
    }
    ```
- 邻接表
    ```C
    void BuildGraph(ALGraph *G)
    ```

## 4.4 拓扑排序

- AOV网/Activity On Vertex Network；有向图，其顶点代表活动，边代表活动之间的先后顺序关系
- 如果存在一条从 $v_i$ 到 $v_j$ 的路径，则 $v_i$ 称为 $v_j$ 的前驱/predecessor，$v_j$ 称为 $v_i$ 的后继/successor；
- 如果存在一条边 $(v_i, v_j)$，则 $v_i$ 是 $v_j$ 的直接/Immediate 前驱，$v_j$ 是 $v_i$ 的直接后继；
- 拓扑排序/Topological Order 是一个图的点集的线性序列，满足：
  - 对于任意的点 $v_i$，$v_j$，如果 $v_i$ 是 $v_j$的前驱，在序列中 $v_i$ 出现在 $v_j$ 之前；
  - Tip：拓扑排序不唯一；

```C
void TopologicalSort(Graph G) {
    Queue Q = CreateQueue(NumVertex(G));
    int cnt;
    Vertex V, W;
    for(int i = 0; i < NumVertex(G); i++)
        if(Indegree[i] == 0) Enqueue(i, Q);
    while(!IsEmpty(Q)) {
        V = Dequeue(Q);
        TopNum[V] = ++cnt;
        for(each W adjacent to V)
            if(--Indegree[W] == 0) Enqueue(W, Q);
    }
    if(cnt != NumVertex(G)) Error("Graph has a cycle");
    free(Q);
}
```

### 4.5 最短路径

单源最短路径/Single Source Shortest Path：从一个点到其他所有点的最短路径

- 无向无权图：广度优先搜索/BFS
- 无向正权图：Dijkstra 算法
    ```C
    #define INFINITY INT_MAX
    void Dijkstra(ALGraph G, ins src){
        int dist[MaxN] = {0};
        int visited[MaxN] = {0};
        for (int i = 0; i < G->vexnum; i++)
            dist[i] = INFINITY;
        dist[src] = 0;
        visited[src] = 0;
        for (ArcNode *arc = G->vertices[src].first; arc != NULL; arc = arc->next)
            
    ```
