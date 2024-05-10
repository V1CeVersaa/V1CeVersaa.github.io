# Part 9 Relations

## 9.1 Relations and Their Properties

**Binary Relations**: A **binary relation** $R$ from a set $A$ to a set $B$ is a subset $R\subset A\times B$. We can represent 

Example: Let $A = \{0, 1, 2\}$ and $B = \{a, b\}$, then $\{(0, a), (0, b), (1, a), (2, b)\}$ is a relation from $A$ to $B$.

**Reflexive Relations/自反关系**: A relation $R$ on a set $A$ is **reflexive** if and only if for all $a\in A$, $(a, a)\in R$. Written symbolically, $R$ is reflexive if and only if 

$$\forall x[x\in U \rightarrow (x, x)\in R].$$

**Symmetric Relations/对称关系**: A relation $R$ on a set $A$ is **symmetric** if and only if for all $a, b\in A$, if $(a, b)\in R$, then $(b, a)\in R$. Written symbolically, $R$ is symmetric if and only if

$$\forall x\forall y[(x, y)\in R \rightarrow (y, x)\in R].$$

**Antisymmetric Relations/反对称关系**: A relation $R$ on a set $A$ is **antisymmetric** if and only if for all $a, b\in A$, if $(a, b)\in R$ and $(b, a)\in R$, then $a = b$. Written symbolically, $R$ is antisymmetric if and only if

$$\forall x\forall y[(x, y)\in R \land (y, x)\in R \rightarrow x = y].$$

**Transitive Relations/传递关系**: A relation $R$ on a set $A$ is **transitive** if and only if for all $a, b, c\in A$, if $(a, b)\in R$ and $(b, c)\in R$, then $(a, c)\in R$. Written symbolically, $R$ is transitive if and only if

$$\forall x\forall y\forall z[(x, y)\in R \land (y, z)\in R \rightarrow (x, z)\in R].$$

**Composition**: The **composition** of relations $R$ and $S$ is the relation $T$ such that $(a, c)\in T$ if and only if there exists an element $b$ such that $(a, b)\in R$ and $(b, c)\in S$.

**Powers of a Relation**: Let $R$ be a binary relation on a set $A$. The $n$th power of $R$ is the relation $R^n$ defined recursively as follows:

- Basis Step: $R^1 = R$.
- Inductive Step: $R^{n+1} = R^n \circ R$.

**Theorem 1**: The relation $R$ is transitive if and only if $R^n\subseteq R$.

- If Part: $R^n\subseteq R$, and $R^2\subseteq R$. If $(a, b)\in R$ and $(b, c)\in R$, then $(a, c)\in R^2\subseteq R$. Thus, $R$ is transitive.
- Only If Part: If $R$ is transitive and $(a, c)\in R^2$, then there exists a $b$ such that $(a, b)\in R$ and $(b, c)\in R$, hence $(a, c)\in R^2\subseteq R$. And induction completes the proof.

**Inverse Relation**: The **inverse** of a relation $R$ is the relation $R^{-1}$ such that $(b, a)\in R^{-1}$ if and only if $(a, b)\in R$.

$$R^{-1} = \{(b, a)|(a, b)\in R\}.$$