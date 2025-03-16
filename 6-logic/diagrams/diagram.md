# Diagrams

Compile diagrams with

```bash
mmdc -e png --scale 3 -i diagram.md 
```

Convert TikZ PDF to PNG:

```bash
convert -density 300 pic.pdf -quality 100 pic.png
```

```mermaid
graph LR
  ask(ASK)
  tell1(TELL)
  tell2(TELL)

  ask -->|Perception| tell1
  tell1 -->|What action| tell2
  tell2 -->|Action| Agent
```


```mermaid
mindmap
  root((IA types))
    id)1.Simple reflex agents(
      Reactive
      Based on the table actions
      Models input/output with production rules **IF**...**THEN**
      Has small usage
    id)2.Model-based agents(
      Reactive
      Hard to create world evolvement function
    id)3.Goal-based agents(
      Proactive
      Can achieve one goal only
    id)4.Utility agents(
      Proactive
      Can work with multiple goals
```
