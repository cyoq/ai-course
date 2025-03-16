#import "templates/notes-template.typ": notes

#show: doc => notes(
  [7. Uncertain knowledge], 
  doc
)

#set text(size: 11pt)

== Acting under uncertainty

Using propositional logic does not always work as intended. Consider the example:

$
  forall p space "symptoms"(p, "toothache") arrow "disease"(p, "cavity")
$

However, it is not always the case that toothache is received from a cavity, let's describe other problems as well:

$
  forall p space "symptoms"(p, "toothache") arrow "disease"(p, "cavity") \
  or "disease"(p, "gum problems") or ...
$

There are several problems:

1. There can be lots of different problems, and we might miss some condition.
2. We cannot use disjunction for inference. We need conjugate form.
3. We are lazy to describe everything.

Therefore we use *decision theory* to describe rational decisions for the agent:

_Decision theory = probability theory + utility theory_

With this theory, the agent is rational when it chooses the action that gives the best result which is the arithmetic average of all available actions.

== Probability theory

- Described by *random variables*, e.g. $X$
- Discrete random variable: $P("Weather") = (0.7; 0.3)$ or $P("Weather" = "sunny") = 0.7$ and $P("Weather" = "rainy") = 0.3$. These types always have a *domain* - the set of possible values, in this case $"Weather" in {"sunny", "rainy"}$ or $"Dice" in {1...6}$
- Boolean random variable: $P("cavity")$ or $P(not "cavity")$. It has a domain of ${"true", "false"}$
- Continuous random variables cannot be defined with the vector of values. Instead it uses a *probability density function*: 
$
  P("Temp" = x) = "Uniform"_([18, 26])(x) \
  = cases( 1/8 "if" 18 <= x <= 26 \
         0 "otherwise" )
$
It means that in 100% the temperature is in the interval of 18 - 26 Celsius. 

=== Syntax:

- $P(A)$ is a *prior* or *unconditional probability*
- $P(A|B)$ is a *conditional* or *posterior* probability where $A$ is given by $B$(evidence). In the agent world B might be a measurement from the sensor.
- *Conditional probability* product rule:

$
  P(A|B) = P(A and B) / P(B), "if" P(B) > 0 \
  P(A and B) = P(A|B) dot P(B) \
  P(A and B) = P(B|A) dot P(A)
$

=== Axioms

- *Probability model*: 
$0 <= P(omega) <= 1$ for every $omega$ and $sum_(omega in Omega) P(omega) = 1$, 
where $omega$ is some world, but $Omega$ is a set of all possible worlds called the *sample space*.
- $P("true") = 1, P("false") = 0$
- *Kolmogorov's axiom*: $P(A or B) = P(A) + P(B) - P(A and B)$, we can derive $P(A and not A) = P(A) + P(not A) = 1$

=== A full joint distribution example

#table(
  columns: 4,
  [], [Toothache], [$not$ Toothache], [$sum$],

  [Cavity], [0.04], [0.06], [0.1],

  [$not$ Cavity], [0.01], [0.89], [0.9],

  [$sum$], [0.05], [0.95], [],
)

- $P("Cavity") = P("Toothache") + P(not "Toothache") = 0.1$

It is also called a *marginal probability*. General form:

$
  P(Y) = sum_(z in Z) P(Y, z)
$

In the example;

$
  P("Cavity") = sum_(z in {"Toothache"}) P("Cavity", z)
$

- $
  P("Cavity" or "Toothache") = \
  = P("Cavity") + P("Toothache") - \
  - P("Cavity" and "Toothache") = \
  = 0.1 + 0.05 - 0.04 = 0.11
$

- $
P("Cavity" | "Toothache") = \
= P("Cavity" and "Toothache") / P("Toothache") = \
= 0.04 / 0.05 = 4 / 5 = 0.8
$

\

== Bayes' rule and its use

Previously we defined a *product rule*, from which Bayes' rule is derived:

$
  P(A and B) = P(A|B) dot P(B) \
  P(A and B) = P(B|A) dot P(A) \
  P(A|B) dot P(B) = P(B|A) dot P(A) \
  P(B|A) = (P(A|B) dot P(B)) / P(A)
$

- It is used for diagnostic laws
- It is also used for probabilistic inference mechanisms

Bayes' rule is used for *uncertain knowledge representation* - _Bayes' network_:

=== Bayes' network

- It is a directed acyclic graph(DAG)
- The node is a random variable 
- The node has a distribution table
- Edge $X$ to $Y$ represents that $X$ influences $Y$

An example:

- An alarm system in the house
- It can be activated if earthquake happens
- It is activated if burglary happens
- John or Mary can call if they supposedly heard the alarm

The graph can be represented as in the image @network. The graph represents a knowledge base.

#figure(
  image("tikz/bayes-network/bayes-network.png", width: 80%),
  caption: [Bayes' network example],
) <network>

Now we can use it for querying probabilities:

$
  P(X_i | "parents"(X_i))
$

The value of the entry can be calculated as this:

$
  P(X_1 = x_1 and ... and X_n = x_n) = P(x_1, ..., x_n) = \
  Pi_(i = 1)^n P(x_i | "parents"(x_i))
$

*Examples*:

- $
  P(A, J, M, not B, not E) = P(A and J and M and not B and not E) = \
  = P(J | A) dot P(M | A) dot P(A | not B and not E) dot P(not E) dot P(not B) = \
  = 0.9 dot 0.7 dot 0.001 dot 0.999 dot 0.998 = 0.000628
$

- $
  P(A and B and E) = \
  = P(A | B and E) dot P(B) dot P(E) = \
  = 0.95 dot 0.001 dot 0.002 = 0.0000019
