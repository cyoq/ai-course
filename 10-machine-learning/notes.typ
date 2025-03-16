#import "templates/notes-template.typ": notes
#import "@preview/cetz:0.2.2"
#import "@preview/tablex:0.0.6": tablex, colspanx, rowspanx, cellx
#import "@preview/gentle-clues:0.8.0": *
#import "@preview/pinit:0.1.4": *
#import "@preview/fletcher:0.4.4" as fletcher: diagram, node, edge, shapes

#let pinit-highlight-equation-from(height: 2em, pos: bottom, fill: rgb(0, 180, 255), highlight-pins, point-pin, body) = {
  pinit-highlight(..highlight-pins, dy: -0.6em, fill: rgb(..fill.components().slice(0, -1), 40))
  pinit-point-from(
    fill: fill, pin-dx: -0.6em, pin-dy: if pos == bottom { 0.8em } else { -0.6em }, body-dx: 0pt, body-dy: if pos == bottom { -1.7em } else { -1.6em }, offset-dx: -0.6em, offset-dy: if pos == bottom { 0.8em + height } else { -0.6em - height },
    point-pin,
    rect(
      inset: 0.5em,
      stroke: (bottom: 0.12em + fill),
      {
        set text(fill: fill)
        body
      }
    )
  )
}

#show: doc => notes(
  [10. Learning from Examples: Machine Learning], 
  doc
)

#set text(size: 11pt)

== Machine Learning

- The agent cannot be autonomous if it cannot learn

- Machine learning is the induction problem. From examples $arrow$ general ideas.

=== Machine Learning Approaches

- _Symbolic_ - formally described knowledge

- _Example based_ - does not fully represent the knowledge. Examples are classified, but they are not described

- _Evolution_ - using many generations, optimizing the approach

=== Learning approaches

- New knowledge addition to the previously available knowledge
  - Knowledge analysis
  - Error resolution
- Useful regularity findings in data
  - Data mining
  - Data Science
  - kNN, decision tree, perceptrons
  - Evolution
- Supervised/Unsupervised learning

=== Agent structure

#figure(
  image("./images/learning.png", width: 80%),
  caption: [The learning agent general structure]
) <learning-agent>

In @learning-agent the problem generator is the generator of noise. The main 2 blocks are _learning_ and _performance_ elements.

=== Learning element design aspects

1. Which performance element components should be modified?

  - Depends on the performance element

2. What knowledge representation type is used?

  - Depends on the project:
    - Frames, networks, logic, ...

3. What feedback is available?

  - Depends on the learning type supervised/unsupervised

4. What primary knowledge is available?

== Training

During training the main task of the agent is to find an approximation function by using examples: $(x, f(x))$

However, how do we know which approximation to use to get the best hypothesis?

#include "approximations.typ"

- We say hypothesis *generalizes* well if it correctly predicts the value of $y$ for novel examples.

- To be compliant with hypothesis, every example must be included into it

=== How to choose the best hypothesis?

- _Ockham's razor_ principle (1334) - there is no need to do bigger effort, if it is possible to use less effort

- Therefore we need to choose the simplest hypothesis

- There is a small possibility that the simplest hypothesis will be inconsistent or incorrect.

- The simplest hypothesis is easier to compute.

- And it better generalizes.

== Training with decision trees

- Classified as symbolic training
- "White-box" method
- Algorithms to use:
  - ID3
    - More about the algorithm described in Russell & Norvig book in Chapter 18, page 702
  - C4.5, etc.
- Input is the set of attributes($X$) and the output is the decision($y$): ${x_1, x_2, ..., x_n} in X arrow y$
- *Classification* task trains a discrete function
- *Regression* task trains a continuous function

*Decision tree* is a graph where:
- Inner nodes proceeds with conditional checking
- No-way nodes defines a decision value

*Decisions trees* allow:
- describe one specific situation/object
- describe any boolean function
#info(title: "Note")[there are $2^2^n$ boolean functions where $n$ is the attribute amount]
- hard to describe parity or majority functions

=== Example

Let's consider an example where we need to find a decision on waiting or not waiting a table in the restaurant. In @data the data used for the example is presented.

#figure(
  image("images/data.png"),
  caption: [Data for decision trees. Taken from Russell & Norvig book.]
) <data>

Specific examples can be described with predicate or first-order logic:

1. 
  $
    "Restaurant" = "Full" and \
    "Waiting time" = "0 - 10" and not "Hungry" arrow "Wait"
  $

2. 
  $
    forall r space ("Regular guests"(r, "Full") and \
    "Waiting time"(r, "0 - 10") and not "Hungry"(r) arrow "Wait"(r))
  $

