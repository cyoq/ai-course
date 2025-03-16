#import "templates/notes-template.typ": notes
#import "@preview/pinit:0.1.4": *
#import "@preview/cetz:0.2.2"
#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx, vlinex, hlinex
#import "@preview/gentle-clues:0.8.0": *
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
  [11. Learning from Examples: NNs and Reinforcement Learning], 
  doc
)

#set text(size: 11pt)

== Artificial neural networks

*Perceptron* - is a single neuron neural network model (@perceptron).

It also represents a *feed-forward* network where input is fed towards the output.

The *recurrent* network can also communicate with the previous layers.

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let nodes = (
      ((0,0), [$I_1$]), 
      ((0,0.5), [$I_2$]),
      ((0,1), [$...$]), 
      ((0,1.55), [$I_n$])
    ),
    for n in nodes {
      let (coords, txt) = n
      node(coords, txt)
    },
    node((0, 2.2), [Input], stroke: none),
    node(enclose: (nodes.map(n => n.at(0))), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    node((1,0.8), [$N$], name: <hidden>),

    for n in nodes {
      edge(n.at(0), <hidden>, "-|>")
    },

    node((1.8, 1.5), [Output], stroke: none),
    node((1.8,0.8), [$O$], name: <output>),
    node(enclose: (<output>), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    edge(<hidden>, <output>, "-|>")
  ),
  caption: [A perceptron]
) <perceptron>

A neuron can be represented as a function in @neuron-model. The model takes inputs ${x_1, x_2, ..., x_n} in X$ and they are calculated in the summation function:
$
  z_i = sum_(j = 1)^n x_j dot w_(j i)
$
where $w_(j i)$ is the weight for the specific input and $z_i$ is the summation result.

After that the result goes to the non-linear activation function $phi$ that calculates the output($hat(y)$) that is called a *prediction*:
$
  hat(y) = phi(z_i) 
$

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let nodes = (
      ((0,0), [$x_1$], [$w_(1i)$]), 
      ((0,0.5), [$x_2$], [$w_(2i)$]),
      ((0,1), [$...$], [$...$]), 
      ((0,1.55), [$x_n$], [$w_(n i)$])
    ),
    for n in nodes {
      let (coords, txt, _) = n
      node(coords, txt, shape: shapes.rect)
    },
    node((0, 2.2), [Input], stroke: none),
    node(enclose: (nodes.map(n => n.at(0))), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    node((1.5,0.8), [$Sigma$], name: <hidden>),

    for n in nodes {
      let (coords, _, weights) = n
      edge(coords, <hidden>, "-|>", weights, label-side: center)
    },

    node((2.3,0.8), [$phi$], name: <activation>),
    // node(enclose: (<output>), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    edge(<hidden>, <activation>, "-|>", [$z_i$]),
    edge(<activation>, (3.3, 0.8), "-|>", [$hat(y)$])
  ),
  caption: [An $i$-th neuron mathematical representation]
) <neuron-model>

=== Activation functions

Activation functions are used to transform the summed weighted input from a node into an output value that is passed on to the next layer.

#import "plots/activations.typ": *

#grid(
  columns: 2,
  column-gutter: 2em,
  [
    *Step function*:
    $
      phi(x) = cases(
        0 "if" x < T \
        1 "if" x >= T
      )
    $
    In the image $T = 1$
  ],
  [
    #step
  ]
)

#grid(
  columns: 2,
  column-gutter: 2em,
  [
    *Threshold function*:
    $
      phi(x) = cases(
        -1 "if" x < 0 \
        1 "if" x >= 0
      )
    $
  ],
  [
    #threshold
  ]
)

#grid(
  columns: 2,
  column-gutter: 2em,
  [
    *Sigmoid function*:
    $
      phi(x) = 1 / (1 + e^(-x))
    $
    *The derivative* is $phi'(x) = phi dot (1 - phi)$
  ],
  [
    #sigmoid
  ]
)

#grid(
  columns: 2,
  column-gutter: 2em,
  [
    *Tanh function*:
    $
      phi(x) = (e^(2x) - 1) / (e^(2x) + 1)
    $
  ],
  [
    #tanh
  ]
)

=== Example

Let's say we want to classify black and white dots in @class-problem. The red dashed line represents a linear function that will do the classification job.

#figure(
  cetz.canvas({
    import cetz.draw: *
    import cetz.plot

    let data = {
      plot.add(
        ((0, 0), (0, 1)),
        mark: "o",
        mark-style: (stroke: black, fill: white),
        style: (stroke: black)
      )
      plot.add(
        ((0, 0), (1, 0)),
        mark: "o",
        mark-style: (stroke: black, fill: white),
        style: (stroke: black)
      )
      plot.add(
        ((1, 1),),
        mark: "o",
        mark-style: (stroke: black, fill: black),
        style: (stroke: black)
      )
      plot.add(
        ((0, 1.4), (1.4, 0)),
        mark: none,
        style: (stroke: (paint: red, dash: "dashed"))
      )
    }

    plot.plot(
      axis-style: "left", 
      x-tick-step: 1, 
      y-tick-step: 1,
      size: (2, 2),
      legend: "legend.east",
      y-label: [$y$],
      x-min: 0,
      x-max: 1.5,
      y-min: 0,
      y-max: 1.5,
      legend-style: (spacing: 0.5, item: (spacing: 2mm)),
      name: "plot",
      data
    )
    // gives a name for the chart
    // content(((0, -0.5), "-|", "plot.south"), "")
  }, length: 10%),
  caption: [An *AND* classification problem]
) <class-problem>

