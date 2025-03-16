#import "templates/notes-template.typ": notes

#show: doc => notes(
  [6. Propositional logic: a very simple logic], 
  doc
)

#set text(size: 11pt)

== First-order logic

- Weakly fitted for uncertain knowledge
- Hard to describe any type of heuristics
- Due to amount of sentences, it is hard to describe complex problems

*Relations between knowledge*

#table(
  columns: (0.65fr, 0.35fr),
  [*Ontology*], [*Epistemology*],

  [Related to the real nature, assumptions about the real world],
  [Related to probable knowledge and states via representation languages],

  [
    - Propositional logic assumes that there are facts.
    - Predicate logic assumes that the world is made of *objects* that have _true_ or _false_ relations.
    - Special(temporal) logic assumes that the world is ordered by time moments or intervals.
  ],
  [
    Full confidence that sentence is either _true_ or _false_
  ],

  [
    - Probability theory with stochastic environments.
    - Theory of confidence?[_Haven't found any reference to the correct term_] - facts exists with the probability that the expert have entailed.
    - Fuzzy logic - facts exists with some order of truthfulness
  ],
  [
    Order of confidence in interval $[0; 1]$
  ]
)

== Propositional logic syntax

Syntax is made of *alphabet*(defines symbols) + *grammar*(defines how to construct sentences correctly).

1. *Proposition symbols*: big latin alphabet letters, most often starting from $P$: $P, Q, R, ...$, but any other letter can be used as well, e.g.

 #par(first-line-indent: 1em)[
  $P_(1,3)$ - pit is in the square $(1, 3)$
 ]

2. *Boolean symbols*: _T_ for true and _F_ for false.

3. *Logical connectives*:

  - negation(NOT): $not$, e.g. 

    $not P_(1,3)$ - pit is not in the square $(1, 3)$ 

  - conjunction(AND): $and, amp$

  - disjunction(OR): $or$

  - implication(IF...,THEN...): $arrow.double$, $arrow$ (implies)

  - equivalence(IF ..., AND ONLY IF ...): $equiv$, $arrow.l.r.double$

4. *Aid symbols*: different types of parentheses $[()]$

Every proposition/boolean symbol is an *atomic* sentence, e.g.
#par(first-line-indent: 1em)[
  $P_(1,3)$ - pit is in the square $(1, 3)$ - is *atomic*
]

*Complex sentences* are constructed from simpler sentences(atomics), using parentheses and *logical connectives*, e.g.

#par(first-line-indent: 1em)[
  $P_(1,3) or not P_(1,3)$ - pit is or is not in the square $(1, 3)$ - is a *complex sentence*
]

*Example of logic sentence notation*:

_*Cyclone*($P$) consequences are *strong wind*($Q$) and *big waves*($R$), but *anticyclone*($S$) consequences are *no wind*($T$) at all_.

We can separate certain parts of the sentence into atomic sentences described by one letter in parenthesis and get:

$
  (P arrow (Q and R)) and (S arrow T)
$

We can decrease number of parenthesis with *logical connectives relation power*:

1. The biggest relation is for *negation*, exactly by the symbol. 
  - $not P and Q$ - not $P$, then and $Q$
  - $not (P and Q)$ - first $P and Q$, then $not$

2. *Conjunction and disjunction*:
  - $P or Q or R$ - is incorrect, order of operations is not defined, need to specify either
  - $(P or Q) or R$ or $P or (Q or R)$

3. *Implication* works on the whole expression on the right or left side:
  - $P arrow Q and R$ - is ok, as well as $Q and R arrow P$ - implication works after *AND* operation.

4. *Equivalence* waits until both sides are resolved:
  - $P and Q arrow R equiv S$ - waits until $P and Q arrow R$ and $S$ are resolved. 

== Semantics

Atomic sentences are easy:

- _True_ is true in every model and _False_ is false in every model.
- The truth value of every proposition symbol must be specified directly in the model. For example, in the model $m$, $P$ must be false or true.

