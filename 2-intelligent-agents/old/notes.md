---
header-includes:
  - \usepackage{fancyhdr}
  - \usepackage{lastpage}
  - \pagestyle{fancy}
  - \fancyfoot[CO,CE]{\thepage\ of \pageref{LastPage}}
mainfont: Helvetica
fontsize: 12pt
urlcolor: cyan
author: Alex
date: Feb 7, 2024
geometry: margin=1.5cm
---
# 2 - Intelligent agents(IA)

Compile diagrams with

```bash
mmdc -e png --scale 3 -i diagram.md 
```

Convert TikZ PDF to PNG:

```bash
convert -density 300 pic.pdf -quality 100 pic.png
```

Convert this markdown doc with:

```bash
pandoc -F mermaid-filter diagram.md -o notes.pdf
```

## ToC

- [2 - Intelligent agents(IA)](#2---intelligent-agentsia)
  - [ToC](#toc)
  - [Intelligent agent](#intelligent-agent)
  - [Intelligent agent types](#intelligent-agent-types)
  - [Intelligence](#intelligence)
  - [BDI agents](#bdi-agents)
  - [IA as a program](#ia-as-a-program)

## Intelligent agent

```{.mermaid format=pdf}
---
title: Intelligent agent idea
---
graph TB
  IA(Intelligent agent)
  E(Environment)

  IA -->|Actions| E
  E -->|"Percepts(with sensors)"| IA
```

```{.mermaid format=pdf}
---
title: Intelligent agent idea Nr. 2
---
graph TB
  O("Operation layer (O), \n e.g. DB")
  I("Intelligence layer (I), \n e.g. searching, planning")
  E("Environment (E)")

  O --> I
  I -->|Automatic actions| E
  E -->|Automatic perception| I

```

We can describe an intelligent agent as a mathematical function which maps perceptions to the specific action:
$$f: P \rightarrow A$$,
where $P$ is a perception set and $A$ is an action set.

![Agent as a function can be seen as a black box](old/pic.png){ width=50% }

Agent is a function that is a black box, i.e. we don't know how it produces its results. An agent receives information from sensors($S$), processes them via function($f$) and returns back an action($A$) to do.

## Intelligent agent types

```{.mermaid format=pdf}
mindmap
  root((Intelligent Agents))
    id)Reasonable(
      Factors
        Agent made actions
        A perception history
          Sensors allow to find better actions
        What agent knows about environment
          How much knowledge to give?
        Action success measurement
          It is hard to find good criteria
          What to measure?
      Types
        Ideally reasonable agent
        All-knowing agent
    id)Autonomous(
      A system that percepts an environment and make actions upon its environment 
        id("Biological system(Animals, humans)")
        id("Computing system(Calculator)")
```

## Intelligence

```{.mermaid format=pdf}
mindmap
  root((Intelligence))
    id)Weak(
      Autonomy
      Action properties
        Reactivity
          Percepts an environment and then reacts to changes
        Proactivity 
          Reacts to environment changes with the desire to reach the goal
      Social abilities
        Is able to communicate
        Is able to collaborate with others
    id)Strong(
      Has human's properties and abilities
```

## BDI agents

```{.mermaid format=pdf}
mindmap
  root((BDI agents))
    Beliefs - Desires - Intentions
    Works on modal logic
      Pretty hard to get stable conclusions 
```

## IA as a program

An agent can be described as a program:

$$
agent = program + architecture(computing \: platform)
$$

```{.mermaid format=pdf}
mindmap
  root((Architecture))
    id)Reactive(
      Sensors + actuators
      Uses **IF...THEN...** rules
    id)Behavioral(
      Result is decentralized
      Used within **Neural networks**
    id)Adviser,Expert(
      Precisely models a problem domain with relations
      Uses a **planner** which is _proactive_
    id)Hybrid(
      Reactive + Adviser
      Creates a plan with the knowledge base
      Uses **IF...THEN...** rules together with the planner
```

Architectural properties can be described with the abbreviations **PAGE** and **PEAS**.

**PAGE** - percept, actions, goals and environment.

**PEAS** - performance, environment, actuators and sensors.