In order to solve this problem, we can use a simple perceptron with the step function(@logical-and).

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let nodes = (
      ((0,0), [$x$], [$w_x = 1$]), 
      ((0,1), [$y$], [$w_y = 1$])
    ),
    for n in nodes {
      let (coords, txt, _) = n
      node(coords, txt, shape: shapes.rect)
    },

    node((2,0.5), [$T = 1.5$], name: <neuron>),

    for n in nodes {
      let (coords, _, weights) = n
      edge(coords, <neuron>, "-|>", weights, label-side: center)
    },

    edge(<neuron>, (3.3, 0.5), "-|>", [$hat(y)$])
  ),
  caption: [Logical *AND* representation with the perceptron]
) <logical-and>

Step function's threshold is $T = 1.5$, in this case we can create a table to check the results:

#figure(
  tablex(
    columns: 5,
    auto-vlines: false,
    align: horizon + center,
    [$x$], [$y$], [$"output"$], [$hat(y)$], [$y$],

    [0], [0], [0], [0], [0],

    [0], [1], [1], [0], [0],

    [1], [0], [1], [0], [0],

    [1], [1], [2], [1], [1],
  ),
  caption: [Check table for *AND* neuron]
)

The similar perceptron model can be created for the logical "OR" function(@logical-or), the only change is in the step function's threshold.

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let nodes = (
      ((0,0), [$x$], [$w_x = 1$]), 
      ((0,1), [$y$], [$w_y = 1$])
    ),
    for n in nodes {
      let (coords, txt, _) = n
      node(coords, txt, shape: shapes.rect)
    },

    node((2,0.5), [$T = 0.5$], name: <neuron>),

    for n in nodes {
      let (coords, _, weights) = n
      edge(coords, <neuron>, "-|>", weights, label-side: center)
    },

    edge(<neuron>, (3.3, 0.5), "-|>", [$hat(y)$])
  ),
  caption: [Logical *AND* representation with the perceptron]
) <logical-or>

However, if we want to separate classes with two lines as in @class-problem-xor, i.e. make an *XOR* operation, then it requires to add an additional neuron to the network.

#figure(
  cetz.canvas({
    import cetz.draw: *
    import cetz.plot

    let data = {
      plot.add(
        ((0, 0), (0, 1)),
        mark: "o",
        mark-style: (stroke: black, fill: white),
        style: (stroke: black)
      )
      plot.add(
        ((0, 0), (1, 0)),
        mark: "o",
        mark-style: (stroke: black, fill: white),
        style: (stroke: black)
      )
      plot.add(
        ((1, 1),),
        mark: "o",
        mark-style: (stroke: black, fill: black),
        style: (stroke: black)
      )
      plot.add(
        ((0, 0),),
        mark: "o",
        mark-style: (stroke: black, fill: black),
        style: (stroke: black)
      )
      plot.add(
        ((0, 1.4), (1.4, 0)),
        mark: none,
        style: (stroke: (paint: red, dash: "dashed"))
      )
      plot.add(
        ((0, 0.5), (0.5, 0)),
        mark: none,
        style: (stroke: (paint: red, dash: "dashed"))
      )
    }

    plot.plot(
      axis-style: "left", 
      x-tick-step: 1, 
      y-tick-step: 1,
      size: (2, 2),
      legend: "legend.east",
      y-label: [$y$],
      x-min: 0,
      x-max: 1.5,
      y-min: 0,
      y-max: 1.5,
      legend-style: (spacing: 0.5, item: (spacing: 2mm)),
      name: "plot",
      data
    )
    // gives a name for the chart
    // content(((0, -0.5), "-|", "plot.south"), "")
  }, length: 10%),
  caption: [An *XOR* classification problem]
) <class-problem-xor>

== Multilayer feed-forward neural networks

