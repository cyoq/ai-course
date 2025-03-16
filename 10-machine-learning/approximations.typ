#import "@preview/cetz:0.2.2"

// Could have used a function that receives data and chart name, but it does not matter now
#figure(
  grid(
    rows: 2,
    row-gutter: 5mm,
    [
      #grid(
        columns: 2,
        column-gutter: 15mm,
        [
          #cetz.canvas({
            import cetz.draw: *
            import cetz.plot

            let data = {
              plot.add(
                ((1, 1), (2, 2), (3, 3)),
                mark: "o",
                style: (stroke: red),
                mark-style: (stroke: black, fill: white)
              )
            }

            plot.plot(
              axis-style: "school-book", 
              x-tick-step: 1, 
              y-tick-step: 1,
              size: (5, 4),
              legend: "legend.east",
              x-min: -1,
              x-max: 4,
              y-min: -1,
              y-max: 4,
              legend-style: (spacing: 0.5, item: (spacing: 2mm)),
              name: "plot",
              data
            )
            // gives a name for the chart
            content(((0, -0.5), "-|", "plot.south"), "a) Linear function")
          }, length: 20%)
        ],
        [
          #cetz.canvas({
            import cetz.draw: *
            import cetz.plot

            let data = {
              plot.add(
                ((1, 1), (2, 2), (3, 3)),
                mark: "o",
                line: "hvh",
                style: (stroke: red),
                mark-style: (stroke: black, fill: white)
              )
            }

            plot.plot(
              axis-style: "school-book", 
              x-tick-step: 1, 
              y-tick-step: 1,
              size: (5, 4),
              legend: "legend.east",
              x-min: -1,
              x-max: 4,
              y-min: -1,
              y-max: 4,
              legend-style: (spacing: 0.5, item: (spacing: 2mm)),
              name: "plot",
              data
            )
            // gives a name for the chart
            content(((0, -0.5), "-|", "plot.south"), "b) Some discrete function")
          }, length: 20%)
        ],
      )
    ],
    [
      #align(center)[
        #cetz.canvas({
          import cetz.draw: *
          import cetz.plot

          let data = {
            plot.add(
              ((1, 1), (2, 2), (3, 3)),
              mark: "o",
              style: (stroke: white),
              mark-style: (stroke: black, fill: white)
            )
            plot.add(
              ((1, 1), (2, 2), (4, 1)),
              mark: none,
              line: "spline",
              style: (stroke: red),
            )
          }

          plot.plot(
            axis-style: "school-book", 
            x-tick-step: 1, 
            y-tick-step: 1,
            size: (5, 4),
            legend: "legend.east",
            x-min: -1,
            x-max: 4,
            y-min: -1,
            y-max: 4,
            legend-style: (spacing: 0.5, item: (spacing: 2mm)),
            name: "plot",
            data
          )
          // gives a name for the chart
          content(((0, -0.5), "-|", "plot.south"), "c) Inconsistent function")
        }, length: 8%)
      ]
    ]
  ),
  caption: [Several graphs that show that the function can be approximated in different ways. Example a) represents a linear relation. Example b) shows discrete relations. The c) example shows inconsistent behavior which cannot be used for hypothesis, because not all examples points are taken into account. ]
)

// graph drawing
// #cetz.canvas({
//   import cetz.draw: *
//   import cetz.plot

//   let data = {
//     plot.add(
//       domain: (-calc.pi, calc.pi), 
//       calc.sin,
//       samples: 150,
//       label: "sin(x)"
//     )
//     plot.add(
//       domain: (-calc.pi, calc.pi), 
//       calc.cos,
//       // x => (x / 2),
//       // mark: "+", 
//       samples: 150,
//       label: "cos(x)"
//     )
//   }

//   plot.plot(
//     axis-style: "school-book", 
//     x-tick-step: 1, 
//     y-tick-step: 1,
//     size: (8, 3),
//     legend: "legend.east",
//     legend-style: (spacing: 0.5, item: (spacing: 2mm)),
//     name: "plot",
//     data
//   )
//   // gives a name for the chart
//   content(((0, -1), "-|", "plot.south"), "My chart")
//   // set-origin((3.5, 0))
// }, length: 10%)