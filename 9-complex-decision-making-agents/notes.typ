#import "templates/notes-template.typ": notes

#show: doc => notes(
  [9. Complex decision making agents], 
  doc
)

#set text(size: 11pt)

== Making complex decisions

- Complex decisions represent a sequence of decisions where the result is not known by doing one action.

Let's imagine a new world in @world.

- Board is 4 x 3
- Square (4, 2) has a reward of -1
- Square (4, 3) has a reward of 1
- Square (2, 2) has an obstacle
- Square (1, 1) is a starting position

#figure(
  image("tikz/world/world-0.png", width: 80%),
  caption: [Environment representation]
) <world>

=== Deterministic environment

Let's imagine that the agent has 2 actions to plan ahead. The agent has complete information about the environment. For being in every state, the agent receives $-0.04$ points or receives points from (4, 2) and (4, 3) squares.

Let's imagine that the agent is in the square (3, 2). Then the decision tree will look like this(@deterministic).

#figure(
  image("tikz/deterministic-decision-tree/deterministic-decision-tree.png", width: 100%),
  caption: [Deterministic environment representation]
) <deterministic>

As can be seen in @deterministic, the agent can easily obtain the optimal path $(3,2) arrow (3,3) arrow (4,3)$. However, in real life the tree is much bigger than presented here.

=== Stochastic environment

Stochastic environment is more complex and requires a model for the agent to obtain. For the example, let's obtain that the environment's model is the following:

1. The agent might go to the planned location with the probability of 80%
2. The agent might go to the perpendicular directions with the probability 10% each

This model can be represented as in @move-model-1.

#figure(
  grid(
    columns: 2,
    [
      #image("tikz/move-model/move-model-0.png", width: 100%), (a)
    ],
    [
      #image("tikz/move-model/move-model-2.png", width: 100%), (b)
    ]
  ),
  caption: [Move models. (a) for the forward action, (b) for the right action]
) <move-model-1>

If we consider that the agent can do only a pair of actions sequentially, for example, (FORWARD, RIGHT), then we can construct a tree with all consequences. There are going to be $2^4 = 16$ trees overall. After that we can maximize our utility by choosing the tree with maximum value.

In @stochastic-1 is shown a tree for the action pair (FORWARD, RIGHT). Note that now we have only 3 actions due to the model. We cannot move backwards. 

#figure(
  image("tikz/stochastic-decision-tree/stochastic-decision-tree-0.png", width: 100%),
  caption: [Stochastic environment representation]
) <stochastic-1>

To calculate the final value of leaf nodes($v_("leaf")$) we have to multiply a prior value($v$) with the parents' probabilities($p$):
$
 v_("leaf") = Pi_(i in "parents"("leaf")) p_i dot v 
$

For example, the path $(3, 2) arrow (3, 3) arrow (4, 3)$ value is $0.8 dot 0.8 dot (1 - 0.12) = 0.5632$. After the value for each node is calculated, it is summed to get the overall value of the root. In this case $v_"root" = 0.344$.

Other example is the model of the actions (RIGHT, LEFT) in @move-model-2.

#figure(
  grid(
    columns: 2,
    [
      #image("tikz/move-model/move-model-2.png", width: 80%) (a)
    ],
    [
      #image("tikz/move-model/move-model-1.png", width: 50%) (b)
    ]
  ),
  caption: [Move models. (a) for the right action, (b) for the left action]
) <move-model-2>

The decision tree of this model looks like in @stochastic-2. In this case the sequence is not optimal. It produces negative value at the root($v_"root" = -0.888$).

#figure(
  image("tikz/stochastic-decision-tree/stochastic-decision-tree-1.png", width: 100%),
  caption: [Second sequence stochastic environment representation]
) <stochastic-2>

After all trees are constructed, we can make a decision on where to go(@stochastic-final). It turns out that the first sequence is the best one to choose. 

#figure(
  image("tikz/stochastic-decision-tree/stochastic-decision-tree-2.png", width: 100%),
  caption: [Final decision tree of stochastic environment where the best sequence is chosen.]
) <stochastic-final>