The generalized structure can be obtained the following way:

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let input-nodes = (
      ((0,0), [$x_1$], [$w_(13)$], [$w_(14)$]),
      ((0,1), [$x_2$], [$w_(23)$], [$w_(24)$]),
    ),

    let hidden-nodes = (
      ((1, -0.5), [$z_3$], [$w_(35)$]),
      ((1, 1.5), [$z_4$], [$w_(45)$]),
    ),

    for (coords, txt, _, _) in input-nodes {
      node(coords, txt, shape: shapes.rect)
    },

    for (coords, txt, _,) in hidden-nodes {
      node(coords, txt, shape: shapes.circle)
    },

    node((2, 0.5), [$o_5$], shape: shapes.circle, name: <output>),

    node((0, 1.8), [Input layer], stroke: none),
    node(enclose: (input-nodes.map(n => n.at(0))), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    node((1, 2.2), [Hidden layer], stroke: none),
    node(enclose: (hidden-nodes.map(n => n.at(0))), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    node((2, 1.2), [Output layer], stroke: none),
    node(enclose: (<output>,), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    for (coords, _, weight1, weight2) in input-nodes {
      edge(coords, hidden-nodes.at(0).at(0), "-|>", weight1, label-side: center)
      edge(coords, hidden-nodes.at(1).at(0), "-|>", weight2, label-side: center)
    },

    for (coords, _, weight) in hidden-nodes {
      edge(coords, <output>, "-|>", weight, label-side: center)
    },

    edge(<output>, (3, 0.5), "-|>", [$hat(y)$], label-side: center)
  ),
  caption: [General multilayer neural network scheme]
) <general-multilayer>

In @general-multilayer in order to get the $hat(y)$ value, the following calculations must be done:

$
  o_5 = phi(w_(35) dot z_3 + w_(45) dot z_4) \
  z_4 = phi(w_(14) dot x_1 + w_(24) dot x_2) \
  z_3 = phi(w_(13) dot x_1 + w_(23) dot x_2) \
$
where $phi$ is the activation function

The *XOR* problem mentioned previously can be solved with the following network in @xor-solution

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let input-nodes = (
      ((0,0), [$x$], [$-1$], [$-1$]),
      ((0,1), [$y$], [$-1$], [$-1$]),
    ),

    let hidden-nodes = (
      ((1, -0.5), [$z_3$], [$1$]),
      ((1, 1.5), [$z_4$], [$-1$]),
    ),

    for (coords, txt, _, _) in input-nodes {
      node(coords, txt, shape: shapes.rect)
    },

    for (coords, txt, _,) in hidden-nodes {
      node(coords, txt, shape: shapes.circle)
    },

    node((2, 0.5), [$o_5$], shape: shapes.circle, name: <output>),

    node((1, -1.2), [$b = 1$], shape: shapes.rect),
    edge((1, -1.2), hidden-nodes.at(0).at(0), "-|>", $1.5$),

    node((1, 2.2), [$b = 1$], shape: shapes.rect),
    edge((1, 2.2), hidden-nodes.at(1).at(0), "-|>", $0.5$),

    node((2, 1.2), [$b = 1$], shape: shapes.rect),
    edge((2, 1.2), <output>, "-|>", $-0.5$),

    for (coords, _, weight1, weight2) in input-nodes {
      edge(coords, hidden-nodes.at(0).at(0), "-|>", weight1, label-side: center)
      edge(coords, hidden-nodes.at(1).at(0), "-|>", weight2, label-side: center)
    },

    for (coords, _, weight) in hidden-nodes {
      edge(coords, <output>, "-|>", weight, label-side: center)
    },

    edge(<output>, (3, 0.5), "-|>", [$hat(y)$], label-side: center)
  ),
  caption: [A multilayer network solution for *XOR* problem.]
) <xor-solution>

For the network all neurons have a _threshold activation function_:

$
  phi(x) = cases(
    1 "if" x >= 0,
    0 "if" x < 0
  )
$

#figure(
  tablex(
    columns: 9,
    auto-vlines: false,
    align: horizon + center,
    [$x$], [$y$], [$z_3$], [$phi(z_3)$], [$z_4$], [$phi(z_4)$], [$o_5$], [$hat(y)$], [$y$],

    [0], [0], [1.5], [1], [0.5], [1], [-0.5], [0], [0],

    [0], [1], [0.5], [1], [-0.5], [0], [0.5], [1], [1],

    [1], [0], [0.5], [1], [-0.5], [0], [0.5], [1], [1], 

    [1], [1], [-0.5], [0], [-1.5], [0], [-0.5], [0], [0],
  ),
  caption: [Check table for *XOR* operation neural network. _Note_: $phi(o_5) = hat(y)$]
) <tab:xor-check>

#info(title: "Note")[We added the bias to the linear summation. E.g. $z_3 = -1 dot x + -1 dot y + 1.5 dot b$]

== Learning in neural networks

- For the perceptron to learn it needs to get _enough_ examples to learn a linear function.
- _Enough_ examples can be calculated by using Novikov's theorem:
$
  N = D^2/d^2
$
where $D$ is the class set diameter, i.e. the maximum distance between examples, and $d$ is the distance between sets, i.e. the distance between the nearest neighbors(examples) of sets
- Learning happens by sequentially providing examples to the perceptron, then calculating the error and updating the weights.

*Learning process*:

1. Get the output for an example, i.e. predicted value $hat(y)$, from the network
2. Calculate the error: $E = y - hat(y)$, where $y$ is the actual value
3. Update the weights with $w_j ' = w_j + alpha dot x_j dot E$ where $alpha$ is the learning rate, $x_j$ is the input value, $E$ an error
4. Continue the training until all examples are not seen
5. Continue until weights do not change or iteration count is exceeded

=== Learning in the perceptron model

Consider the example of getting predictions on the student's marks:
- $x_1$ - does the student do the assignments(no - 0, yes - 1)
- $x_2$ - does the student go to lections(no - 0, yes - 1)
- $x_3$ - does the student prepare for the exam(no - 0, yes - 1)
- $x_4 = 1$ - is a bias

_Overall_: there are $2^3 = 8$ data points available

_Output_: +1 or -1 for good and results

_Activation function_: Threshold function

#figure(
  tablex(
    columns: 5,
    auto-vlines: false,
    align: horizon + center,
    [$x_1$], [$x_2$], [$x_3$], [$x_4$], [$y$], 

    [0], [0], [0], [1], [1], 

    [1], [0], [0], [1], [1],

    [0], [1], [1], [1], [-1],

    [1], [1], [0], [1], [1]
  ),
  caption: [A training dataset for perceptron]
) <tab:perceptron-train-data>

Let's do some training.  _1st iteration_:

