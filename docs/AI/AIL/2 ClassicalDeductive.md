# 第二部分 经典演绎逻辑

## 1. 命题逻辑

真值联结词可以按照联结词表达的语义分为五种：

- 否定词：
- 合取词：
- 析取词：
- 蕴含词：蕴含词表示一个充分条件假言推理中的“如果...那么...”，通过蕴含词联结的两个命题分别称为前件和后件。对于一个蕴含命题，只有当其前件为真后件为假的时候，其才为假，具有这一性质的蕴含也称为**实质蕴含**。
    - 蕴含怪论：一个假命题可以蕴含任何命题，一个真命题可以被任意命题蕴含，两个命题之间可以毫无关联或者违反自然语言逻辑。
- 等价词：

## 2. 命题语言

命题语言 $\mathcal{L}^p$ 包含一下三类符号：

- 第一类：一个无限序列的命题符号，用于表示原子命题，我们是用小写拉丁文字母 $p$，$q$，$r$（或加其他记号）表示任何命题符号，同时使用 $\top$ 和 $\bot$ 表示永真命题和永假命题。
- 第二类：五个联结符号 $\neg$，$\land$，$\lor$，$\rightarrow$，$\leftrightarrow$，分别表示并非、并且、或者、蕴涵和等值五种联结词。
- 第三类：标点符号：左括号和右括号。

用上述符号可以形成各种符号串，如 $(p \land q)$，$(p \lor ( \neg q \rightarrow r))$，$(p \rightarrow \neg q)$ 等。我们把有限的符号串称为**表达式**。为了使用表达式来表示命题，需要运用一定的语法规则对符号的组合方式进行限制。把由命题符号、联结符号和标点符号按照特定语法规则构成的表达式称作**命题公式**，简称公式。

我们**形式化定义命题公式**如下：命题公式按照下面被递归定义：

- 命题符号是公式，称为原子公式。
- 如果 $\phi$ 和 $\psi$ 是公式，那么 $(\neg \phi)$，$(\phi \land \psi)$，$(\phi \lor \psi)$，$(\phi \rightarrow \psi)$，$(\phi \leftrightarrow \psi)$ 也是公式。
- 只有有限次使用 (1) (2) 条款所组成的符号串是公式。

也可以使用 BNF 形式表达如下：

$$
\phi ::= p \mid (\neg \phi) \mid (\phi \land \psi) \mid (\phi \lor \psi) \mid (\phi \rightarrow \psi) \mid (\phi \leftrightarrow \psi)
$$

这里的联结词也被我们称为**主联结词**。我们也约定，公式的最外层括号可以省略，联结词的结合力强弱分别为 $\neg$，$\land$，$\lor$，$\rightarrow$，$\leftrightarrow$。

## 3. 语义

公式本身用于表示命题，命题有真假，公式本身没有真假，其真假值由如下两方面确定。

- 对于原子公式，其真假值又取决于其代表的原子命题的真假值，可以把原子公式所要表示的原子命题的真假值指派给它。
- 给定原子公式的真假值，其他公式的真值由联结符号的含义来确定。

对于第一个方面，我们可以定义**真假赋值**：真假赋值是以所有命题符号的集为定义域，以真假值 $\{1, 0\}$ 为值域的函数。

我们用斜体小写拉丁文字母 $v$ 表示任何真假赋值。真假赋值 $v$ 给公式 $p$ 指派的值记作 $p^v$。在此之上，对于第二个方面，给定原子公式的真假赋值，其他公式的真值通过联结符号的含义来确定，联结符号与联结词相对应，参照联结词的上述真值表，我们如下定义公式的真值：

真假赋值 $v$ 给公式 $p$ 指派的真值递归地定义如下：

- $p^v \in \{1, 0\}$；
- $(\neg \phi)^v = \begin{cases} 1, & \text{如果} \phi^v = 0 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \land \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 1 \text{且} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \lor \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 1 \text{或} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \rightarrow \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 0 \text{或} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \leftrightarrow \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = \psi^v \\ 0, & \text{否则} \end{cases}$。

我们因此可以验证，公式的真值要么是 1，要么是 0。给定一组公式集合 $\Phi$，对于某一个真假赋值 $v$，使用 $\Phi^v$ 表示对所有 $\phi \in \Phi$，$\phi^v = 1$。