== Markovian decision process

*Transition model* (or just “model”) describes the outcome of each action in each state. The outcome is stochastic, so we write $P(s' | s, a)$ to denote the probability of reaching state $s'$ if action a is done in state $s$. We will assume that transitions are *Markovian*. 

Because the decision problem is sequential, the utility function will depend on a sequence of states— an *environment history* — rather than on a single state.

A sequential decision problem for a fully observable, stochastic environment with a *Markovian* transition model and additive rewards is called a *Markov decision process(MDP)*. It is defined by:

1. Initial state $s_0$, e.g. $s_0 = (1, 1)$
2. A set of actions in each state $A(s)$
3. a reward function $R(s)$, e.g. in the example:
$
  cases(
    plus.minus 1 "if terminal state" \
    -0.04 "else"
  )
$
4. A transition model $P(s' | s, a)$ or $M_(i j)$

== A transition model

Let's consider a simpler example of the game in the first chapter. We need to create a transition model $M^("forward")$ that defines all probabilities transitioning from one state to another. 

#figure(
  grid(
    columns: 2,
    [
      #image("tikz/world/world-1.png", width: 80%),
    ],
    [
      #image("tikz/move-model/move-model-0.png", width: 100%),
    ]
  ),
  caption: [A simpler environment and a move model]
)

Then $M^("forward") =$

\

#table(
  columns: 7,
  [], [(1, 1)], [(1, 2)], [(1, 3)], [(2, 1)], [(2, 3)], [(3, 1)], 

  [(1, 1)], [0.1], [0.8], [0], [0.1], [0], [0],  

  [(1, 2)], [0], [0.2], [0.8], [0], [0], [0],  
  
  [(1, 3)], [0], [0], [0.9], [0], [0.1], [0],  

  [(2, 1)], [0.1], [0], [0], [0.8], [0], [0.1],  

  [(2, 3)], [0], [0], [0.1], [0], [0.8], [0.1],  
)

_Note_: 2 columns were cut to save space. The notation of coordinates: (column, row).

== Policy

A solution must specify what the agent should do for any state that the agent might reach. A solution of this kind is called a *policy*. In other words a state-action mapping.

Policy is denoted by $pi$ and $pi(s)$ is the action recommended by the policy $pi$ for state $s$.

*Optimal policy*(denoted by $pi^*$) is a policy that yields the highest expected utility(EU):

$
  "EU"(a|e) = sum_i P("result"(a_i) = s' | a_i, e) dot U(s')
$

Policy provides a balance between a risk and a reward.

== Finding optimal policy

Our analysis draws on *multiattribute utility theory* and we use an environment history to measure a sum of rewards: $U_h (s_0, s_1, ..., s_n)$

There could be:

1. A *finite horizon* for decision making. It means that there is a fixed time $N$ after which nothing matters - the game is over. Thus

  $
    U_h (s_0, s_1, ..., s_(N + k)) = U_h (s_0, s_1, ..., s_N)
  $

  for all $k > 0$.

  The optimal policy with the finite horizon is *non-stationary*, i.e. $N$ value changes the behavior of the policy.

2. An *infinite horizon* for decision making - no time or step limit.

  The optimal policy with *infinite horizon* is *stationary*.

*Stationarity* for preferences means the following: if two state sequences $(s_0, s_1, s_2,...)$ and $(s'_0, s'_1, s'_2,)$ begin with the same state (i.e., $s_0 = s'_0$). 

*Stationarity* is a fairly innocuous-looking assumption with very strong consequences: it turns out that under stationarity there are just two coherent ways to assign utilities to sequences:

1. *Additive rewards*: The utility of a state sequence is 

  $
    U_h (s_0, s_1, s_2, ...) = R(s_0) + R(s_1) + R(s_2) + ...
  $

2. *Discounted rewards*:

  $
    U_h (s_0, s_1, s_2, ...) = R(s_0) + alpha R(s_1) + alpha^2 R(s_2) + ...
  $

  where $0 < alpha < 1$ is a discount factor. It describes the preference of an agent for current rewards over future rewards. It is equivalent to an interest rate of $1 / alpha - 1$