#figure(
  tablex(
    columns: 16,
    align: center + horizon,
    auto-vlines: false,

    vlinex(), rowspanx(2)[*\#*], vlinex(), colspanx(4)[*Input*], vlinex(), colspanx(4)[*Weights*], vlinex(), rowspanx(2)[$z$], vlinex(), rowspanx(2)[$hat(y)$], vlinex(), rowspanx(2)[$y$], vlinex(), colspanx(4)[*New weights*], vlinex(),

    [$x_1$], [$x_2$], [$x_3$], [$x_4$], [$w_1$], [$w_2$], [$w_3$],[$w_4$], [$w_1 '$], [$w_2 '$], [$w_3 '$],[$w_4 '$],
    [1], 
      [0], [0], [0], [1],
        [0], [0], [0], [0],
          [0], [1], [1], 
            [0], [0], [0], [0],

    [2], 
      [1], [0], [0], [1], 
        [0], [0], [0], [0],
          [0], [1], [1],
            [0], [0], [0], [0], 

    [3], 
      [0], [1], [1], [1], 
        [0], [0], [0], [0], 
          [0], [1], [-1],
            [0], [-1], [-1], [-1], 

    [4], 
      [1], [1], [0], [1], 
        [0], [-1], [-1], [-1], 
          [-2], [-1], [1],
            [1], [0], [-1], [0], 

  ),
  caption: [1st iteration of table with perceptron training. _Note_: $z = sum_j^n w_j dot x_j$]
)

Until the 3rd example, no change in weights was necessary. 

*3rd example weights updates*:

_Note_: $alpha = 0.5$

$
  E = y - hat(y) = -1 - 1 = -2 \
  w_1 ' = w_1 + alpha dot x_1 dot E = 0 + 0.5 dot 0 dot (-2) = 0 \
  w_2 ' = w_2 + alpha dot x_2 dot E = 0 + 0.5 dot 1 dot (-2) = -1 \
  w_3 ' = w_3 + alpha dot x_3 dot E = 0 + 0.5 dot 1 dot (-2) = -1 \
  w_4 ' = w_4 + alpha dot x_4 dot E = 0 + 0.5 dot 1 dot (-2) = -1 \
$

*4th example weights updates*:

$
  E = y - hat(y) = 1 - (-1) = 2 \
  w_1 ' = w_1 + alpha dot x_1 dot E = 0 + 0.5 dot 1 dot 2 = 1 \
  w_2 ' = w_2 + alpha dot x_2 dot E = -1 + 0.5 dot 1 dot 2 = 0 \
  w_3 ' = w_3 + alpha dot x_3 dot E = -1 + 0.5 dot 0 dot 2 = -1 \
  w_4 ' = w_4 + alpha dot x_4 dot E = -1 + 0.5 dot 1 dot 2 = 0 \
$

_2nd iteration_:

#figure(
  tablex(
    columns: 16,
    align: center + horizon,
    auto-vlines: false,

    vlinex(), rowspanx(2)[*\#*], vlinex(), colspanx(4)[*Input*], vlinex(), colspanx(4)[*Weights*], vlinex(), rowspanx(2)[$z$], vlinex(), rowspanx(2)[$hat(y)$], vlinex(), rowspanx(2)[$y$], vlinex(), colspanx(4)[*New weights*], vlinex(),

    [$x_1$], [$x_2$], [$x_3$], [$x_4$], [$w_1$], [$w_2$], [$w_3$],[$w_4$], [$w_1 '$], [$w_2 '$], [$w_3 '$],[$w_4 '$],
    [1], 
      [0], [0], [0], [1],
        [1], [0], [-1], [0],
          [0], [1], [1], 
            [1], [0], [-1], [0],

    [2], 
      [1], [0], [0], [1], 
        [1], [0], [-1], [0],
          [1], [1], [1],
            [1], [0], [-1], [0],

    [3], 
      [0], [1], [1], [1], 
        [1], [0], [-1], [0],
          [-1], [-1], [-1],
            [1], [0], [-1], [0],

    [4], 
      [1], [1], [0], [1], 
        [1], [0], [-1], [0],
          [1], [1], [1],
            [1], [0], [-1], [0],
  ),
  caption: [2nd iteration of table with perceptron training. _Note_: $z = sum_j^n w_j dot x_j$]
)

Weights have converged and no change was done.

The final perceptron model:

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let nodes = (
      ((0,0), [$x_1$], [1]), 
      ((0,0.5), [$x_2$], [0]),
      ((0,1), [$x_3$], [-1]), 
      ((0,1.55), [$x_4$], [0])
    ),

    for (coords, txt, _) in nodes {
      node(coords, txt, shape: shapes.rect)
    },

    node((0, 2.2), [Input], stroke: none),
    node(enclose: (nodes.map(n => n.at(0))), inset: 10pt, stroke: teal, fill: teal.lighten(90%)),

    node((1.5,0.8), [$Sigma$], name: <output>),

    for (coords, _, weights) in nodes {
      edge(coords, <output>, "-|>", weights, label-side: center)
    },

    edge(<output>, (2.5, 0.8), "-|>", [$hat(y)$])
  ),
  caption: [Final trained perceptron model]
)

Let's see how it performs. The test data is in @tab:perceptron-test-data.

#figure(
  tablex(
    columns: 5,
    auto-vlines: false,
    align: horizon + center,
    [$x_1$], [$x_2$], [$x_3$], [$x_4$], [$y$], 

    [1], [0], [1], [1], [1], 

    [0], [0], [1], [1], [-1],

    [1], [1], [1], [1], [-1],

    [0], [1], [0], [1], [-1]
  ),
  caption: [A testing dataset for perceptron]
) <tab:perceptron-test-data>

