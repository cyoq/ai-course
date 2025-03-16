#import "templates/notes-template.typ": notes
#show: doc => notes(
  [2. Intelligent agents(IA)], 
  doc
)

#set text(size: 11pt)

== Intelligent agents

#grid(
  columns: 2,
  figure(
    image("diagrams/diagram.md-1.png"),
    caption: [Simple intelligent agent representation],
  ),

  figure(
    image("diagrams/diagram.md-2.png"),
    caption: [Extended intelligent agent representation],
  ) 
)

We can describe an intelligent agent as a mathematical function which maps perceptions to the specific action:

$
f: P arrow A,
$

where $P$ is a perception set and $A$ is an action set.

#figure(
  image("tikz/agent.png", width: 90%),
  caption: [Agent as a function can be seen as a black box],
) 

Agent is a function that is a black box, i.e. we don't know how it produces its results. An agent receives information(perceptions) from sensors($P$), processes them via function($f$) and returns back an action(from set $A$) to execute.

== Intelligent agent types

#image("diagrams/diagram.md-3.png", width: 120%)

\

== IA intelligence

#image("diagrams/diagram.md-4.png", width: 110%)

== BDI agents

#image("diagrams/diagram.md-5.png", width: 110%)

== IA as a program

An agent can be described as a program:

agent = program + architecture(computing platform)

#image("diagrams/diagram.md-6.png", width: 110%)

Architectural properties can be described with the abbreviations *PAGE* and *PEAS*.

- *PAGE* - percept, actions, goals and environment.
- *PEAS* - performance, environment, actuators and sensors.
