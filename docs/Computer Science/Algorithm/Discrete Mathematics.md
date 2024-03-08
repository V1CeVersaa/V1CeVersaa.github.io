# Discrete Mathematics

!!! Abstract
    这是我在2023-2024学年春夏学期修读《离散数学理论基础》的课程笔记，由于我实在不想将它安排在数学一类，加之其以`markdown`编写，所以就放在了这里。

    参考书籍：

    - 《Discrete Mathematics and Its Applications》 By Kenneth H. Rosen
    - 《Concrete Mathmatics》 By Ronald L. Graham 

## Part 01 Propositional Logic

### 1.1 Propositions

A **proposition** is a declarative sentence that is either true or false, but not both. We use letters to denote **propositional variables**, or sentential variables, i.e. variables that represent propositions. The **truth value** of a proposition is true, denoted by **T**, if it is a true proposition, and similiarly, the truth value of a proposition is false, denoted by **F**, if it is a false proposition.Propositions that cannot be expressed in terms of simpler propositions are called **atomic propositions**.

We can form new propostions from existing ones using **logical connectives**. Here are six useful logical connectives: Negation/NOT ($\neg$), Conjunction/AND ($\land$), Disjunction/OR ($\lor$), Exclusive Or/XOR ($\oplus$), Conditional/IF-THEN ($\to$), and Biconditional/IFF AND ONLY IF ($\leftrightarrow$).

**More on IMPLICATION**: 

- In $p\to q$, $p$ is the **hypothesis/antecedent前件/premise前提**, and $q$ is the **conclusion/consequent后件**.
- In $p\to q$ there does not need to be any connection between the antecedent or the consequent. The “meaning” of $p\to q$ **depends only on the truth values** of $p$ and $q$.

From $p\to q$, we can form the **converse** $q\to p$, the **inverse** $\neg p\to \neg q$, and the **contrapositive** $\neg q\to \neg p$. The **converse** and the **inverse** are not logically equivalent to the original conditional, but the **contrapositive** is.

Construction of a **truth table**:

- Rows: Need a row for every possible combination of values for the atomic propositions.
- Columns.1: Need a column for the compound proposition (usually at far right)
- Columns.2: Need a column for the truth value of each expression that occurs in the compound proposition as it is built up. (This includes the atomic propositions.)

The truth value of $p\leftrightarrow q$ is the same as the truth value of $(p\to q)\land (q\to p)$, that is to say, $p\leftrightarrow q$ is true if and only if $p$ and $q$ have the same truth value.

**Precedence of Logical Operators**: From highest to lowest, the precedence of logical operators is $\neg$, $\land$, $\lor$, $\to$, and $\leftrightarrow$.

### 1.3 Logical Equivalence

Basic terminology and its concepts:

- **Tautologies/永真式**: A tautology is a proposition which is always true, e.g. $p\lor \neg p$;
- **Contradictions/矛盾式**: A contradiction is a proposition which is always false, e.g. $p\land \neg p$;
- **Contingencies/可能式**: A contingency is a proposition which is neither a tautology nor a contradiction, e.g. $p$.

Two compound propositions $p$ amd $q$ are **logically equivalent** if $q\leftrightarrow q$ is a tautology. We denote this by $p\equiv q$ or $p\Leftrightarrow q$.

Compound propositions that have the same truth values for all possible cases, in other words, the columns in a truth table giving their truth values agree, are called **equivalent**.

**(Important) Conditional-disjunction equivalence** states that for any propositions $p$ and $q$, we have

$$p\to q\equiv \neg p\lor q.$$

**Absorption laws** states that for any propositions $p$ and $q$, we have

$$p\lor (p\land q)\equiv p.$$

$$p\land (p\lor q)\equiv p.$$

**De Morgan's Laws** states that for any propositions $p$ and $q$, we have 

$$\neg(p\land q)\equiv \neg p\lor \neg q$$

$$\neg(p\lor q)\equiv \neg p\land \neg q.$$

**Distribution laws** states that for any propositions $p$, $q$, and $r$, we have

$$p\lor (q\land r)\equiv (p\lor q)\land (p\lor r).$$

$$p\land (q\lor r)\equiv (p\land q)\lor (p\land r).$$

**Identity Laws** states that for any propositions $p$, we have

$$p\land T\equiv p.$$

$$p\lor F\equiv p.$$

**Domination Laws** states that for any propositions $p$, we have

$$p\lor T\equiv T.$$

$$p\land F\equiv F.$$

**Idempotent Laws** states that for any propositions $p$, we have

$$p\lor p\equiv p.$$

$$p\land p\equiv p.$$

Moreover, **Commutative Laws** and **Associative Laws** are also valid for logical connectives: for any propositions $p$, $q$, and $r$, we have

$$p\lor q\equiv q\lor p.$$

$$p\land q\equiv q\land p.$$

$$(p\lor q)\lor r\equiv p\lor (q\lor r).$$

$$(p\land q)\land r\equiv p\land (q\land r).$$

Involving Conditional and Biconditional statements, we have

![Conditional and Biconditional statements](images/image.png)

<!-- $$p\to q\equiv \neg q\lor p.$$

$$p\to q\equiv \neg q\to \neg p.$$

$$(p\to q)\land (p\to r)\equiv p\to (q\land r).$$

$$(p\to q)\lor (p\to r)\equiv p\to (q\lor r).$$

$$(p\to r)\land (q\to r)\equiv (p\lor q)\to r.$$

$$(p\to r)\lor (q\to r)\equiv (p\land q)\to r.$$

$$p\leftrightarrow q\equiv (p\to q)\land (q\to p).$$

$$p\leftrightarrow q\equiv \neg p\leftrightarrow \neg q.$$