#figure(
  tablex(
    columns: 13,
    align: center + horizon,
    auto-vlines: false,

    vlinex(), rowspanx(2)[*\#*], vlinex(), colspanx(4)[*Input*], vlinex(), colspanx(4)[*Weights*], vlinex(), rowspanx(2)[$z$], vlinex(), rowspanx(2)[$hat(y)$], vlinex(), rowspanx(2)[$y$], vlinex(), rowspanx(2)[Ok?], vlinex(),

    [$x_1$], [$x_2$], [$x_3$], [$x_4$], [$w_1$], [$w_2$], [$w_3$],[$w_4$], 

    [1], 
      [1], [0], [1], [1],
        [1], [0], [-1], [0],
          [0], [1], [1], 
            [+],

    [2], 
      [0], [0], [1], [1], 
        [1], [0], [-1], [0],
          [-1], [-1], [-1],
            [+],

    [3], 
      [1], [1], [1], [1], 
        [1], [0], [-1], [0],
          [0], [1], [-1],
            [-],

    [4], 
      [0], [1], [0], [1], 
        [1], [0], [-1], [0],
          [0], [1], [-1],
            [-],
  ),
  caption: [Results for perceptron testing. _Note_: $z = sum_j^n w_j dot x_j$]
)

The accuracy of the perceptron is only 50%...

\

=== Learning in multilayer model

For the learning of multilayer neural network model, it is needed to use a *backpropagation* algorithm. More on the algorithm see Russell & Norvig's book page 734.

The generalized multilayer network can be represented as in @general-multilayer.

The weight update process for the one hidden layer NN is the following:

#set enum(numbering: "1.a.")

1. Calculate the error:

$
  E = y - hat(y)
$
where $y$ is the actual value, $hat(y)$ - predicted

2. Update the weights for the hidden layer:
  + Get the partial error:
    $ 
      Delta_i = E dot phi'(z_j)
    $
    where $phi'(z_j)$ is the derivative for the activation function, e.g. sigmoid will be calculated as $phi' = phi(1 - phi)$, $z_j$ is the weighted sum with of the neuron
  + Update the weight:
    $
      w_(j i) ' = w_(j i) + alpha dot a_j dot Delta_i
    $
    where $w_(j i)$ is the weight of the $j$-th neuron of the previous layer to the $i$-th neuron of the next layer. $alpha$ is the learning rate.

3. Update the weights for the input layer:
  + Get the partial error:
    $ 
      Delta_j = phi'(z_j) dot sum_i w_(j i) dot Delta_i
    $
  + Update the weight:
    $
      w_(k j) ' = w_(k j) + alpha dot x_k dot Delta_j
    $
    where $x_k$ is the input value

4. Repeat the process for the number of iterations

=== Multilayer learning example

Consider the problem of *XOR* operation, where one weight was modified to create an error:

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let input-nodes = (
      ((0,0), [$x$], [$-1$], [$-1$]),
      ((0,1), [$y$], [$-1$], [$-1$]),
    ),

    let hidden-nodes = (
      ((1, -0.5), [$a_1$], [$-1$]),
      ((1, 1.5), [$a_2$], [$-1$]),
    ),

    for (coords, txt, _, _) in input-nodes {
      node(coords, txt, shape: shapes.rect)
    },

    for (coords, txt, _,) in hidden-nodes {
      node(coords, txt, shape: shapes.circle)
    },

    node((2, 0.5), [$o$], shape: shapes.circle, name: <output>),

    node((1, -1.2), [$b = 1$], shape: shapes.rect),
    edge((1, -1.2), hidden-nodes.at(0).at(0), "-|>", $1.5$),

    node((1, 2.2), [$b = 1$], shape: shapes.rect),
    edge((1, 2.2), hidden-nodes.at(1).at(0), "-|>", $0.5$),

    node((2, 1.2), [$b = 1$], shape: shapes.rect),
    edge((2, 1.2), <output>, "-|>", $-0.5$),

    for (coords, _, weight1, weight2) in input-nodes {
      edge(coords, hidden-nodes.at(0).at(0), "-|>", weight1, label-side: center)
      edge(coords, hidden-nodes.at(1).at(0), "-|>", weight2, label-side: center)
    },

    for (coords, _, weight) in hidden-nodes {
      edge(coords, <output>, "-|>", weight, label-side: center)
    },

    edge(<output>, (3, 0.5), "-|>", [$hat(y)$], label-side: center),

    node((2, -0.8), [This weight was modified \ to make error], shape: shapes.rect, stroke: none),
    edge((1.5, -0.15), "-|>"),
  ),
  caption: [A multilayer network solution for *XOR* problem with one modified weight.]
)

_Note_: Using a sigmoid function

1. Calculate the predicted value:
  $
    z_1 = 1 dot 1.5 + 1 dot (-1) + 1 dot (-1) = -0.5 \
    a_1 = 1 / (1 + e^0.5) = 0.38 \
  $
  $
    z_2 = 1 dot 0.5 + 1 dot (-1) + 1 dot (-1) = -1.5 \
    a_2 = 1 / (1 + e^1.5) = 0.18 \
  $
  $
    z_3 = (-0.5) dot 1 + (-1) dot 0.38 + (-1) dot 0.18 = -1.06 \
    o = 1 / (1 + e^1.06) = 0.26 \
  $

2. There is an error, since $y = 0$, but we predicted $hat(y) = 0.26$, so we need to update the weights. Calculate the error:
  $
    E = y - hat(y) = 0 - 0.26 = -0.26
  $

3. Get the partial error for the output layer:
  $
    Delta_o = E dot g'(o) = -0.26 dot 0.26(1 - 0.26) = -0.05
  $