For complex sentences, we have five rules, which hold for any subsentences $P$ and $Q$ in any model $m$ (here “iff” means “if and only if”):

- $not P$ is true iff $P$ is false in $m$
- $P and Q$ is true iff both $P$ and $Q$ are true in $m$
- $P or Q$ is true iff either $P$ or $Q$ is true in $m$
- $P arrow Q$ is true unless $P$ is true and $Q$ is false in $m$
- $P equiv Q$ is true iff $P$ and $Q$ are both true or both false in $m$

The rules can also be expressed with *truth tables*. True is represented by 1 and False by 0:

#figure(
  table(
    columns: 7,
    [$P$], [$Q$], [$not P$], [$P and Q$], [$P or Q$], [$P arrow Q$], [$P equiv Q$],

    [0], [0], [1], [0], [0], [1], [1],

    [0], [1], [1], [0], [1], [1], [0],

    [1], [0], [0], [0], [1], [0], [0],

    [1], [1], [0], [1], [1], [1], [1],
  ),
  caption: [Truth table for the five logical connectives]
)

*Equivalences*:

- $not not P equiv P$
- $not P arrow Q equiv P or Q$
- $P arrow Q equiv not P or Q$ - resolution law
- $P arrow Q equiv not Q arrow not P$
  - We can prove that the equivalence is correct by using *truth tables*:
#grid(
  columns: 2,
  column-gutter: 3em,
  table(
    columns: 3,
    [$P$], [$Q$], [$P arrow Q$],

    [0], [0], [1], 

    [0], [1], [1], 

    [1], [0], [0], 

    [1], [1], [1], 
  ),
  table(
    columns: 3,
    [$not P$], [$not Q$], [$not Q arrow not P$],

    [1], [1], [1], 

    [1], [0], [1], 

    [0], [1], [0], 

    [0], [0], [1], 
  ),
)

- De Morgan's law:
  - $not (P or Q) equiv not P and not Q$
  - $not (P and Q) equiv not P or not Q$

- Commutative property:
  - $P and Q equiv Q and P$
  - $P or Q equiv Q or P$

- Associative property:
  - $(P and Q) and R equiv P and (Q and R)$ 

- Distributive property:
  - $P or (Q and R) equiv (P or Q) and (P or R)$
  - $P and (Q or R) equiv (P and Q) or (P and R)$

== Inference procedure

If sentence $alpha$ is true in model $m$, we say that $m$ *satisfies* $alpha$ or $m$ *is a model of* $alpha$. 

Notation: $M(alpha)$ - set of all models of $alpha$.

*Logical entailment* between sentences - the idea that a sentence _follows logically_ from another sentence:

$
  alpha tack.r.double beta
$

where $alpha$ and $beta$ are sentences.

*Entailment* means that in every model in which $alpha$ is true, $beta$ is also true.

$
  alpha tack.r.double beta "if and only if" M(alpha) subset.eq M(beta)
$

where $M(alpha)$ is a subset of $M(beta)$.

If $alpha tack.r.double beta$, then $alpha$ is _stronger_ assertion than $beta$: it rules out more possible worlds. E.g. the sentence $x = 0$ entails the sentence $x y = 0$. In any model where $x$ is zero, it is the case the $x y$ is zero too.

Inference must be *sound* and it is preferable for it to be *complete*.

Meta-form of the entailment:

$
alpha / beta equiv alpha tack.r.double beta
$

where $alpha$ is a *premise* - a proposition — a true or false declarative statement, used in an argument to prove the truth of another proposition called the conclusion, $beta$ is the *conclusion*.

=== MODUS PONENS

$
(alpha arrow beta, alpha) / beta equiv alpha arrow beta, alpha tack.r.double beta
$

where $alpha$ and $alpha arrow beta$ are premises, and $beta$ is a conclusion.

