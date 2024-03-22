# Basic Structures: Sets, Functions, Sequences, Sums, and Matrices

## 2.1 Sets

A **set** is an unordered collection of distinct objects, called **elements** or members of the set. A set is said to contain its elements. We write $a\in A$ to denote that $a$ is an element of the set $A$. The notation $a\notin A$ denotes that $a$ is not an element of the set $A$.

**Roster method**: A set can be described by listing its elements between braces. For example, the set of vowels in the English alphabet can be written as $V=\{a,e,i,o,u\}$. Listing an element more than once does not change the set. The set $\{a,e,i,o,u\}$ is the same as the set $\{a,e,i,o,u,u\}$.

**Set-builder notation**: A set can be described by specifying a property that its members must satisfy, for example $\{x:x\equiv 0(\mod 2)\}$

**Universal Set**: The set $U$ containing all the objects currently under consideration.

**Empty Set**: The set containing no elements, denoted by $\emptyset$ or $\{\}$.

**Set Equality**: Two sets are equal if and only if they have the same elements. i.e. 

$$\forall x(x\in A\leftrightarrow x\in B)$$

**Subset**: A set $A$ is a subset of a set $B$ if every element of $A$ is also an element of $B$. We write $A\subseteq B$.

$$forall x(x\in A\rightarrow x\in B)$$

**Proper Subset**: If $A\subseteq B$ and $A\neq B$, then $A$ is a proper subset of $B$, denoted by $A\subset B$.

**Set Cardinality**: If there are exactly $n$ distinct elements in a set $A$, where $n$ is a nonnegative integer, then $A$ is a finite set otherwise it is an infinite set. The cardinality of a finite set $A$, denoted by $|A|$, is the number of elements in $A$.

**Power Sets**: The set of all subsets of $A$, denoted by $\mathcal{P}(A)$ is called the power set of $A$. If $|A|=n$, then $|\mathcal{P}(A)|=2^n$.

**Tuples**: The **ordered** $n$-tuple $(a_1,a_2,\cdots,a_n)$ is the ordered collection that has $a_1$ as its first element, $a_2$ as its second element, and so on. Two $n$-tuples are equal if and only if their **corresponding** elements are equal. $2$-tuple is called an **ordered pair/序偶**.

**Cartesian Product**: The **Cartesian product** of sets $A$ and $B$, denoted by $A\times B$, is the set of all ordered pairs $(a,b)$ where $a\in A$ and $b\in B$. Similarly, the Cartesian product of $n$ sets $A_1,A_2,\cdots,A_n$ is the set of all ordered $n$-tuples $(a_1,a_2,\cdots,a_n)$ where $a_i\in A_i$ for $i=1,2,\cdots,n$.

$$A\times B=\{(a,b):a\in A\land b\in B\}$$

**Relation**: A subset $R$ of the Cartesian product $A\times B$ is called a **relation** from $A$ to $B$.

**Truth Set**: Given a predicate $P$ and a domain $D$, the truth set of $P$ is the set of all elements in $D$ for which $P$ is true.

$$\{x\in D:P(x)\}$$

## 2.1 Set Operations

**Union**: The union of sets $A$ and $B$, denoted by $A\cup B$, is the set containing all elements that are in $A$ or in $B$ or in both.

$$A\cup B=\{x:x\in A\lor x\in B\}$$

**Intersection**: The intersection of sets $A$ and $B$, denoted by $A\cap B$, is the set containing all elements that are in both $A$ and $B$.

$$A\cap B=\{x:x\in A\land x\in B\}$$

**Difference**: The difference of sets $A$ and $B$, denoted by $A-B$, is the set containing all elements that are in $A$ but not in $B$.

$$A-B=\{x:x\in A\land x\notin B\}$$

**Symmetric Difference**: The symmetric difference of sets $A$ and $B$, denoted by $A\oplus B$, is the set containing all elements that are in $A$ or in $B$ but not in both. Remember the **XOR**/$\oplus$ operation.

$$A\oplus B=\{x:x\in A\oplus x\in B\}=(A-B)\cup(B-A)$$

**Complement**: The complement of a set $A$ with respect to the universal set $U$, denoted by $\overline{A}$ or $A^c$, is the set $U-A$.

$$\overline{A}=\{x:x\in U\land x\notin A\}$$

**Includsion-Exclusion Principle**: For any two sets $A$ and $B$,

$$|A\cup B|=|A|+|B|-|A\cap B|$$