4. Update weights for the hidden layer:
  + $w_(a_1, o) ' = w_(a_1, o) + alpha dot a_1 dot Delta_o = -1 + 1 dot 0.38 dot (-0.05) = -1.02$
  + $w_(a_2, o) ' = w_(a_2, o) + alpha dot a_2 dot Delta_o = -1 + 1 dot 0.18 dot (-0.05) = -1.01$
  + $w_(b, o) ' = w_(b, o) + alpha dot b dot Delta_o = -0.5 + 1 dot 1 dot (-0.05) = -0.55$

5. Get partial errors for the hidden layer:
  + $Delta_(a_1) = g'(a_1) dot w_(a_1, o) dot Delta_o = a_1(1 - a_1) dot w_(a_1, o) dot Delta_o = 0.38(1 - 0.38) dot -1 dot (-0.05) = 0.012$
    - We have only one edge to the output, therefore no summation!
  + $Delta_(a_2) = g'(a_2) dot w_(a_2, o) dot Delta_o = a_2(1 - a_2) dot w_(a_2, o) dot Delta_o = 0.18(1 - 0.18) dot -1 dot (-0.05) = 0.007$

6. Update the input to hidden layer weights:
  + $w_(x, a_1) ' = w_(x, a_1) + alpha dot x dot Delta_(a_1) = -1 + 1 dot 1 dot 0.012 = -0.988$
  + $w_(x, a_2) ' = w_(x, a_2) + alpha dot x dot Delta_(a_2) = -1 + 1 dot 1 dot 0.007 = -0.993$
  + $w_(y, a_1) ' = w_(y, a_1) + alpha dot y dot Delta_(a_1) = -1 + 1 dot 1 dot 0.012 = -0.988$
  + $w_(y, a_2) ' = w_(y, a_2) + alpha dot y dot Delta_(a_2) = -1 + 1 dot 1 dot 0.007 = -0.993$
  + $w_(b, a_1) ' = w_(b, a_1) + alpha dot b dot Delta_(a_1) = 1.5 + 1 dot 1 dot 0.012 = 1.512$
  + $w_(b, a_2) ' = w_(b, a_2) + alpha dot b dot Delta_(a_2) = 0.5 + 1 dot 1 dot 0.007 = 0.507$

The network after weight updates from the 1st example:

#figure(
  diagram(
    node-stroke: 0.6pt,
    node-fill: white, 
    let input-nodes = (
      ((-0.5,0), [$x$], [$-0.988$], [$-0.993$]),
      ((-0.5,1), [$y$], [$-0.988$], [$-0.993$]),
    ),

    let hidden-nodes = (
      ((1, -0.5), [$a_1$], [$-1.02$]),
      ((1, 1.5), [$a_2$], [$-1.01$]),
    ),

    for (coords, txt, _, _) in input-nodes {
      node(coords, txt, shape: shapes.rect)
    },

    for (coords, txt, _,) in hidden-nodes {
      node(coords, txt, shape: shapes.circle)
    },

    node((2, 0.5), [$o$], shape: shapes.circle, name: <output>),

    node((1, -1.2), [$b = 1$], shape: shapes.rect),
    edge((1, -1.2), hidden-nodes.at(0).at(0), "-|>", $1.512$),

    node((1, 2.2), [$b = 1$], shape: shapes.rect),
    edge((1, 2.2), hidden-nodes.at(1).at(0), "-|>", $0.507$),

    node((2.2, 1.2), [$b = 1$], shape: shapes.rect),
    edge((2.2, 1.2), <output>, "-|>", $-0.55$),

    for (coords, _, weight1, weight2) in input-nodes {
      edge(coords, hidden-nodes.at(0).at(0), "-|>", weight1, label-side: center)
      edge(coords, hidden-nodes.at(1).at(0), "-|>", weight2, label-side: center)
    },

    for (coords, _, weight) in hidden-nodes {
      edge(coords, <output>, "-|>", weight, label-side: center)
    },

    edge(<output>, (3, 0.5), "-|>", [$hat(y)$], label-side: center),
  ),
  caption: [A multilayer network solution for *XOR* problem after weight update with 1 example]
)

- The speed of learning is very slow, since weight corrections are minimal.
- The next step is to take the second example and repeat the weight update process once again until all 4 examples are met, after that the first iteration will be done.

\

== Reinforcement Learning

_Learning tasks:_

1. Environment can be accessible or inaccessible(the agent needs to store the inner state)
2. The agent can start with the knowledge about the environment and actions, or this model should learned the same way as the utilities
3. Rewards can be given in the end or any other states
4. Rewards can be a part of the utility component(e.g. money, points in the game) that is tried to be maximized, or it could be a direction to the real utility, e.g. a "good move".
5. The agent can be a passive learner, which follows the world and learns the utilities. Or it can be an active learner, which uses learned information and can create new problems to explore the environment

_Reinforcement learning directions_:

1. The agent learns the *utility-based function* which allows to choose the maximum result action. That is in utility-based agent.
2. The agent learns *action-utility-based function* which gives an expected utility, if the action chosen in the current state. That is *Q-learning*.
3. The reflex agent learns *policy* that maps states to actions.

== Passive learning in accessible environment

=== Conditions

- We use a *naive* approach to update the utilities
- The game is the same 4x3 stochastic environment as used before(@fig:starting-state).
- $R(s) = -0.04$

#figure(
  grid(
    columns: 2,
    image("tikz/naive-algorithm/naive-algorithm-0.png"),
    image("tikz/move-model/move-model-0.png")
  ),
  caption: [The environment starting state and the transition model]
) <fig:starting-state>

=== Starting policy

Let's imagine that the agent uses the following policy $pi$ from the start to learn utility function $U^pi (s)$:

#figure(
  image("tikz/naive-algorithm/naive-algorithm-1.png", width: 60%),
  caption: [Starting policy],
)