- In the KB $alpha arrow beta$ represents sentences IF...THEN...
- $alpha$ is the parameter that comes from sensors and goes into working memory
- After working memory is loaded a sentence is being searched, so that $alpha equiv T$ and $alpha arrow beta equiv T$

_MODUS PONENS_ can be proved to be *sound* by using *truth table*. Whenever premises $alpha$ and $alpha arrow beta$ are _True_, and the sentence $beta$ is also _True_ in every case, then it can be inferred and procedure is *sound*.

#figure(
  table(
    columns: 3,
    [$alpha$], [$beta$], [$alpha arrow beta$], 

    [0], [0], [1], 

    [0], [1], [1], 

    [1], [0], [0], 

    [*1*], [*1*], [*1*], 
  ),
  caption: [Truth table for the MODUS PONENS]
)

Since premises $alpha equiv T$ and $alpha arrow beta equiv T$ holds _True_, and conclusion $beta equiv T$, then it concludes that the law is *sound*. 

_Example_: 

- $alpha arrow beta$: $("WumpusAhead" and "WumpusAlive" arrow "Shoot")$
- $alpha$: $("WumpusAhead" and "WumpusAlive")$
- Therefore with MODUS PONENS we can infer that $beta equiv "Shoot"$

*AND-elimination*

- Allows to infer separate conjuncts, that are guaranteed to be _True_:

$
  (alpha_1 and alpha_2 and ... and alpha_n) /
  (alpha_1, alpha_2, ..., alpha_n)
$

_Example_:

- $alpha_1 and alpha_2$: $("WumpusAhead" and "WumpusAlive")$
- We can infer that $alpha_1 equiv "WumpusAhead"$ and $alpha_2 equiv "WumpusAlive"$


*AND-inclusion*

$
  (alpha_1, alpha_2, ..., alpha_n) /
  (alpha_1 and alpha_2 and ... and alpha_n)
$

*OR-inclusion*

$
  alpha /
  (alpha or beta or gamma or ...)
$

*Double negation*

$
  (not not alpha) / alpha
$

=== Unit resolution

$
  (alpha or beta, not beta) / alpha
$

- can also be called as a *proof by contradiction*

_Example_:

- If there's a pit($P$) in one of $(1,1), (2,2), (3,1)$ and it's not in $(2,2)$, then it's in $(1,1)$ or $(3,1)$.
- Symbolically: 
$
  (P_(1,1) or P_(2, 2) or P_(3,1), not P_(2,2)) / 
  (P_(1,1) or P_(3,1))
$

=== Full resolution

- Comes from the unit resolution as

$
  (alpha or beta, not beta or gamma) / (alpha or gamma) equiv 
  (not alpha arrow beta, beta arrow gamma) / (not alpha arrow gamma)
$

_Example_:

$
  (P_(1,1) or P_(3,1), not P_(1,1) or not P_(2,2)) / 
  (P_(3,1) or not P_(2,2))
$

#figure(
  table(
    columns: 6,
    [$alpha$], [$beta$], [$gamma$], [$alpha or beta$], [$not beta or gamma$], [$alpha or gamma$],

    [0], [0], [0], [0], [1], [0], 

    [0], [0], [1], [0], [1], [1], 

    [0], [1], [0], [1], [0], [0], 

    [0], [1], [1], [*1*], [*1*], [*1*], 

    [1], [0], [0], [*1*], [*1*], [*1*], 

    [1], [0], [1], [*1*], [*1*], [*1*], 

    [1], [1], [0], [1], [0], [1], 

    [1], [1], [1], [*1*], [*1*], [*1*], 
  ),
  caption: [Full resolution soundness proof]
) <res-proof>

In @res-proof there are 4 cases where premises $alpha or beta$ and $not beta or gamma$ are true. Since all conclusions $alpha or gamma$ are also true in all those 4 cases, we can conclude that *full resolution* is *sound*.


=== MODUS TOLLENS

