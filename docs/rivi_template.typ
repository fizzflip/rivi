#let rivi_assignment(
  title: "Assignment Title",
  subtitle: "Subtitle or subtitle description",
  author: "Author Name",
  student_name: "Student Name",
  ala_number: "I",
  assignment_name: "Assignment Name",
  repo_url: "https://github.com/fizzflip/rivi",
  series_title: "MOBILE APPLICATION DEVELOPMENT",
  body,
) = {
  // --- DESIGN SYSTEM CONFIGURATION ---
  let primary-color = rgb("000000")
  let secondary-color = rgb("666666")
  let accent-color = rgb("EEEEEE")
  let code-bg = rgb("F7F9FC")

  set document(title: title, author: author)

  set page(
    paper: "a4",
    margin: (left: 25mm, right: 25mm, top: 35mm, bottom: 35mm),
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, 1fr),
          text(8pt, font: "Inter", fill: secondary-color)[#title],
          align(right)[#text(8pt, font: "Inter", fill: secondary-color)[#student_name]],
        )
        v(-5pt)
        line(length: 100%, stroke: 0.5pt + accent-color)
      }
    },
    footer: context {
      if counter(page).get().first() > 1 {
        line(length: 100%, stroke: 0.5pt + accent-color)
        v(5pt)
        align(center)[#text(8pt, font: "Inter", fill: secondary-color)[Page #counter(page).display("1")]]
      }
    },
  )

  set text(font: "Inter", size: 10.5pt, fill: rgb("1A1A1A"))
  set par(leading: 0.7em, justify: true)
  
  // Dynamic numbering function based on ALA number
  set heading(numbering: (..n) => {
    let nums = n.pos()
    [#ala_number.#nums.map(str).join(".")]
  })

  // --- COMPONENT STYLING ---
  show heading.where(level: 1): it => block(
    width: 100%,
    stroke: (bottom: 1pt + accent-color),
    inset: (bottom: 0.5em),
    below: 1.2em,
    above: 2em,
    text(
      font: "New Computer Modern",
      fill: primary-color,
      weight: "regular",
      size: 20pt,
      it,
    ),
  )

  show heading.where(level: 2): it => block(
    below: 0.8em,
    above: 1.5em,
    text(font: "Inter", fill: primary-color, weight: "semibold", size: 12pt, it),
  )

  show raw.where(block: true): it => block(
    fill: code-bg,
    stroke: 1pt + accent-color,
    inset: 12pt,
    radius: 4pt,
    width: 100%,
    breakable: true,
    {
      set text(size: 8.5pt, font: "Fira Code", fill: rgb("333333"))
      it
    },
  )

  // --- COVER PAGE ---
  page(header: none, footer: none)[
    #v(15%)
    #align(center)[
      #text(12pt, weight: "light", tracking: 2pt)[#series_title]
      #v(10pt)
      #line(length: 40%, stroke: 0.5pt + secondary-color)
      #v(20pt)
      #text(42pt, font: "New Computer Modern", weight: "regular")[#title]
      #v(10pt)
      #text(14pt, style: "italic", fill: secondary-color)[#subtitle]
      #v(40pt)

      #block(
        width: 60%,
        stroke: 0.5pt + accent-color,
        inset: 20pt,
        radius: 4pt,
        [
          #align(left)[
            #grid(
              columns: (1fr, 2fr),
              row-gutter: 10pt,
              text(8pt, fill: secondary-color)[STUDENT], text(9pt, weight: "semibold")[#student_name],
              text(8pt, fill: secondary-color)[ALA - #ala_number], text(9pt, weight: "semibold")[#assignment_name],
              text(8pt, fill: secondary-color)[REPOSITORY],
              link(repo_url)[#text(9pt, weight: "semibold")[#{
                let url = repo_url
                if url.starts-with("https://") { url = url.slice(8) }
                url
              }]]
            )
          ]
        ],
      )
    ]
  ]

  pagebreak()
  body
}

// --- UTILITY FUNCTIONS ---

// Styled blocks for definitions
#let defblock(title, body) = block(
  fill: rgb("F7F9FC"),
  stroke: (left: 2pt + rgb("000000")),
  inset: 12pt,
  radius: 2pt,
  width: 100%,
  [
    #text(weight: "bold", size: 9pt, title) \
    #v(2pt)
    #text(size: 9.5pt, body)
  ],
)

// Diagram nodes
#let diagram_node(title, body, fill: white) = block(
  fill: fill,
  stroke: 1pt + rgb("DDDDDD"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  align(center)[
    #text(8pt, weight: "bold", fill: black)[#title] \
    #v(2pt)
    #text(7pt, fill: rgb("666666"))[#body]
  ],
)