=== Training examples

To learn the new policy, the agent needs some examples. We will use the following 5 sequences of actions in the table as the learning examples. These sequences were generated by using the generated policy $pi$ before. 

#v(3em)

#tablex(
  columns: 2,
  auto-vlines: false,
  align: horizon + center,
  [*\#*], [*Sequence*],

    [1], [$(1,1) -> (1, 2) -> (1,3) -> (1,2) -> (1,3) -> (2, 3) -> (3, 3) -> (4,3)$],
    [2], [$(1,1) -> (1, 2) -> (1,3) -> (2,3) -> (3,3) -> (3, 2) -> (3, 3) -> (4,3)$],
    [3], [$(1,1) -> (2, 1) -> (3,1) -> (3,2) -> (4,2)$],
    [4], [$(1,1) -> (2, 1) -> (3,1) -> (4,1) -> (3,1) -> (3, 2) -> (3, 3) -> (4,3)$],
    [5], [$(1,1) -> (2, 1) -> (3,1) -> (2,1) -> (3,1) -> (4, 1) -> (4, 2)$],
)

=== Naive approach

- We will go backwards through the sequence, each time adding the $R(s)$ to the final score. 
- If the action was met several times, we take an average of it
- We go through each training example one by one

1. $(1,1)_(U=0.72) -> #pin(1) (1, 2)_(U=0.76) #pin(2) -> #pin(3) (1,3)_(U=0.80) #pin(4) -> #pin(5) (1,2)_(U=0.84) #pin(6) -> #pin(7) (1,3)_(U=0.88) #pin(8) -> (2, 3)_(U=0.92) -> (3, 3)_(U=0.96) -> (4,3)_(U=1)$
  - Two states are repeated, therefore we use an average value:
    - $U(1,2) = (0.76 + 0.84) / 2 = 0.80$
    - $U(1,3) = (0.88 + 0.80) / 2 = 0.84$

#let pinit-high-settings = (extended-height: 1.3em, dy: -0.5em)
#let pinit-green = rgb(0, 255, 0, 20)
#pinit-highlight(1, 2, ..pinit-high-settings )
#pinit-highlight(3, 4, fill: pinit-green, ..pinit-high-settings)
#pinit-highlight(5, 6, ..pinit-high-settings)
#pinit-highlight(7, 8, fill: pinit-green, ..pinit-high-settings)

#figure(
  image("tikz/naive-algorithm/naive-algorithm-2.png", width: 50%),
  caption: [First example results],
)

2. $(1,1)_(U=0.72) -> (1, 2)_(U=0.76) -> (1,3)_(U=0.80) -> (2,3)_(U=0.84) -> #pin(21) (3,3)_(U=0.88) #pin(22) -> (3,2)_(U=0.92) -> #pin(23) (3, 3)_(U=0.96) #pin(24) -> (4,3)_(U=1)$
  - Utilities from previous calculation are also used to get averaged:
    - $U(1, 1) = 0.72$
    - $U(1, 2) = (0.76 + 0.80) / 2 = 0.78$
    - $U(1, 3) = (0.84 + 0.80) / 2 = 0.82$
    - $U(2, 3) = (0.84 + 0.92) / 2 = 0.88$
    - $U(3, 3) = (((0.88 + 0.96) / 2) + 0.96) / 2 = 0.94$

#pinit-highlight(21, 22, ..pinit-high-settings )
#pinit-highlight(23, 24, ..pinit-high-settings)

#figure(
  image("tikz/naive-algorithm/naive-algorithm-3.png", width: 50%),
  caption: [Second example results],
)

3. $(1,1)_(U=-1.16) -> (2_1)_(U=-1.12) -> (3,1)_(U=-1.08) -> (3,2)_(U=-1.04) -> (4,2)_(U=-1)$
  - We will omit average calculations from previous examples

#figure(
  image("tikz/naive-algorithm/naive-algorithm-4.png", width: 50%),
  caption: [Third example results],
)

4. $(1,1)_(U=0.72) -> (2, 1)_(U=0.76) -> #pin(41) (3, 1)_(U=0.80) #pin(42) -> (4, 1)_(U=0.84) -> #pin(43) (3, 1)_(U=0.88) #pin(44) -> (3,2)_(U=0.92) -> (3, 3)_(U=0.96) -> (4,3)_(U=1)$

#pinit-highlight(41, 42, ..pinit-high-settings )
#pinit-highlight(43, 44, ..pinit-high-settings)

#figure(
  image("tikz/naive-algorithm/naive-algorithm-5.png", width: 50%),
  caption: [Fourth example results],
)

5. $(1,1)_(U=-1.24) -> #pin(51) (2, 1)_(U=-1.20) #pin(52) -> #pin(53) (3, 1)_(U=-1.16) #pin(54) -> #pin(55) (2,1)_(U=-1.12) #pin(56) -> #pin(57) (3,1)_(U=-1.08) #pin(58) -> (4,1)_(U=-1.04) -> (4,2)_(U=-1)$

#pinit-highlight(51, 52, ..pinit-high-settings )
#pinit-highlight(53, 54, fill: pinit-green, ..pinit-high-settings)
#pinit-highlight(55, 56, ..pinit-high-settings)
#pinit-highlight(57, 58, fill: pinit-green, ..pinit-high-settings)

#figure(
  image("tikz/naive-algorithm/naive-algorithm-6.png", width: 50%),
  caption: [Fifth example results],
)

After 5 examples, we get the end policy that is very close to the optimal policy that was found in the complex decision works.