3. 
  $
    forall r space ("Wait"(r) = P_1 (r) or P_2 (r) or ... or P_n (r))
  $
  where $P_i (r)$ is one the branches of the tree


=== Decision tree construction

- We can create a tree, just by going through the examples one by one
  - However, this tree will be big, 12 levels deep
  - It will be overfitted, i.e. it will be able to predict only test data
  - No way it could generalize good enough
  - It breaks the Ockham's razor principle of simplicity

- Therefore, we use different approach:

Let's take a _Bar_ to analyze its examples:

#tablex(
  columns: 4,
  align: center + horizon,
  colspanx(4)[_Bar_],

  colspanx(2)[*No*],
  colspanx(2)[*Yes*],

  [*Negative*], [*Positive*], [*Negative*], [*Positive*],
    [$x_2$], [$x_1$], [$x_7$], [$x_3$],
    [$x_5$], [$x_4$], [$x_9$], [$x_6$],
    [$x_11$], [$x_8$], [$x_10$], [$x_12$],
)

It does not fit, since there is no obvious examples for positive or negative results.

Let's take _Hungry_:

#tablex(
  columns: 4,
  align: center + horizon,
  colspanx(4)[_Hungry_],

  colspanx(2)[*No*],
  colspanx(2)[*Yes*],

  [*Negative*], [*Positive*], [*Negative*], [*Positive*],
    [$x_5$], [$x_3$], [$x_2$], [$x_1$],
    [$x_7$], [], [$x_10$], [$x_4$],
    [$x_11$], [], [], [$x_6$],
    [$x_9$], [], [], [$x_8$],
)

It is closer, but still no explicit positives/negatives.

Let's take _Regular guests_:

#tablex(
  columns: 6,
  align: center + horizon,
  colspanx(6)[_Regular guests_],

  colspanx(2)[*No one*],
  colspanx(2)[*Some*],
  colspanx(2)[*Full*],

  [*Neg*], [*Pos*], [*Neg*], [*Pos*], [*Neg*], [*Pos*],
    [$x_7$], [], [], [$x_1$], [$x_2$], [$x_4$],
    [$x_11$], [], [], [$x_3$], [$x_5$], [$x_12$],
    [], [], [], [$x_6$], [$x_9$], [],
    [], [], [], [$x_8$], [$x_10$], []
)

Here we can certainly see a nice tendency that _No one_ and _Some_ has explicitly only negative and positive examples. This is the best attribute, therefore it will go to the root of the tree. 

The next step is to take all the data left with _Full_ attribute, and do the same actions with the data left-overs.

The final tree in @tree

#figure(
  image("tikz/decision-tree/decision-tree.png", width: 80%),
  caption: [The final decision tree],
) <tree>

#info(title: "Note")[
  The value of _French_ edge was not determined. It was determined by the majority of values from the parent node _Hungry_. 
]

When doing a construction of the tree, it is needed to keep in mind following properties.

*Properties*:

1. If there are some positive or some negative examples, we choose the best attribute
2. If there are all positive or all negative examples, the node is fully decided and solved
3. If there are no values at the node, we return a default value. E.g. getting the majority from the parent values. As it was in the example of _French_, where majority of the parent was _Yes_.
4. If there are no attributes, but there is data, then there is no way, but to search for a new attribute

=== Choosing attribute tests

- To choose the attribute Shannon and Weaver method (1949) for information amount calculation is used.
- The less is known about the result, the more information is received.
- It is described with the *information* or *entropy* formula:

$
  I(p(v_1), ..., p(v_n)) = sum_(i = 1)^n -p(v_i) dot log_2 p(v_i)
$
where $I$ is the information amount in bits and $p(v_i)$ is the probability of the random variable $v_i in V$ to occur.

For example, the fair coin where it has a 50% probability of both results is calculated:

$
  I(1/2, 1/2) = -1/2 log_2 1/2 - 1/2 log_2 1/2 = 1 "bit"
$

- We have 1 bit of information where we certainly know "heads" or "tails"
- This is called as a "perfect" attribute that equally divides the information
- Every attribute divide a dataset into subsets. E.g. attribute _Hungry_ from @tree divides the set into _Yes_ and _No_

When working with subsets, we have the following formula:

$
  I(p/(p + n), n/(p + n)) = \
  - p/(p + n) log_2 p/(p + n) - n/(p + n) log_2 n/(p + n)
$
where $p$ and $n$ represent the total number of positive and negative examples.

We can also just use the information or entropy formula: $I(p_i/(p_i + n_i), n_i/(p_i + n_i))$ where $i$ is the subset.

=== Information gain

We can calculate the information gain for each attribute in the following way:

