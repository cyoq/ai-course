#let notes(title, doc) = {
  set text(size: 14pt)

  set heading(numbering: (..nums) => {
    let nums = nums.pos()
    if nums.len() != 1 {
      // lower levels are numbered from level 2
      numbering("1.", ..nums.slice(1))
    }
    // level 1 is automatically none
  })

  set page(
    flipped: true,
    margin: (bottom: 1.5cm, top: 1.5cm, right: 1.5cm, left: 1.5cm),
    footer: [
      #set align(center)
      #set text(12pt)
      #counter(page).display("1 of 1", both: true)
    ]
  )

  show raw.where(lang: "pseudo"): it => {

    show regex("(let|function|return)"): itr => {
      [*#itr*]
    }

    show regex("\\$.+\\$"): itr => { 
      set text(size: 14pt)
      $#eval(itr.text)$
    }
    [#it]
  }

  columns(3)[
    #align(center)[
      #show heading.where(level: 1): h => [
        #set text(20pt)
        #h
      ]

      = #title

      By: Alex S.

      Feb, 2024
    ]

    #doc
  ]
}