Take into account that (4, 1) is not completely solved and it is indifferent of choosing either of directions. More examples can make it more decisive.

#figure(
  image("tikz/naive-algorithm/naive-algorithm-7.png", width: 50%),
  caption: [The policy after 5 examples],
)

#info(title: [Note])[
  The utility is defined to be the expected sum of (discounted) rewards obtained if policy $pi$ is followed as in equation:
  $
    U^pi (s) = EE [ sum_(t = 0)^infinity alpha^t R(S_t)]
  $
]

=== Direct utility estimation

Direct utility estimation succeeds in reducing the reinforcement learning problem to an inductive learning problem, about which much is known.

The utility values obey the Bellman equations for a fixed policy:

$
  U^pi (s) = R(s) + alpha dot sum_s' P(s' | s, pi(s)) dot U^pi (s')
$
where $P(s' | s,pi(s))$ can also be represented as the transition matrix $M_(s, s')$

The transition model can also be represented as a graph:

#figure(
  image("tikz/transition-model/transition-model.png"),
  caption: [A transition model for the 4x3 world problem],
)

It allows to get the following system of equations:

$
  cases(
    U(1, 1) = -0.04 + 0.4 dot U(1,2) + 0.6 dot U(2,1) \
    U(1, 2) = -0.04 + U(1,3) \
    U(1, 3) = -0.04 + 0.33 dot U(1,2) + 0.67 dot U(2,3) \
    U(2, 1) = -0.04 + U(3, 1) \
    U(2, 3) = -0.04 + U(3, 3) \
    U(3, 1) = -0.04 + 0.2 dot U(2, 1) + 0.4 dot U(3, 2) \
       + 0.4 dot U(4, 1) \
    U(3, 2) = -0.04 + 0.67 dot U(3, 3) + 0.33 dot U(4, 2) \
    U(3, 3) = -0.04 + 0.25 dot U(3, 2) + 0.75 dot U(4, 3) \
    U(4, 1) = -0.04 + 0.5 dot U(3, 1) + 0.5 dot U(4,2) \
    U(4, 2) = -1\
    U(4, 3) = 1
  )
$

The system can be solved, for example, with the _Gauss elimination method_.

=== Temporal difference learning

- The main idea is to limit local limits of each transition
- It is described with:

$
  U^pi (s) = U^pi (s) + alpha(R(s) + U^pi (s') - U^pi (s))
$
where $alpha$ is the learning rate

Let's try this approach with 5 examples and $alpha = 0.5$

1. $(1,1) -> (1, 2) -> (1,3) -> (1,2) -> (1,3) -> (2, 3) -> (3, 3) -> (4,3)$
  $
    U(3, 3) = 0 + 0.5 dot (-0.04 + 1 - 0) = 0.48
  $
  $
    U(2, 3) = 0 + 0.5 dot (-0.04 + 0.48 - 0) = 0.22
  $
  $
    U(1, 3) = 0 + 0.5 dot (-0.04 + 0.22 - 0) = 0.09
  $
  $
    U(1, 2) = 0 + 0.5 dot (-0.04 + 0.09 - 0) = 0.025
  $
  $
    U(1, 3) = #pin("1t1") 0.09 #pin("1t2") + 0.5 dot (-0.04 + 0.025 - 0.09) = 0.0375
  $
  $
    U(1, 2) = 0.025 + 0.5 dot (-0.04 + 0.0375 - 0.025) = 0.0112
  $
  $
    U(1, 1) = 0 + 0.5 dot (-0.04 + 0.0112 - 0) = -0.0144
  $

#pinit-highlight-equation-from(("1t1", "1t2"), "1t2", height: 3em, pos: top, fill: rgb(255, 0, 0, 100))[
  Previous value of $U(1,3)$
]

#figure(
  image("tikz/temporal-difference/temporal-difference-0.png", width: 60%),
  caption: [Results after 1st example],
) 

2. $(1,1) -> (1, 2) -> (1,3) -> (2,3) -> (3,3) -> (3, 2) -> (3, 3) -> (4,3)$
  $
    U(3, 3) = 0.48 + 0.5 dot (-0.04 + 1 - 0.48) = 0.72
  $
  $
    U(3, 2) = 0 + 0.5 dot (-0.04 + 0.72 - 0) = 0.34
  $
  $
    U(3, 3) = 0.72 + 0.5 dot (-0.04 + 0.34 - 0.72) = 0.51
  $
  $
    U(2, 3) = 0.22 + 0.5 dot (-0.04 + 0.51 - 0.22) = 0.345
  $
  $
    U(1, 3) = 0.0375 + \
    + 0.5 dot (-0.04 + 0.345 - 0.0375) = 0.1713
  $
  $
    U(1, 2) = 0.0112 + \
    + 0.5 dot (-0.04 + 0.1713 - 0.0112) = 0.0713
  $
  $
    U(1, 1) = -0.0144 + \
     + 0.5 dot (-0.04 + 0.0713 - (-0.0144)) = 0.0084
  $

#figure(
  image("tikz/temporal-difference/temporal-difference-1.png", width: 60%),
  caption: [Results after 2nd example],
) 

Doing these operations for all five examples we receive the final utilities and the policy $pi$:

#figure(
  grid(
    columns: 2,
    image("tikz/temporal-difference/temporal-difference-2.png", width: 100%),
    image("tikz/temporal-difference/temporal-difference-3.png", width: 100%),
  ),
  caption: [Utilities and policy after 5 examples],
) 

The training gave a good result in comparison to the optimal policy.

#info[This is the end of the course]