With discounted rewards, the utility of an infinite sequence is finite. In fact, if $alpha < 1$ and rewards are bounded by $plus.minus R_max$, we have:

$
  U_h (s_0, s_1, s_2, ...) = sum_(t = 0)^infinity alpha^t R(s_t) <= sum_(t = 0)^infinity alpha^t R_max = R_max / (1 - alpha)
$

Using the standard formula for the sum of an infinite geometric series.

If the environment contains terminal states and if the agent is guaranteed to get to one eventually, then we will never need to compare infinite sequences.

The utility of a given state sequence is the sum of discounted rewards obtained during the sequence, we can compare policies by comparing the expected utilities obtained when executing them. The expected utility is:

$
  U^pi (s) = EE [ sum_(t = 0)^infinity alpha^t dot R(S_t)]
$

where $U^pi (s)$ is the utility on the state $s$ using a specified policy $pi$, 
$alpha$ - discount factor, $S$ - state sequence, e.g. $S_0 = s$ - the current state.

_Note_: $R(s)$ is the “short term” reward for being in $s$, whereas $U(s)$ is the “long term” total reward from $s$ onward.

Out of all policies the agent could choose one best policy:

$
  pi^* (s) = limits("argmax")_pi space U^pi (s)
$

Remember that $pi^*_s$ is a policy, so it recommends an action for every state; its connection with $s$ in particular is that it's an optimal policy when $s$ is the starting state.

The utility function $U(s)$ allows the agent to select actions by using the principle of maximum expected utility:

$
  pi^*_s = limits("argmax")_(a in A(s)) sum_(s') P(s' | s, a) dot U(s')
$

_Note_: From the transitional model $M_(i j)$ we can imagine that $i = s$ and $j = s'$, therefore there is a transition $M_(i = s, j = s')$

== Finding optimal policies: Bellman equation

The utility of a state is the immediate reward for that state plus the expected discounted utility of the next state, assuming that the agent chooses the optimal action:

$
  U(s) = R(s) + alpha limits("max")_(a in A(s)) sum_s' P(s' | s, a) dot U(s')
$

Let us look at one of the Bellman equations for 4x3 world for the state (1, 1):



$
  &U(1, 1) = -0.04 + \
  + alpha dot max [&0.8U(1, 2) + 0.1U(2, 1) + 0.1U(1, 1), "(Up)"\
  &0.9U(1, 1) + 0.1U(1, 2), "(Left)"\
  &0.9U(1, 1) + 0.1U(2, 1), "(Down)"\
  &0.8U(2, 1) + 0.1U(1, 2) + 0.1U(1, 1)] "(Right)"
$

#figure(
  image("tikz/world/world-0.png", width: 50%),
  caption: [A reference to the board]
)

== The value iteration algorithm

*NEED TO COME BACK TO THIS PLACE AND ADD ADDITIONAL COMMENTS FROM THE BOOK!!!*
page 652

$
  U_(i + 1) (s) = R(s) + alpha limits("max")_(a in A(s)) sum_s' P(s'| s, a) dot U_i (s')
$
where $U_(i + 1)$ is the utility on the next iteration

$
  pi^\* (s) = limits("argmax")_(a in A(s)) sum_s' P(s' | s, a) dot U(s')
$

Algorithm(formal description from the book):

=== Example:

- $alpha = 1$
- Every state has $forall s space U(s) = 0$

#figure(
  image("tikz/value-iteration/value-iteration-0.png", width: 40%),
  caption: [Starting state],
) 

*FIRST ITERATION*:

1. $U(3, 3)$:

(Up): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 1 = 0.06$

#text(red)[(Right): $-0.04 + 0.8 dot 1 + 0.1 dot 0 + 0.1 dot 0 = 0.76$]

(Left): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 0 = -0.04$

(Down): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 1 = 0.06$

$arrow.double max U(3, 3) = 0.76$