1. Calculate the remainder entropy for the current subset:

  $
    R(A) = sum_(i = 1)^v (p_i + n_i)/(p + n) dot I(p_i/(p_i + n_i), n_i/(p_i + n_i))
  $
  where $R$ is a remainder, $A$ is the attribute, $v$ is the number of subsets in the attribute.

2. Calculate the gain for the attribute with:

  $
    G(A) = I(p/(p + n), n/(p + n)) - R(A)
  $
  where $G$ is the information gain for the attribute

==== Example

Let's calculate the information gain for _Regular guests_.

#v(2em)

$
  G("Regular guests") = \
  #pin(1) 1 #pin(2) - (#pin(3) 4/12 dot I(1, 0) #pin(4) + #pin(5) 2/12 dot I(0, 1) #pin(6) + #pin(7) 6/12 dot I(2/6, 4/6) #pin(8)) \
  approx 0.541
$

#pinit-highlight-equation-from((1, 2), 2, height: 3.5em, pos: bottom, fill: rgb(0, 180, 255))[
  The full set, ${p:6; n:6} -> I(1/2,1/2) = 1$
]

#pinit-highlight-equation-from((3, 4), 3, height: 3.5em, pos: top, fill: rgb(150, 90, 170))[
  _Some_, ${p: 4; n: 0}$
]

#pinit-highlight-equation-from((5, 6), 5, height: 5.5em, pos: bottom, fill: rgb(44, 7, 53))[
  _None_, ${p: 0; n: 2}$
]

#pinit-highlight-equation-from((7, 8), 7, height: 3.5em, pos: top, fill: rgb(0, 180, 255))[
  _Full_, ${p: 2; n: 4}$
]

#v(4em)

Let's calculate the information gain for attribute _Type_:

$
  G("Type") = \
  1 - (#pin(9) 2/12 dot I(1/2, 1/2) #pin(10) + \
  + #pin(11) 4/12 dot I(2/4, 2/4) #pin(12) + \
  + #pin(13) 4/12 dot I(2/4, 2/4) #pin(14) + \
  + #pin(15) 2/12 dot I(1/2, 1/2) #pin(16))  \
  = 1 - (1/6 + 1/3 + 1/3 + 1/6) = 0
$

#pinit-highlight-equation-from((9, 10), 10, height: 1em, pos: top, fill: rgb(0, 180, 255))[
  _French_, ${p:1; n: 1}$
]

#pinit-highlight-equation-from((11, 12), 12, height: 1em, pos: top, fill: rgb(150, 90, 170))[
   _Burger_, ${p: 2; n: 2}$
]

#pinit-highlight-equation-from((13, 14), 14, height: 1em, pos: top, fill: rgb(44, 7, 53))[
  _Thailand_, ${p: 2; n: 2}$
]

#pinit-highlight-equation-from((15, 16), 16, height: 1em, pos: top, fill: rgb(0, 180, 255))[
  _Italian_, ${p: 1; n: 1}$
]

It looks obvious that $G("Regular guests") > G("Type")$ therefore we use the attribute with the biggest information gain as the root node.

== Evaluation of learning algorithm

1. Need to collect a big dataset with examples
2. Need to separate the dataset into 2 sets: *training* and *testing*
3. Need to use a *training* dataset to generate a hypothesis
4. Measure the amount of examples that are correctly classified
5. Amend the *training* dataset with more examples possible

== Decision list learning

- Logical statement in the limited form that consists of the series of tests described with words and conjunctions. If the test is successful then the following tests are decided.

*Example*:

#{
  set text(size: 9pt)
  diagram(
    spacing: (0.2cm, 1cm),
    edge-stroke: 1pt,
    crossing-thickness: 5,
    mark-scale: 50%,
    node-fill: luma(97%),
    node-outset: 3pt,
    node-stroke: black,
    node((0,0), $"Regular guests"(r, "Some")$, name: <1>),
    edge("-|>", "Yes"),
    node((0,1), "Yes"),
    node((0,1.5), text(red)[Classifies $4/12$], fill: white, stroke: white),

    node((4,0), $"Reg. guests"(r, "Full") \ and "Fri/Sat"(r)$, name: <2>),
    edge("-|>", "No"),
    node((7, 0), "No"),

    node((4,1), "Yes"),
    node((4,1.5), text(red)[Classifies $2/12$], fill: white, stroke: white),

    edge(<1>, <2>, "-|>", "No"),
    edge(<2>, (4,1), "-|>", "Yes"),
  )
}

The diagram above can be described as:

$
  "Wait" equiv ("Restaurant" = "Some") \
  or ("Restaurant" = "Full" and "Fri/Sat")
$

== Usage of knowledge in learning

