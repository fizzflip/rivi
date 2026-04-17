#import "rivi_template.typ": rivi_assignment, defblock, diagram_node

#show: rivi_assignment.with(
  title: "Assignment Title",
  subtitle: "Brief description of the assignment goal",
  student_name: "Student Name",
  ala_number: "IV", // ALA Roman numeral
  assignment_name: "Feature Implementation",
  repo_url: "https://github.com/fizzflip/rivi",
)

= Introduction

Start your assignment here. The template automatically handles:
- Premium Cover Page
- Dynamic Numbering (e.g., 4.1 for ALA-IV)
- Consistent Typography (Inter & New Computer Modern)
- Headers and Footers (starting from page 2)

== Sub-section Example

#defblock("Key Concept")[
  Definitions or important takeaways can be placed inside a `defblock` for higher visual prominence.
]

= Architecture Visualization

You can use the `diagram_node` function within a grid to create architecture diagrams consistent with the previous assignments.

#v(20pt)
#align(center)[
  #block(
    fill: white,
    stroke: 1pt + rgb("EEEEEE"),
    radius: 8pt,
    inset: 30pt,
    width: 100%,
    [
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 15pt,
        row-gutter: 20pt,
        diagram_node("Primary", "Main logic component"),
        diagram_node("Secondary", "Support logic component"),
        grid.cell(colspan: 2)[
          #align(center)[#text(10pt)[$arrow.b$]]
        ],
        grid.cell(colspan: 2)[
          #diagram_node("Storage", "Persistent data layer", fill: rgb("F7F9FC"))
        ],
      )
    ]
  )
]
