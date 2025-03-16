#import "templates/notes-template.typ": notes

#show: doc => notes(
  [4. Intelligent agents and environments], 
  doc
)

#set text(size: 11pt)

== Environments and their properties

+ *Fully observable* vs. *Partially observable* - if the agent with sensors can percept full, correct and actual information about environment's state. If the agent has no sensors at all, then the environment is *unobservable*.

+ *Deterministic* vs. *Stochastic* - every action has a guaranteed result that the next state can be predicted: $(s_i, a_i) arrow s'_i$. If the next state $s'_i$ cannot be clearly determined, then the environment is stochastic.

+ *Dynamic* vs. *Static* - if the environment changes independently from the agent actions, e.g. during calculation times, then it is dynamic. The environment is static if only the agent changes the environment. If the environment itself does not change with the passage of time but the agent's performance score does, then we say the environment is *semidynamic*, e.g. chess with the clock.

+ *Discrete* vs. *Continuous* - with discrete environment there is an amount of states that can be counted in a period of time - with continuous there are infinitely many states. E.g. chess is discrete, but moving the steering wheel is analog therefore continuous.

+ *Episodic* vs. *Sequential* - in episodic the agent's experience is divided into atomic episodes, where their actions do not affect future decisions, e.g. production line. In sequential every action affects the future ones, e.g. chess.

+ *Single agent* vs. *Multiagent* - where one agent works only with objects. Multiagent environment works with other agents where happens interaction on each other. E.g. in chess one agent's move affects decision of the second one.

\
\
\

== Examples of environments & their characteristics 

#table(
  columns: 7,
  [*Agent*], [*Obser-vable?*], [*Deter-ministic?*], [*Static?*], [*Discrete?*], [*Episodic?*], [*Single-agent?*],

  [Mail sorter], [Yes], [No], [Yes], [Yes], [Yes], [Yes],
  
  [Detail trans-ferer], [Yes], [No(Yes, if the same detail)], [No(Yes, if conveyor)], [Yes(No, if real situation)], [Yes], [Yes],

  [Chess], [Yes], [Yes], [Yes], [Yes], [No], [No],

  [Auto-nomous vehicle], [Partially], [No], [No], [No(Yes, if sensors)], [No], [No],
)

== Environment imitation

There is pseudocode how environment can be imitated for agent actions:

```pseudo
function $f: (s_0, "update", A, c)$ is
  $s_i arrow.l s_0$
  loop until $c$ is not reached
    foreach $a_i in A$ do
      $"generate perception": (a_i, s_i) arrow P$
      $"compute action": P arrow N$
      $"update": (N, s_i) -> s'_i$
      $"evaluate": (a_i, s'_i) arrow U = "const"$
    end foreach
    $s_i arrow.l s'_i$
  end loop
end
```

where $f$ - environment imitation function, $s_0$ - starting state,

$"update"$ - state update function, $A$ - set of agents,

$c$ - condition or predicate when process should end, $P$ - set of perceptions,

$N$ - set of actions, $s'$ - updated state, $U$ - evaluation score - evaluation score.