- Most of the methods researched previously do not use any prior domain knowledge 
- The cumulative learning process can be displayed the following way:

#{
  set text(size: 9pt)
  diagram(
    spacing: (0.2cm, 1cm),
    edge-stroke: 1pt,
    crossing-thickness: 5,
    mark-scale: 50%,
    node-fill: luma(97%),
    node-outset: 3pt,
    node-stroke: black,
    node((0,0), [Examples], name: <examples>, fill: white, stroke: white),
    node((2.2,0), [Induction knowledge \ based learning], name: <based>),
    node((4.4,0), [Hypotheses], name: <hypotheses>),
    node((4.4,1), [Classification], name: <classification>, fill: white, stroke: white),
    node((2.2,-1), [Prior knowledge], name: <prior>),

    edge(<examples>, <based>, "-|>"),
    edge(<based>, <hypotheses>, "-|>"),
    edge(<prior>, <based>, "-|>"),
    edge(<hypotheses>, <classification>, "-|>"),
  )
}

- Prior knowledge is described with the first-order logic

=== Example

There is a logical description:

$
  "Alternative"(X_1) and not "Bar"(X_1) and \
  and not "Fri/Sat"(X_1) and "Hungry"(X_1)
$

The classification is:

$
  "Wait"(X_1) equiv Q(X_1)
$
where $Q(X_1)$ is the unary goal predicate

- The goal is to find the logical statement that will satisfy the $Q(X)$ for all examples.
- Every hypothesis describes a goal predicate candidate $C_i$
- Therefore every hypothesis $H_i$ is a sentence described as:
$
  forall x space Q(x) equiv C_i (x)
$

- For the restaurant problem, the inducted decision tree suggests the following candidate(hypothesis):

$
  forall r space "Wait"(r) equiv "Regular guests"(r, "Some") or \
  or ("Regular guests"(r, "Full") and "Hungry"(r) and \
  and "Type"(r, "French")) or \
  or ("Regular guests"(r, "Full") and "Hungry"(r) and \
  and "Type"(r, "Burger")) or \
  or ("Regular guests"(r, "Full") and "Hungry"(r) and \
  and "Type"(r, "Thailand") and "Fri/Sat"(r))
$

- If hypothesis is *consistent* with the whole dataset, then it is *consistent* with every example.
- The table of hypothesis consistence with examples:

#tablex(
  columns: 4,
  align: center + horizon,
  cellx(x: 0, y: 0, colspan: 2, rowspan: 2)[],

  colspanx(2)[*Actual*],
    [_True_], [_False_],

  rowspanx(2)[*Predicted*],
    [_True_], [True positive(TP)], [False positive(FP)],
    [_False_], [False negative(FN)], [True negative(TN)],
)

== Searching the current-best-hypothesis

- For pseudocode use Russell & Norvig book on page 770
- The idea of the method is to keep one hypothesis and adjust it to keep the consistence
- The algorithm is greedy
- The process can be visualized as in @hypothesis

#figure(
  image("images/hypothesis.png"),
  caption: [a) A consistent hypothesis. (b) A false negative. (c) The hypothesis is generalized. (d) A false positive. (e) The hypothesis is specialized.]
) <hypothesis>

- Generalization and specialization are defined as the operations which change the hypothesis extension
- If hypothesis $H_1$ with definition $C_1$ is the hypothesis' $H_2$ with definition $C_2$ generalization, then 

$
  forall x space C_2 (x) => C_1 (x)
$
I.e. $C_1$ is the generalization over $C_2$

E.g.

$
  forall r space C_2(r) equiv "Alternative"(r) and "Regular guests"(r, "Some") \
  forall r space C_1(r) equiv "Regular guests"(r, "Some") \
  C_2 => C_1
$

=== Example

- $H_1: forall r space "Wait"(r) equiv "Alternative"(r)$
  - 2nd example is false positive from @data
  - Therefore we use specialization
- $H_2: forall r space "Wait"(r) equiv "Alternative"(r) and "Regular guests"(r, "Some")$
  - 3rd example from @data is false negative
  - Therefore we generalize the hypothesis
- $H_3: forall r space "Wait"(r) equiv "Regular guests"(r, "Some")$
  - 4th example from @data is false negative
  - Therefore we generalize the hypothesis
  - The generalization removes the attribute, therefore we replace it with something else or use disjunction($or$)
- $H_4: forall r space "Wait"(r) equiv "Regular guests"(r, "Some") or ("Regular guests"(r, "Full") and "Fri/Sat"(r))$
  - $H_4$ is consistent with all examples
  - It could also be different, e.g.
    - $H_4 ': forall r space "Wait"(r) equiv not "Waiting time"(r, 30 - 60)$
    - etc.