$arrow.double pi^* = "Right"$

2. $U(3, 2)$:

(Up): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot (-1) = -0.14$

(Right): $-0.04 + 0.8 dot (-1) + 0.1 dot 0 + 0.1 dot 0 = -0.84$

#text(red)[(Left): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 0 = -0.04$]

(Down): $-0.04 + 0.8 dot 0 + 0.1 dot (-1) + 0.1 dot 0 = -0.14$

$arrow.double max U(3, 2) = -0.04$

$arrow.double pi^* = "Left"$

3. $U(4, 1)$:

(Up): $-0.04 + 0.8 dot (-1) + 0.1 dot 0 + 0.1 dot 0 = -0.84$

(Right): $-0.04 + 0.8 dot 0 + 0.1 dot (-1) + 0.1 dot 0 = -0.14$

(Left): $-0.04 + 0.8 dot 0 + 0.1 dot (-1) + 0.1 dot 0 = -0.14$

#text(red)[(Down): $-0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 0 = -0.04$]

$arrow.double max U(4, 1) = -0.04$

$arrow.double pi^* = "Down"$

Other positions produce the value of $U(s) = -0.04$

The final results after the first iteration in @first-iteration.

#figure(
  image("tikz/value-iteration/value-iteration-1.png", width: 40%),
  caption: [The values after the first iteration],
) <first-iteration>

*SECOND ITERATION*:

1. $U(3, 1)$: *NEED TO CHECK RESULTS HERE!*

(Up): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-0.04) + 0.1 dot (-0.04) = -0.08$

(Right): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-0.04) + 0.1 dot (-0.04) = -0.08$

(Left): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-0.04) + 0.1 dot (-0.04) = -0.08$

(Down): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-0.04) + 0.1 dot (-0.04) = -0.08$

$arrow.double max U(4, 1) = -0.08$

$arrow.double pi^* = "?"$

2. $U(3, 3)$: 

(Up): $-0.04 + 0.8 dot 0.76 + 0.1 dot (-0.04) + 0.1 dot 1 = 0.644$

#text(red)[(Right): $-0.04 + 0.8 dot 1 + 0.1 dot 0.76 + 0.1 dot (-0.04) = 0.832$]

(Left): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 0.76 + 0.1 dot (-0.04) = 0$

(Down): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 1 + 0.1 dot (-0.04) = 0.024$

$arrow.double max U(3, 3) = 0.832$

$arrow.double pi^* = "Right"$

3. $U(3, 2)$: 

#text(red)[(Up): $-0.04 + 0.8 dot 0.76 + 0.1 dot (-0.04) + 0.1 dot (-1) = 0.464$]

(Right): $-0.04 + 0.8 dot (-1) + 0.1 dot 0.76 + 0.1 dot (-0.04) = 0.768$

(Left): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 0.76 + 0.1 dot (-0.04) = 0$

(Down): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-0.04) + 0.1 dot (-1) = 0.176$

$arrow.double max U(3, 2) = 0.464$

$arrow.double pi^* = "Up"$

Other positions produce the value of $U(s) = -0.08$

The final results after the first iteration in @second-iteration.

#figure(
  image("tikz/value-iteration/value-iteration-2.png", width: 40%),
  caption: [The values after the second iteration],
) <second-iteration>

The same actions are done for all states. The convergence can be received after 18 iterations in @last-iteration

#figure(
  grid(
    columns: 2,
    [
      #image("tikz/value-iteration/value-iteration-3.png", width: 100%),
    ],
    [
      #image("tikz/value-iteration-policy/vi-policy-0.png", width: 100%),
    ],
  ),
  caption: [The values after 18 iterations. The convergence is received. On the right image we see the optimal policy $pi^*$],
) <last-iteration>

=== Rewards

Depending on the constant reward value, the agent will behave differently. 

#figure(
  image("tikz/value-iteration-policy/vi-policy-1.png", width: 50%),
  caption: [$R(s) < -1.684$ - everything is so bad, so the agent decides to suicide right away],
) 