$$p\leftrightarrow q\equiv (p\land q)\lor (\neg p\land \neg q).$$

$$\neg(p\leftrightarrow q)\equiv p\leftrightarrow \neg q.$$ -->

The **Dual** of compound proposition that contains only the logic operators $\land$, $\lor$, and $\neg$ the proposition obtained by replacing each $\land$ by $\lor$, each $\lor$ by $\land$, each $T$ by $F$, and each $F$ by $T$. The dual of $S$ is denoted by $S^*$. For example, the dual of $p\lor (q\land \neg r)$ is $\neg p\land (q\lor \neg r)$.

We already know that only two logical operators $\{\neg,\land\}$ or $\{\neg,\lor\}$ are enough to express all logical propositions. Thus, a collection of logical operators is called **functionally complete** if every possible logical proposition is logically equivalent to a compound proposition involving only these operators. 

The **Sheffer Stroke/与非** is a functionally complete set of logical operators. It is denoted by $p|q$, and $p|q$ is false when both $p$ and $q$ are true, and true otherwise. The **Peirce Arrow/或非** is also a functionally complete set of logical operators. It is denoted by $p\downarrow q$, and $p\downarrow q$ is true when both $p$ and $q$ are false, and false otherwise.

A compound proposition is **satisfiable** if there is an assignment of truth values to its variables that makes it true. When no such assignments exits, the compound proposition is **unsatisfiable**.

A compound proposition is unsatisfiable if and only if it is a contradiction or its negation is a tautology.

### 1.4 Applications of Propositional Logic

A list of propositions is **consistent** if it is possible to assign truth values to the proposition variables so that each proposition is true.

### 1.5 Propositional Normal Forms

**Propositional formula/命题公式** is a compound proposition that is built up from atomic propositions using logical connectives with the following criteria:

- Each propositional variable is a formula, and the truth values T and F are formulas.
- If $A$ is a formula, then $\neg A$ is a formula.
- If $A$ and $B$ are formulas, then $(A\land B)$, $(A\lor B)$, $(A\to B)$, and $(A\leftrightarrow B)$ are formulas.
- A string of symbols is a formula if and only if it is determined by (**finitely** maly applications of) the above three rules.

Formulas can be transformed into **standard forms** so that they become more convenient for symbolic manipulations and make identification and comparison of two formulas easier. There are two types of normal forms in propositional calculus:

- the **Disjunctive Normal Form/DNF/析取范式**: A formula is said to be in DNF if it written as a disjuction, in which all terms are conjunctions of literals.   
  For example, $(p\land q)\lor (\neg p\land r)$, $p\lor (q\land r)$, $\neg p\lor T$ are in DNF, and the disjunction $\neg(p\land q)\lor r$ is not.

- the **Conjunctive Normal Form/CNF/合取范式**: A formula is said to be in CNF if it written as a conjunction, in which all terms are disjunctions of literals.

We can introduce the concept of **Clauses/字句** to simplify the concept of DNF and CNF. A disjunction/conjunction with literials as disjuncts/conjuncts are called a **Disjunctive/Conjunctive clause/析取字句/合取字句**. Disjunctive/conjunctive clauses are simply called **clauses**. Moreover, conjunctive clause is also called **Basic product** and disjunctive clause is also called **Basic addition**.

Thus, a CNF is a **conjunction of disjunctive clauses**, and a DNF is a **disjunction of conjunctive clauses**.

A **Midterm/极小项** is a **conjunction** of literials in which each variable is represented **exactly once**.

**(IMPORTANT)** There are $2n$ different minterm for $n$ propositional variables. For example there $4$ different minterm for $p$, $q$, they are $p\land q$, $p\land\neg q$, $\neg p \land q$, $\neg p\land\neg q$. For the sake of simplification, we use $m_j$ denote the minterms. Where $j$ is a integer, **its binary representation corresponds the evaluation of variables that make $m_j$ be equal to T**.

If a proposition form is denoted by: $f=m_j\lor m_k\lor\cdots\lor m^l$, then we simply denote 

$$f=\sum m(j,k,\cdots,l).$$

Properties of minterms:

- Each minterm is true for exactly one assignment.
- The conjunction of two different minterm is always false.
- The disjunction of all minterms is T.
- A disjinction of minterms is true only if at least one of the constituent minterms is ture.

If a function, as $f$, is given by truth table, we know exactly for which assignments it is true. Consequently, we can select the minterms that make the function true and form the disjunction of these minterms.

If a Boolean function is expressed as a disjunction of minterms, it is said to be in **full disjunctive form**.

All above is the concept of DNF and the concept and use of minterms. Now we turn to CNF.

A compound proposition is in CNF if it is a conjunction of disjunctive clauses. **Every proposition can be put in an equivalent CNF**. CNF is useful in the study of resolution theorem proving used in AI.

A compound proposition can be put in conjunctive normal form through repeated application of the logical equivalences covered earlier.

A **Maxterm/极大项** is a **disjunction** of literials in which each variable is represented **exactly once**. If a Boolean function is expressed as a conjunction of maxterms, it is said to be in **full conjunctive form**.

We can get the full conjunctive form of a Boolean function from its full disjunction form: Let $f=\sum f(j,k,\cdots,l)$, $g=\sum m(\{0,1,2,\cdots,2^{n-1}\}-\{j,k,\cdots,l\})$, then $f\lor g = T$, $f\land g = F$.

$$f = \neg g = \prod M(\{0,1,2,\cdots,2^{n-1}\}-\{j,k,\cdots,l\}).$$

The $M_i$ is a maxterm defined by $M_i=\neg m_i$.

### 1.6 Predicates and Quantifiers

