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
        int adjvex;           // 顶点下标
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
void TopologicalSort(ALGraph G) {
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

## 4.5 BFS 和 DFS

广度优先搜索/Breadth First Search：从一个点出发，依次访问其邻接点，再访问邻接点的邻接点，以此类推，直到所有点都被访问过；

=== "邻接矩阵"

=== "邻接表"

    时间复杂度：$O(V+E)$（若不使用队列硬遍历则$T=O(V^2)$）

    ```C
    define MAXN 100
    int visited[MAXN];
    int prev[MAXN];
  
    void BFS(ALGraph G, int src, int dst) {
        int queue[MAXN] = {0};
        int front = 0, rear = 0;
        queue[rear++] = src;
        visited[src] = 1;
        while(front < rear) {
            int v = queue[front++];
            for(ArcNode *arc = G->vertices[v].first; arc != NULL; arc = arc->next) {
                int w = arc->adjvex;
                if(!visited[w]) {
                    prev[w] = v;
                    iqueue[rear++] = w;
                    visited[w] = 1;
                    if(w == dst) return;
                }
            }
        }
    }
    ```

深度优先搜索/Depth First Search：从一个点出发，访问其邻接点，再访问邻接点的邻接点，以此类推，直到所有点都被访问过，再回溯到上一个点，继续访问其他邻接点；

=== "邻接矩阵"

=== "邻接表"



## 4.6 最短路径

单源最短路径/Single Source Shortest Path：从一个点到其他所有点的最短路径

- 无向无权图：广度优先搜索/BFS
- 无向/有向正权图：Dijkstra 算法
    ```C
    #define INFINITY INT_MAX
    void Dijkstra(ALGraph G, ins src){          // 确定源点 src 到其他所有点的最短路径长度
        int dist[MaxN] = {0};
        int visited[MaxN] = {0};                // 记录是否已经访问
        for (int i = 0; i < G->vexnum; i++)
            dist[i] = INFINITY;                 // 初始化
        dist[src] = 0;
        visited[src] = 1;
        for (ArcNode *arc = G->vertices[src].first; arc != NULL; arc = arc->next)
            dist[arc->adjvex] = arc->weight;    // 更新原点的邻接点距离
        for (int i = 0; i < G->vexnum; i++) {   // 重复 n-1 次
            int min = INFINITY, v = -1;
            for (int j = 0; j < G->vexnum; j++) {
                if (!visited[j] && dist[j] < min) {
                    min = dist[j];
                    v = j;                      // 找到未访问的最小距离点
                }
            }
            if (v == -1) break;                 // 未找到则剩下所有节点都不可达
            visited[v] = 1;
            for (ArcNode *arc = G->vertices[v].first; arc != NULL; arc = arc->next) {
                if (!visited[arc->adjvex] && dist[v] + arc->weight < dist[arc->adjvex])
                    dist[arc->adjvex] = dist[v] + arc->weight;
            }                                   // 更新其他点的距离
        }
    }
    ```
    这种实现的时间复杂度为 $O(V^2+E)$ 原因之一是内部寻找未访问的最小距离点的步骤是纯粹的线性搜索。

## 4.7 网络流

最大流：给定一个正权有向图$G$，每个边上都有一个流量 $c$，从源点 $s$ 到汇点 $t$ 的最大流量。

求解方法：建立残差图，残差网络的边权如下，每在残差网络中寻找到一条增广路径，就更新一下残差图，知道找不到增广路径为止。

\[
    c_f(u, v) = \begin{cases} c(u, v) - f(u, v) & \text{if } (u, v) \in E \\
     f(v, u) & \text{if } (v, u) \in E \\
      0 & \text{otherwise } \end{cases}
\]

增广路径：从源点到汇点的一条简单路径路径，流量是路径上的最短路径。

```C
int maxFlow(int src, int dst) {
    int maxflow = 0;
    return maxflow;
}
```

## 4.8 最小生成树

最小生成树/Minimum Spanning Tree：给定一个无向连通图$G$，每个边上都有一个权重 $w$，找到一个树，包含这个图的所有节点并且使得所有边的权重之和最小。可以使用贪心算法！

Prim 算法：从一个节点开始，每次选择一个与当前生成树距离最小并且不会产生环的节点加入生成树。

Kruskal 算法：从所有边中选择权重最小的边，如果这条边不会产生环就加入生成树。

=== "Prim"

    和 Dijkstra 算法很像。

    ```C
    void Prim(ALGraph G, int src){
        int dist[MaxN] = {0};

    }
    ```

=== "Kruskal"

