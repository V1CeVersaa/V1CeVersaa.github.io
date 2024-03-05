# Discrete Mathematics

!!! Abstract
    这是我在2023-2024学年春夏学期修读《离散数学理论基础》的课程笔记，由于我实在不想将它安排在数学一类，加之以`markdown`编写，所以就放在了这里。

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

**Precedence of Logical Operators**: From highest to lowest, the precedence of logical operators is $\neg$, $\land$, $\lor$, $\to$, and $\leftrightarrow$.

### 1.3 Logical Equivalence

Compound propositions that have the same truth values for all possible cases are called **logically equivalent**. The compound propositions $p$ and $q$ are called **logically equivalent** if $p\leftrightarrow q$ is a tautology. We denote this by $p\equiv q$.

**De Morgan's Laws** states that for any propositions $p$ and $q$, we have 

$$\neg(p\land q)\equiv \neg p\lor \neg q$$

$$\neg(p\lor q)\equiv \neg p\land \neg q.$$

**Conditional-disjunction equivalence** states that for any propositions $p$ and $q$, we have

$$p\to q\equiv \neg p\lor q.$$

**Distribution laws** states that for any propositions $p$, $q$, and $r$, we have

$$p\lor (q\land r)\equiv (p\lor q)\land (p\lor r).$$

$$p\land (q\lor r)\equiv (p\land q)\lor (p\land r).$$

**Absorption laws** states that for any propositions $p$ and $q$, we have

$$p\lor (p\land q)\equiv p.$$

$$p\land (p\lor q)\equiv p.$$