$
  (alpha arrow beta, not beta) / (not alpha)
$

- E.g. there is a breeze in the square($alpha$ sentence), then the pit is in the nearest squares($beta$).
- *MT*: The pit is not in the nearest squares($not alpha$), then the breeze was not perceived($not alpha$).

=== Abduction rule

$
  (alpha arrow beta, beta) / alpha
$

As seen in @abduction-rule, the rule is not *sound*, since the second row does not produce a truthful conclusion $alpha$.

#figure(
  table(
    columns: 3,
    [$alpha$], [$beta$], [$alpha arrow beta$], 

    [0], [0], [1], 

    [*0*], [*1*], [*1*], 

    [1], [0], [0], 

    [*1*], [*1*], [*1*], 
  ),
  caption: [Truth table for the abduction rule]
) <abduction-rule>

=== Equivalence rule

$
  (alpha equiv beta) / ((alpha arrow beta) and (beta arrow alpha))
$

$
  ((alpha arrow beta), (beta arrow alpha)) / (alpha equiv beta)  
$

== Conjunctive normal form

Every sentence of propositional logic is logically equivalent to a conjunction of clauses. 

A sentence expressed as a conjunction of clauses is said to be in *conjunctive normal form* or *CNF*.

E.g. convert $S_(1,1) equiv W_(1,2) or W_(2,1)$ into *CNF*:

$
  S_(1,1) equiv W_(1,2) or W_(2,1) \
  (S_(1,1) arrow W_(1,2) or W_(2,1)) and (W_(1,2) or W_(2,1) arrow S_(1,1)) \
  (not S_(1,1) or W_(1,2) or W_(2,1)) and (not (W_(1,2) or W_(2,1)) or S_(1,1)) \
  (not S_(1,1) or W_(1,2) or W_(2,1)) and ((not W_(1,2) and not W_(2,1)) or S_(1,1)) \
  (not S_(1,1) or W_(1,2) or W_(2,1)) and ((not W_(1,2) or S_(1,1)) and (not W_(2,1) or S_(1,1)))
$

The last line represents *CNF*.

== Propositional logic weaknesses

- Requires to process large amounts of sentences
- No way to create a generic sentence with variables
- It doesn't allow to efficiently deal with perceptions, with no ability to apply time constraint. E.g.  bumping into the wall - cannot limit the agent to do a different action on next time iteration
- Can use only sentences that produce _True_ or _False_

== Predicate logic

- Uses idea that the world is made of objects with relations between them. Relations are either _True_ or _False_.
- Has 2 parts:
  1. predicates that define relations
  2. arguments to the predicates, also known as *terms*. Argument types:
    - objects, e.g. *John*
    - relations, e.g. *is a part of*
    - properties, e.g. *is red*
    - functions, e.g. *father(John)*

Predicate logic uses:

- Symbols for defining *constants*($P, A, B, ...$)
- Variables ($x, y, ...$) for defining constant types
- Functions($f(x, y, ...) arrow z$) that maps every variable onto function value set. $f$ is called the function constant, $x, y, ...$ are the function's term.
- Predicates make statements about objects that are _True_ or _False_($p(x, y, ...) arrow {T, F}$), where $p$ is the predicate constant, but $x, y, ...$ are the arguments.

With *term* we describe variables, functions and constants.

*Complex sentences* are mode of atomic sentences:

$S$ is an atomic sentence, as well as

#grid(
  columns: 2,
  column-gutter: 2em,
  [
    - $not S$
    - $S and P$
    - $S or P$
  ],
  [
    - $S arrow P$
    - $S equiv P$
  ]
)

E.g. complex sentence from atomic ones: $"like"(x, y) and "like"(z, y) arrow not "like"(x, z)$

=== Quantifiers

$forall$ - universal quantifier("for all")

$exists$ - existential quantifier("there exists at least one")

$exists!$ - there exists only one entity

$forall x$ - quantifier complex

