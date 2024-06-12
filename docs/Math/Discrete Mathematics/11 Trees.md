# Part 11 Trees

## 11.1 Introduction to Trees

## 11.2 Application of Trees

## 11.3 Tree Traversal

## 11.4 Spanning Trees

**Spanning Tree**: Let $G$ be a simple graph. A spanning tree of $G$ is a subgraph of $G$ that is **a tree containing every vertex** of $G$.

**Find a Spanning Tree**: By removing edges from simple circuits in $G$.

**Theorem**: A simple graph is connected if and only if it has a spanning tree.

**Proof**:

**Depth-First Search (DFS)**: A procedure that forms a rooted tree, and the underlying graph is a spanning tree.

1. Arbitrarily choose a vertex of the graph as root.
2. Form a path starting at this vertex by successively adding edges, where each new edge is incident with the last vertex in the path and a vertex not already in the path.
3. Continue adding edges to this path as long as possible.
4. If the path goes through all vertices of the graph, the tree consisting of this path is a spanning tree.
5. If the path does not go through all vertices, more edges must be added. Move back to the next to last vertex in the path, if possible, form a new path starting at this vertex passing through vertices that were not already visited. If this cannot be done, move back another vertex in the path. Repeat this process.

**Breadth-First Search (BFS)**: 

1. Arbitrarily choose a vertex of the graph as a root, and add all edges incident to this vertex.
2. The new vertices added at this stage become the vertices at level 1 in the spanning tree. Arbitrarily order them.
3. For each vertex at level 1, visited in order, add each edge incident to this vertex to the tree as long as it does not produce a simple circuit. Arbitrarily order the children of each vertex at level 1. This produces the vertices at level 2 in the tree.
4. Follow the same procedure until all the vertices in the tree have been added.

## 11.5 Minimum Spanning Trees

**Minimum Spanning Tree (MST)**: A **Minimum Spanning Tree** in a connected weighted graph is a spanning tree that has the smallest possible sum of weights of its edges.

**Prim's Algorithm**:

```plaintext
Procedure Prim (G: weighted connected undirected graph with n vertices)
    T:= a minimum-weight edge 
    for i:= 1 to n-2 begin
        e:= an edge of minimum weight incident to a vertex in T and not forming a simple circuit in T if added to T.
        T:= T with e added
    end
endprocedure {T is a minimum spanning tree of G}
```

**Kruskal's Algorithm**:

```plaintext
procedure Kruskal (G: weighted connected undirected graph with n vertices)
    T:= empty graph 
    for i:= 1 to n-1 begin
        e:= any edge in G with smallest weight that does not form a simple circuit when added to T
        T:= T with e added
    end 
endprocedure {T is a minimum spanning tree of G}
```