
#set page("a4", flipped: true, columns: 2)

#text(size: 2em)[= Exam]

#set text(size: 1.2em)

*Date: 11.06 12:30*

Duration: 4 hours

== Theoretical part

- No use of notes, only memory
- Consists of 5 blocks(In the parentheses the number of notes is indicated)
  + Intelligent agents and their architecture (_See 2, 3, 4_)
  + Logical agents (_See 5, 6_)
  + Uncertain knowledge (_See 7_)
  + Decision systems (_See 8, 9_)
  + Learning (_See 10, 11_)
- There will be given 2 questions to choose for the answer
- Each question gives 2 points, therefore $Sigma = 10$
- The part is weighted with 0.3 for the whole mark

== Practical part

- 4 tasks:
  + Describe a world with the logical statements (_See 5, 6_) [2 points]
    - Given a world of 3x3 or 3x4 with empty squares, need to choose the barriers and rewards in 2 places
    - Need to specify sensors and actions in the natural language
    - Need to translate the actions to the language of logic 
    - Need to create a Knowledge base of at least 5 sentences
    - The agent needs to do an inference with MODUS PONENS, preferably two times in a row
  + Uncertain knowledge and decision making (_See 7, 8, 9_) [2 points]
    - Need to find probabilities for all states where the agent can get in 2 turns
      - The world is stochastic
      - Actions are given
    - Need to draw a stochastic action representation tree
    - Need to calculate an expected utility value
  + Value and policy iteration algorithms (_See 9_) [3 points]
    - Need to do 2 iterations
    - Need to define a policy after each iteration
  + Reinforcement learning (_See 11_) [3 points]
    - Need to generate training sequence by yourself
    - Use a naive learning
    - Create a transition model diagram
    - Use a temporal-difference algorithm
- Overall $Sigma = 10$ points
- Weighted with 0.2 from the whole mark
- *Recommended sequence to do tasks: 4, 2, 3, 1*