$forall x space p(x)$ - predicate works for all $x$, e.g. $forall x "like"(x, "Mary")$ - everyone likes Mary.

Quantifier domain limits all the variables, e.g.

$forall x ((p(x) and q(y)) or r(x, y))$, where $y$ is a free term.

*Examples*:

$forall x ("cat"(x) arrow "animal"(x))$ - every cat is the animal

$forall x ("footballer"(x) arrow "fast"(x))$ - every footballer is fast

*Equivalences*:

$forall x space p(x) equiv p(x_1) and p(x_2) and ... and p(x_n)$

$exists x space p(x) equiv p(x_1) or p(x_2) or ... or p(x_n)$

- Quantifier mutual expressibility 

$
  not exists x space p(x) equiv forall x space not p(x) \
  not forall x space p(x) equiv exists x space not p(x)
$

- Free exchange of variables

$
  exists x space p(x) equiv exists y space p(y) \
  forall x space p(x) equiv forall y space p(y)
$

- Quantifiers carry-out from parentheses

$
  forall (p(x) and q(x)) equiv forall x space p(x) and forall x space q(x) \
  exists (p(x) and q(x)) equiv exists x space p(x) or exists x space q(x)
$

=== Semantics

- *Sentences* are the same as *statements*

- *Interpretation domain* $D$ - prescribes an object from the $D$ domain to each constant:

$
  D = {"John", "Paul", "Ringo", "George"} \
  "John" = "const"
$

- Each *variable* has a non-empty subset of $D$ domain:

$
  x - "guitarist" {"John", "Paul", "George"} subset.eq D
$

- Each *function* with the volume $N$ is defined with $N$ objects(arguments) from $D$ domain and the function defines a mapping:

$
  f : D^N arrow D
$

- Each *predicate* with the volume $M$ defines $M$ arguments from $D$ domain and defines the mapping:

$
  p : D^M arrow {T, F}
$

where $T$ - _True_, $F$ - _False_

=== Inference

Inference must be *sound*, i.e. sentences must be truthful in every interpretation, e.g. 
$
  forall x (p(x) or not p(x))
$ 
is truthful.

=== Substitution

In every truthful sentence it is possible to substitute a term, and in the result gather a truthful sentence:

$
  forall x space p(x) : p(K)
$

where $x$ is variable, $K$ - constant, and $p(K)$ is truthful.

*Example*:

$
  "TELL"("KB", forall x ("student"(x) arrow "human"(x))) \
  "TELL"("KB", "student"("John"))
$

With substitution and _MODUS PONENS_ we can infer that John is human:

$
  (("student"(x) arrow "human"(x)), "student"("John")) / "human"("John")
$

*Skolem normal form*

It is easy to substitute $forall$, for $exists$ we should use *Skolem normal form*.

The simplest Skolem form is when $exists$ stands alone. It is replaced with the constant($c$):

$
  exists x space p(x) equiv p(c)
$

With universal quantifier we should apply a function $y = f(x)$ that maps every $x$ onto $y$. E.g. every child has a father, later can be expressed as a function that defines a relation between father and each child:

\

*Example 1*:
$
  forall x exists y "father"(x, y) \
  forall x "father"(x, f(x))
$

*Example 2*:

Every human has brains:

$
  forall x ("human"(x) arrow exists y "brains"(y) and "belongs"(x, y)) \
  forall x ("human"(x) arrow "brains"(f(x)) and "belongs"(x, f(x))) \
$

=== Predicates for Wumpus World

- Predicate that defines if one square coordinates are close to the other square:

$
  forall x, y, a, b space "close"((x, y), (a, b)) equiv \ 
  (a, b) in {(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)}
$

- Predicate that defines that there is only one Wumpus existing on the map:

$
  exists! "wumpus"(x) \
  exists "wumpus"(x) and forall y "wumpus"(y) arrow (x = y) \ - "if" exists! "is not allowed"
$