- **重言式**：一个命题公式在任何真假赋值下均为真，比如 $q \rightarrow (p \rightarrow q)$；
- **矛盾式**：一个命题公式在任何真假赋值下均为假，比如 $p \land (\neg p)$；
- **可满足式**：一个命题公式在至少一个真假赋值下为真，比如 $p \lor (\neg p)$。

## 4. 逻辑推论

**逻辑推论**：给定一组公式集合 $\Phi$ 和公式 $\phi$，$\Phi \models \phi$ 当且仅当对于任意真假赋值 $v$，如果 $\Phi^v = 1$，则 $\phi^v = 1$。

这其实是用来形式化推理的，比如：我们希望使用 $p$ 代表鲁迅是革命家，$\neg q$ 代表鲁迅不喜欢封建制度，则 $p \rightarrow \neg q$ 代表如果鲁迅是革命家，则他不喜欢封建制度。我们要证明 $\{p, p \rightarrow \neg q\} \models \neg q$，这其实就是推理：如果鲁迅是革命家，则他不喜欢封建制度；鲁迅是革命家；所以，鲁迅不喜欢封建制度。

设 $\mathrm{KB} = \{\phi_1, \phi_2, \cdots, \phi_n\}$ 是一个由 $n$ 个公式组成的知识库，$\phi$ 是一个公式。当 $\mathrm{KB} \models \phi$ 成立时，如果 $\phi_1, \phi_2, \cdots, \phi_n$ 所表示的命题为真，那么 $\phi$ 所表示的命题也为真，而如果 $\phi_1, \phi_2, \cdots, \phi_n$ 所表示的命题中有些不为真，那么 $\phi$ 的真假赋值不一定为真。

**有效性**：对于 $\Phi \models \phi$，如果 $\Phi$ 是空集，则 $\models \phi$ 当且仅当对于任意真假赋值 $v$，$\phi^v = 1$，即 $\phi$ 是重言式，我们称 $\phi$ 是有效的。

**定理 1**：$\{\phi_1, \phi_2, \cdots, \phi_n\} \models \phi$ 当且仅当 $\models (\phi_1 \land \phi_2 \land \cdots \land \phi_n \rightarrow \phi)$。

**定理 2**：设 $\phi$ 是命题公式。那么 $\phi$ 是可满足的当且仅当 $\neg \phi$ 不是有效的；$\phi$ 是有效的当且仅当 $\neg \phi$ 不是可满足的。

**定理 3**：$\Phi \models \phi$ 当且仅当 $\Phi \cup \{\neg \phi\}$ 是不可满足的，也就是 $\Phi \cup \{\neg \phi\} \models \bot$。

**语义等价性**：设 $\phi$ 和 $\psi$ 是命题公式。我们说 $\phi$ 和 $\psi$ 语义等价，记作 $\phi \equiv \psi$，当且仅当 $\phi \models \psi$ 且 $\psi \models \phi$。

!!! Info "这里其实不应该是 $\equiv$，而是一个双向的 $\models$，但是 KaTeX 太垃圾了，所以用 $\equiv$ 表示"

**定理 4**：常见的语义等价关系：

- $\neg \neg \phi \equiv \phi$
- $\phi \leftrightarrow \psi \equiv (\phi \rightarrow \psi) \land (\psi \rightarrow \phi)$
- $\phi \rightarrow \psi \equiv \neg \phi \lor \psi$
- $\neg (\phi \land \psi) \equiv \neg \phi \lor \neg \psi$
- $\neg (\phi \lor \psi) \equiv \neg \phi \land \neg \psi$
- $\phi \land (\psi \lor \chi) \equiv (\phi \land \psi) \lor (\phi \land \chi)$
- $\phi \lor (\psi \land \chi) \equiv (\phi \lor \psi) \land (\phi \lor \chi)$

**定理 5**：给定 $\phi \equiv \psi$，且 $\phi$ 是 $\varphi$ 的一部分。把 $\varphi$ 中的 $\phi$ 替换成 $\psi$ 得到 $\varphi'$。我们有 $\varphi \equiv \varphi'$。

这是根据公式的递归定义，对于一个公式来说，由它的主联结词联结的各个部分也是公式。通过把这些部分替换为与之语义等价的公式，得到的新公式与原公式语义等价。

**定理 6**：语义等价关系满足自反性、对称性和传递性，即命题公式的语义等价关系是一种等价关系。

## 5， 范式