$

- $
  P(J, not M, not A, not B, not E) = \
  = P(J | not A) dot P(not M | not A) dot P(not A | not B and not E) dot P(not B) dot P(not E) = \
  = 0.05 dot 0.99 dot 0.999 dot 0.999 dot 0.998 = 0.0493
$

== Chain rule

The Bayesian network is a correct representation of the domain only if each node is conditionally independent of its other predecessors in the node ordering, given its parents:

$
  P(x_1, ..., x_n) = P(x_n | x_(n -1), ..., x_1)P(x_(n -1), ..., x_1)
$

$
  P(x_1, ..., x_n) = P(x_n|x_(n-1),...,x_1) dot \
  dot P(x_(n-1)|x_(n-2), ..., x_1) dot ... dot P(x_2|x_1) dot P(x_1) = \
  = Pi_(i = 1)^n P(x_i|x_(i - 1),...,x_1)
$

Every node in the network is equal to:
$
  P(X_i|X_(i-1),...,X_i) = P(X_i|"Parents"(X_i)) \
  "Parents"(X_i) subset.eq {X_(i-1), ..., X_1}
$

== Conditional independence relations in Bayesian networks

We have provided a “numerical” semantics for Bayesian networks in terms of the representation of the full joint distribution, as in equation above.

Now let's define topological semantics that specifies the conditional independence relationships encoded by the graph structure. From which later we can derive numerical semantics.

1. A node $X$ is conditionally independent of its non-descendants(e.g. $Z_(i j)$s), given its parents (the $U_i$s shown in the dashed area).

#figure(
  image("tikz/independent-relation/independent-relation-0.png", width: 70%),
  caption: [$X$ - conditionally independent node, $U_i$ - parents, $Z_(i j)s$ - non-descents, $Y_i$ - descents],
) 

2. A node $X$ is conditionally independent of all other nodes in the network given its *Markov blanket* (the dashed area).

#figure(
  image("tikz/independent-relation/independent-relation-1.png", width: 70%),
  caption: [$X$ - conditionally independent node, $U_i$ - parents, $Z_(i j)s$ - non-descents, $Y_i$ - descents],
) 

=== D-separation

There is also a general topological criterion called *d-separation* for deciding whether a set of nodes $X$ is conditionally independent of another set $Y$, given a third set Z. 

A set of nodes $E$(evidence) d-separate $X$ and $Y$, if every non-directed path $X arrow Y$ is blocked by the $E$ set(There might be other nodes in the path as well). The path is blocked by the set $E$, if there is a node $z$, for which one out of 3 conditions is met:

1. $z in E and $ ($z$ has one input and output)

#figure(
  image("tikz/d-separation/d-separation-0.png", width: 70%),
  caption: [$Z_1$ blocks the path to the $Y_1$ for $X_1$],
) 

2. $z in E and $ ($z$ has two outputs)

#figure(
  image("tikz/d-separation/d-separation-1.png", width: 70%),
  caption: [$Z_1$ blocks the path to the $Y_1$ for $X_1$],
) 

3. $z and "children"(z) in.not E and $ ($z$ has two inputs)

#figure(
  image("tikz/d-separation/d-separation-2.png", width: 70%),
  caption: [$Z_1 in.not E$ blocks the path to the $Y_1$ for $X_1$],
) 

=== D-separation example

#figure(
  image("tikz/d-separation/d-separation-3.png", width: 60%),
  caption: [An example of d-separation in the Bayesian network],
) 

1. Evidence $Z_1$ blocks $X arrow Y$ in a way described in the first D-separation rule.
2. Evidence $Z_2$ blocks $X arrow Y$ in a way described in the second D-separation rule.
3. If there is no evidence at all, then $X$ is independent from $Y$ as in the third D-separation rule.
4. With evidence $Z_3$ it turns out that $X$ is dependent on $Y$, because we have an evidence and there is no rule for a separation.

== Inference types

- Every node in the network can be used for querying and getting a proof. 

In all images $Q$ is query, $E$ is evidence

1. *Diagnostic inference* - from conclusions to consequences.

#figure(
  image("tikz/inference/inference-0.png", width: 60%),
  caption: [The query is $P(B|J)$, $B$ - burglary, $J$ - John],
) 

2. *Causal inference* - from consequences to conclusions.

#figure(
  image("tikz/inference/inference-1.png", width: 60%),
  caption: [The query is $P(J|B)$, $B$ - burglary, $J$ - John calls],
) 

3. *Midcausal inference* - from common conclusions get consequences.

#figure(
  image("tikz/inference/inference-2.png", width: 60%),
  caption: [The query is $P(B|A and K)$, $B$ - burglary, $A$ - Alarm, $K$ - earthquake],
) 

4. *Mixed inference* - two or 3 previous inference combination.

#figure(
  image("tikz/inference/inference-3.png", width: 60%),
  caption: [The query is $P(A|J and not K)$, $J$ - John calls, $A$ - Alarm, $K$ - earthquake. The combination of $1 + 2$ inference],
) 

#figure(
  image("tikz/inference/inference-4.png", width: 60%),
  caption: [The query is $P(B|K and J)$, $J$ - John calls, $B$ - Burglary, $K$ - earthquake. The combination of $1 + 3$ inference],
) 

== Probability system modelling steps

1. Knowledge engineer should decide what factors should be modelled and which could not directly affect the model
2. It should be decided about the random variable dictionary - is it discrete, continuous or boolean.
3. Need to decide the Bayesian network's topology. Find the qualitative or quantitative relations between random variables.
4. Encode the specific cases.
5. Test the network by querying. In some cases a *sensitivity analysis* can occur which helps to check how robust the values are. 