# Part 10 Graph Theory

## 10.1 Graphs and Graph Models

**Graph**: A graph $G = (V, E)$ consists of a nonempty set of **Vertices/Nodes** $V$ and a set of **Edges** $E$. Each edge has either one or two vertices associated with it, called its **Endpoints**. An edge is said to **connect** its endpoints. If the edges connect only one vertex, it is called a **Loop**.

**Simple Gpaph**: A graph in which each edge connects two different vertices and no two edges connect the same pair of vertices.

**Multigraph**: A graph that may have multiple edges connecting the same vertices.

**Pseudograph**: A graph that may have loops, and possibly multiple edges connecting the same pair of vertices.

**Directed Graph/Digraph**: A graph $(V,E)$ consists of a nonempty set of vertices $V$ and a set of **Directed Edges/Arcs** $E$. Each directed edge is associated with ann ordered pair of vertices. The directed edge associated with the ordered pair $(u,v)$ is said to **start** at $u$ and **end** at $v$.

## 10.2 Graph Terminology and Special Types of Graphs

For an undirected graph $G = (V, E)$: 

- Two vertices, $u$ and $v$ in an undirected graph $G$ are called adjacent (or
neighbors) in $G$, if $\{u, v\}$ is an edge of $G$.
- An edge $e$ connecting $u$ and $v$ is called incident with vertices $u$ and $v$, or is
said to connect $u$ and $v$.
- The vertices $u$ and $v$ are called endpoints of edge $\{u, v\}$.
- The degree of a vertex in an undirected graph is the number of edges incident with it, except that a loop at a vertex contributes twice to the degree of that vertex. The degree of $v$ is denoted by $deg(v)$. If $\deg(v) = 0$, then $v$ is **isolated**. If $\deg(v) = 1$, then $v$ is **pendant**.
- The set of all neighbors of a vertex $v$ of $G$, denoted by $N(v)$, is called the neighborhood of $v$. If $A$ is a subset of $V$, we denote by $N(A)$ the set of all vertices in $G$ that are adjacent to at least one vertex in $A$. So, $N(A) = \cup_{v\in A} N(v)$.

**The Handshaking Theorem**: Let $G = (V, E)$ be an undirected graph with $e$ edges. Then

$$\sum_{v\in V}\deg(v) = 2e.$$

**Theorem 2**: An undirected graph has an even number of vertices of odd degree.

For a directed graph $G = (V, E)$:

- Let $(u, v)$ be an edge in $G$. Then $u$ is an initial vertex and is adjacent to $v$ and $v$ is a terminal vertex and is adjacent from $u$.
- The in degree of a vertex $v$, denoted $\deg^-(v)$ is the number of edges which terminate at $v$.
- Similarly, the out degree of $v$, denoted $deg^+(v)$, is the number of edges which initiate at $v$.

**Theorem 3**: Let $G = (V, E)$ be a directed graph. Then

$$\sum_{v\in V}\deg^-(v) = \sum_{v\in V}\deg^+(v) = |E|.$$

Some special simple graphs:

- **Complete Graph** - $K_n$: A simple graph with $n$ vertices and exactly one edge between each pair of distinct vertices.
- **Cycles** - $C_n$: A simple graph with $n$ vertices and $n$ edges that form a cycle.
- **Wheels** - $W_n$: Add one additional vertex to the cycle $C_n$ and add an edge from each vertex in $C_n$ to the new vertex to produce $W_n$.
- $n$-**Cubes** - $Q_n$: $Q_n$ is the graph with $2^n$ vertices representing bit strings of length $n$. An edge exists between two vertices that differ in exactly one bit position.
- **Bipartite Graph**: A graph $G = (V, E)$ is bipartite if $V$ can be partitioned into two disjoint sets $V_1$ and $V_2$ such that every edge in $E$ connects a vertex in $V_1$ to a vertex in $V_2$. There are no edges which connect vertices in the same set.
- **Complete Bipartite Graph** - $K_{m, n}$: The complete bipartite graph $K_{m, n}$ is the simple graph that has its vertex set partitioned into two disjoint subsets $V_1$ and $V_2$ of size $m$ and $n$ respectively, and every vertex in $V_1$ is adjacent to every vertex in $V_2$.
- **Regular Graph**: A graph in which each vertex has the same degree $n$ is called an $n$-regular graph.

**Theorem 4**: A simple graph is bipartite if and only if it is possible to assign one of two different colors to each vertex of the graph so that no two adjacent vertices have the same color.

**Matching**: A matching $M$ in a simple graph $G = (V, E)$ is a subset of $E$ such that no two edges are incident with the sim

A **Maximum matching** is a matching with the largest number of edges.

We say that a matching $M$ in a bipartite graph $G = (V, E)$ with bipartition $(V_1, V_2)$ is a **complete matching from** $V_1$ to $V_2$ if every vertex in $V_1$ is an endpoint of an edge of the matching.

**Hall's Marriage Theorem**: The bipartite graph $G = (V, E)$ with bipartition $(V_1, V_2)$ has a complete matching from $V_1$ to $V_2$ if and only if $\vert N(A)\vert \geqslant \vert A\vert$ for all subsets $A$ of $V_1$. A vertex that is the endpoint of an edge of a matching $M$ is said to be **matched** by $M$.

**Proof**:

- *If* part:
- *Only if* part:

For $G = (V, E)$ and $H = (W, F)$.

- $H$ is a **subgraph** of $G$ if $W \subseteq V$ and $F \subseteq E$.
- $H$ is a **proper subgraph** of $G$ if $H$ is a subgraph of $G$ and $H \neq G$.
- $H$ is a **spanning subgraph** of $G$ if $W = V$ and $F \subset E$.
- $H$ is a subgraph **induced** by a subset $W$ of $V$ if $F$ contains an edge in $E$ is and only if its endpoints are in $W$.
- The **union** of two graphs $G$ and $H$ is the simple graph $G\cup H$ with the vertex set $V \cup W$ and edge set $E \cup F$.

## 10.3 Representing Graphs and Graph Isomorphism

**Adjacency Matrix**: A simple graph $G = (V, E)$ with $n$ vertices $(v_1,v_2,\cdots, v_n)$ can be represented by its adjacency matrix, A, with respect to this listing of the vertices, where

## 10.4 Connectivity

## 10.5 Euler and Hamilton Paths

## 10.6 Planar Graphs

## 10.7 Graph Coloring 