- *Diagnostic laws* describe how observed facts are related to the consequences:

  If breeze is detected, then pit is in the closest squares:

  $
    forall x ("breeze"(x) arrow exists r ("close"(r, x) and "pit"(r)))
  $
  where $x$, $r$ are square coordinate tuples.

  If breeze is not detected:

  $
    forall s (not "breeze"(s) arrow forall r ("close"(r, s) and not "pit"(r))) equiv \
    forall s (not "breeze"(s) arrow not exists r ("close"(r, s) and "pit"(r)))
  $
  where $s$, $r$ are square coordinate tuples.

- *Reason-consequence* laws:

  If square $r$ is a pit, then the closest squares $s$ has a breeze:
  $
    forall r ("pit"(r) arrow (forall s "close"(r, s) arrow "breeze"(s)))
  $

- The changes in the world can be described with *result* function:

  $
    forall x, s ("is"(x, s) and "movable"(x) arrow "hold"(x, "result"("grab"(x, s))))
  $
  where $x$ is a movable item, $s$ is the square from which the item was grabbed

- Example of *the axiom of the effect of the action*:

  $
    forall x, s (not "hold"(x, "result"("release"(x, s))))
  $
  where $x$ is a movable item, $s$ is the starting square where it is allowed to release

- Example of *frame axioms*:

  $
    forall a, x, s (not "hold"(x, s) and (a eq.not "grab"(x)) \ arrow not "hold"(x, "result"(a, s))
  $
  where $a$ is the action, $x$ is a movable item, $s$ is the starting square where it is allowed to release.
  This predicate describes what happens when _hold_ action is not active, i.e. if we do not grab then we do not hold anything.

  $
    forall a, x, s ("hold"(x, s) and (a eq.not "release"(x)) \ arrow "hold"(x, "result"(a, s))
  $
  This predicate describes that if we do not release, then we certainly should be holding some item.

  If we want to describe that some action will be true in later times we can describe it with the following pseudocode:

  True later $equiv$ truthful action that changes state $or$ (predicate that already holds the truth $and$ action that does not make an action false)
  
  E.g.
  $
    forall a, x, s ("hold"(x, "result"(a, s)) equiv \
    equiv ((a eq "grab"(x) and "is"(x, s) and "movable"(x)) or \
    or ("hold"(x, s) and (a eq.not "release"(x))))
  $

  where predicate describes that the result of holding an item is that item $x$ is movable, it is in the square $s$ and we have grabbed it. Or we already hold this item and we did not release it yet.

== Knowledge building for logical agents

Knowledge Base is created by business specialist and knowledge engineer.

The biggest bottleneck is the knowledge acquisition(elicitation).

An example of this problem: *The bear has very small brains(Winny Puhh), therefore it is stupid*. System cannot inference this sentence unless there is a KB that can sequence to this conclusion.

*Let's create KB:*

1. Puhh is a bear:

  $"bear"(P)$

2. All bears are animals:

  $forall b space ("bear"(b) arrow "animal"(b))$

3. All animals are physical objects:

  $forall a space ("animal"(a) arrow "object"(a))$

4. All animals have brains:

  $forall a space ("animal"(a) arrow "brains"(a))$

5. Brains are the part of the animal:

  $forall a space ("belongs"("brains"(a), a))$

6. If one physical object belongs to other, then it is also an object:

  $forall x, y space ("belongs"(x, y) and "object"(y) arrow "object"(x))$

7. Every object has a size K:

  $forall x space ("object"(x) arrow exists K space ("size"(x) eq K))$

8. A relative size of different objects:

  $forall v, w ("relative size"(v, w) arrow "size"(v) / "size"(w))$

9. Puhh's brains relative size:

  $"relative size"("brains"(P), "brains"(B)) eq "very small"$ 
  
  where $B$ is a typical bear

From this KB we can now infer that Puhh has very small brains, he is a bear, an animal and he has brains.