#figure(
  image("tikz/value-iteration-policy/vi-policy-2.png", width: 50%),
  caption: [$-0.427 < R(s) < -0.08$ - The agent becomes quite risky],
) 

#figure(
  image("tikz/value-iteration-policy/vi-policy-3.png", width: 50%),
  caption: [$-0.0221 < R(s) < 0$ - The agent becomes to play too safely],
) 

#figure(
  image("tikz/value-iteration-policy/vi-policy-4.png", width: 50%),
  caption: [$R(s) > 0$ - The agent does not want to die, and it wants to leave in this world for so long it is possible.],
) 

== Policy iteration algorithm

It consists of 2 steps:

1. Policy evaluation
  During the policy evaluation, we don't need $max$ of arguments. That way we get a system of linear equations, instead of non-linear. It should be faster to calculate.

  $
    U_i (s) = R(s) + alpha sum_s' P(s' | s, pi_i (s)) dot U(s')
  $

2. Policy improvement(Finding better $pi^*$)

  If this inequality holds:
  $
    limits("argmax")_(a in A(s)) sum_s' P(s' | s, a) dot U(s') > \
    sum_s' P(s' | s, pi(s)) dot U(s')
  $
  then: 
  $
    pi(s) = limits("argmax")_(a in A(s)) sum_s' P(s' | s, a) dot U(s')
  $

=== Example

Let's imagine that we have a random policy like in @random-policy.

#figure(
  image("tikz/policy-iteration/policy-iteration-0.png", width: 50%),
  caption: [A part of randomly created policy],
) <random-policy>

1. Let's calculate the policy evaluation

$U(3, 2) = -0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 0 = -0.04$

$U(3, 3) = -0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 1 = 0.06$

$U(3, 1) = -0.04 + 0.8 dot 0 + 0.1 dot 0 + 0.1 dot 0 = -0.04$

$U(4, 1) = -0.04$

$U(2, 3) = -0.04$

We get the following distribution in 

#figure(
  image("tikz/policy-iteration/policy-iteration-1.png", width: 50%),
  caption: [A random policy value distribution],
) <policy-distribution>

2. Can we improve it?

- _Note_: We use updated values in in this iteration

$U(3, 2)$: 

(Up): $-0.04 + 0.8 dot 0.06 + 0.1 dot (-0.04) + 0.1 dot (-0.04) = -0.096$

(Right): $-0.04 + 0.8 dot (-1) + 0.1 dot 0.06 + 0.1 dot (-0.04) = -0.838$

(Left): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 0.06 + 0.1 dot (-0.04) = -0.07$

(Down): $-0.04 + 0.8 dot (-0.04) + 0.1 dot (-1) + 0.1 dot (-0.04) = -0.176$

In this case the equation does not hold, because $U(3, 2) = -0.04$:
  $
    limits("argmax")_(a in A(s)) sum_s' P(s' | s, a) dot U(s') > \
    sum_s' P(s' | s, pi(s)) dot U(s')
  $

Therefore the policy does not change: 

$pi^*(3, 2) = zws arrow.l$ 

$U(3, 3)$: 

(Up): $-0.04 + 0.8 dot 0.06 + 0.1 dot 1 + 0.1 dot (-0.04) = 0.104$

#text(red)[(Right): $-0.04 + 0.8 dot 1 + 0.1 dot 0.06 + 0.1 dot (-0.04) = 0.762$]

(Left): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 0.06 + 0.1 dot (-0.04) = -0.07$

(Down): $-0.04 + 0.8 dot (-0.04) + 0.1 dot 1 + 0.1 dot (-0.04) = 0.024$

In this case the equation does hold, because $U(3, 3) = 0.06 < 0.762$.

Therefore the policy does change: 

$pi(3, 3) = zws arrow.t (U(3, 3) = 0.06)$ 

$pi^*(3, 3) = zws arrow.r (U(3, 3) = 0.762)$ 

For policy iteration algorithm, it is required to have only 5 iterations for the algorithm to converge to stable values. In comparison to value iteration process, where 18 were needed.