#import "templates/notes-template.typ": notes
#show: doc => notes(
  [3. Intelligent agent(IA) types], 
  doc
)

== Intelligent agent as a function

As was described in previous lections we can describe intelligent agent as a function:

$
f: P arrow A
$

where $P$ is a perception set and $A$ is an action set.

#figure(
  image("tikz/pic/pic.png", width: 80%),
  caption: [Agent as a function can be seen as a black box]
)

Agent is a function that is a black box, i.e. we don't know how it produces its results. An agent receives information(perception $P$) from sensors, processes them via function($f$) and returns back an action($A$) to do.

The common algorithm of intelligent agent can be described as:

```pseudo
function $f: P arrow a in A$ is
  let Knowledge Base : Memory($M$)
  update : $(M,P) arrow M'$
  action : $M' arrow a$
  update : $(M', a) arrow M''$
return $a$
```

== Intelligent agent types

#figure(
  image("diagrams/diagram.md-1.png", width: 120%),
  caption: [IA types]
)

== Simple reflex agents

Algorithm can be described the following way:

```pseudo
function $f_r: P arrow a in A$ is
  let $R$ = production rules - IF condition THEN action
  $"interpret input" : P arrow s_i in S ["state"]$
  $"rule search" : (s_i, R) arrow r_i in R$
  $"rule burning" : r_i arrow a$
return $a$
```

Illustration of the simple reflex agents working principle in @reflex.

#figure(
  image("tikz/reflex/reflex.png", width: 100%),
  caption: [Simple reflex agents working principle]
) <reflex>

Simple reflex agents uses _Knowledge Base_ with production rules.

*Example*:

_R1_: *IF* a driving car ahead has both stop signals turned on(_N_) *THEN* a driving car ahead is stopping (_C1_)

_R2_: *IF* a driving car ahead is stopping(_C1_) *THEN* a driving car ahead is slowing down (_C2_)

_R3_: *IF* a driving car ahead is slowing down(_C2_) *THEN* need to start to slow down (_C3_)

_R4_: *IF* need to start to slow down (_C3_) *THEN* press a braking pedal(_A_)

Where _R_ is a production rule, _C_ - conclusion, _N_ - condition, _A_ - action.

By using an *inference* mechanism, we can make a conclusion, that if we start with the production rule _N_, then we have the following chain: $N arrow C_1 arrow C_2 arrow C_3 arrow A$ and that we should press the braking pedal.

== Model-based agents

1. Follows how changes the environment, the state. Knows the previous state.
2. Environment changes regardless of agent.
3. Need to understand the consequences from actions.

All 3 actions describe the *inner state* of the agent(@model).

#figure(
  image("tikz/model/model.png", width: 100%),
  caption: [Model-based agents working principle]
) <model>

== Goal-based agents

- Actions are dependent on what the goal is needed to be achieved by the agent.
- Can be effectively used with the search or planning(for robots) algorithms.

#figure(
  image("tikz/goal/goal.png", width: 100%),
  caption: [Goal-based agents working principle]
) <goal>

== Utility agents

- Can be applied when the problem cannot be solved with the goal-based agent, e.g.
  - More than 1 goal
  - And goals may be conflicting, therefore some compromise should be found
- Goals might be achieved using probabilities(e.g. games of chance)
- *Utility function*($U$) is a measurement that allows to compare different states, i.e. given two states($s_1, s_2 in S$) and give a numeric value($v$) of how these states differ:  $U: (s_1, s_2) arrow v$
- Agent can be based on the *utility theory*.

#figure(
  image("tikz/utility/utility.png", width: 100%),
  caption: [Utility agents working principle]
) <utility>

== Learning agents

- The agent has a capability to learn taking into account external performance standard

#figure(
  image("tikz/learning/learning.png", width: 100%),
  caption: [Learning agents working principle]
) <learning>

== Methodologies

- Not sure if something serious uses these tools, but somebody might use:
  - *FIPA* (Foundation for Intelligent Physical Agents)
  - *BDI* (behavior - desire - intent) agents

- Not sure if somebody will ever use some of these methodologies in practice:
  - *PROMETHEUS* - iterative waterfall model
  - *Gaia*  
  - *MaSE*  
  - *MASITS* - local RTU development for multi-agents that helps with tutoring