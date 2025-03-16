#import "@preview/cetz:0.2.2"
#import cetz.plot

#let draw(data, title, length: 13%) = cetz.canvas({
  import cetz.draw: *

  plot.plot(
    axis-style: "school-book", 
    x-tick-step: 2, 
    y-tick-step: 1,
    size: (5, 4),
    legend: "legend.east",
    y-label: [$phi(x)$],
    x-min: -2.5,
    x-max: 2.5,
    y-min: -1.5,
    y-max: 1.5,
    // y-format: y => [#v(0.2em) #y],
    legend-style: (spacing: 0.5, item: (spacing: 2mm)),
    name: "plot",
    data
  )
  // gives a name for the chart
  content(((0, -0.5), "-|", "plot.south"), title)
}, length: length)

#let line-style = (
    mark: none,
    style: (stroke: 2pt + red),
    // mark-style: (stroke: black, fill: white)
)

#let step-data = {
  plot.add(
    ((1, 1), (2, 1)),
    ..line-style
  )
  plot.add(
    ((1, 1), (1, 0)),
    ..line-style
  )
  plot.add(
    ((-2, 0), (1, 0)),
    ..line-style
  )
  plot.add(
    ((1, 0),),
    mark: "o",
    mark-style: (stroke: red + 1pt, fill: white),
    mark-size: 0.5em
  )
}

#let threshold-data = {
  plot.add(
    ((0, 1), (2, 1)),
    ..line-style
  )
  plot.add(
    ((0, 1), (0, -1)),
    ..line-style
  )
  plot.add(
    ((0, -1), (-2, -1)),
    ..line-style
  )
  plot.add(
    ((0, -1),),
    mark: "o",
    mark-style: (stroke: red + 1pt, fill: white),
    mark-size: 0.5em
  )
}

#let sigmoid-data = {
  plot.add(
    domain: (-2, 2),
    (x) => 1/(1 + calc.pow(calc.e, -x)),
    samples: 100,
    ..line-style
  )
}

#let tanh-data = {
  plot.add(
    domain: (-2, 2),
    (x) => (calc.pow(calc.e, 2 * x) - 1) / (calc.pow(calc.e, 2 * x) + 1),
    ..line-style
  )
}

#let threshold = draw(threshold-data, "Threshold function")
#let step = draw(step-data, "Step function")
#let sigmoid = draw(sigmoid-data, "Sigmoid function")
#let tanh = draw(tanh-data, "Tanh function")