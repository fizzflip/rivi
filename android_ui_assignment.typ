#set document(title: "Mobile App Interface Design", author: "Student Name")

// --- DESIGN SYSTEM CONFIGURATION ---
#let primary-color = rgb("000000")
#let secondary-color = rgb("444444")
#let accent-color = rgb("EEEEEE")
#let code-bg = rgb("F7F9FC")

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 35mm, bottom: 35mm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, 1fr),
        text(8pt, font: "Inter", fill: secondary-color)[Mobile App Interface Design],
        align(right)[#text(
          8pt,
          font: "Inter",
          fill: secondary-color,
        )[Student Name]],
      )
      v(-5pt)
      line(length: 100%, stroke: 0.5pt + accent-color)
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      line(length: 100%, stroke: 0.5pt + accent-color)
      v(5pt)
      align(center)[#text(
        8pt,
        font: "Inter",
        fill: secondary-color,
      )[Page #counter(page).display("1")]]
    }
  },
)

#set text(font: "Inter", size: 10.5pt, fill: rgb("1A1A1A"))
#set par(leading: 0.7em, justify: true)
#set heading(numbering: (..n) => [2.#n.pos().map(str).join(".")])

// --- COMPONENT STYLING ---
#show heading.where(level: 1): it => block(
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

#show heading.where(level: 2): it => block(
  below: 0.8em,
  above: 1.5em,
  text(font: "Inter", fill: primary-color, weight: "semibold", size: 12pt, it),
)

#show raw.where(block: true): it => block(
  fill: code-bg,
  stroke: 1pt + accent-color,
  inset: 15pt,
  radius: 4pt,
  width: 100%,
  breakable: true,
  {
    set text(size: 8.5pt, font: "Fira Code", fill: rgb("333333"))
    it
  },
)

// --- COVER PAGE ---
#page(header: none, footer: none)[
  #v(15%)
  #align(center)[
    #text(12pt, weight: "light", tracking: 2pt)[ANDROID DEVELOPMENT SERIES]
    #v(10pt)
    #line(length: 40%, stroke: 0.5pt + secondary-color)
    #v(20pt)
    #text(42pt, font: "New Computer Modern", weight: "regular")[Mobile App \ Interface Design]
    #v(10pt)
    #text(14pt, style: "italic", fill: secondary-color)[The Psychology of Minimalism in Microlearning]
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
            text(8pt, fill: secondary-color)[STUDENT], text(9pt, weight: "semibold")[Student Name],
            text(8pt, fill: secondary-color)[ASSIGNMENT], text(9pt, weight: "semibold")[02: UI/UX Design Principles],
          )
        ]
      ],
    )
  ]
]

#pagebreak()

= Application Theme & Target Environment

- *Application Context:* Rivi (Minimalist Academic Microlearning)
- *Selected Theme:* "Minimalist Academic" --- Our interface embraces a stark, distraction-free environment. It specifically simulates the psychological state of reading a physical paper document. This means implementing high-contrast black typography against a pure white background, completely omitting saturated color palettes, drop shadows, and complex gradient fills.
- *Screen Size Paradigm:* Architected responsively for modern tall aspect ratios (ranging from standard 16:9 to contemporary 20:9 screens, approximately 6.1" to 6.7" displays).
- *Target Densities:* Calibrated strictly for `xxhdpi` (Extra-Extra-High Density) and `xxxhdpi` displays. High density allows us to use exceptionally thin 1dp stroke containers and crisp serif font structures without sub-pixel blurring.

= Design Principles Followed

The implementation of the visual language heavily hinged on psychological and standardized UI principles:

== Hick's Law & Cognitive Load Reduction
Hick's Law states that the time it takes to make a decision increases logarithmically with the number of choices. By enforcing a strict "distraction-free" interface, the primary dashboard completely omits bottom navigation bars, side-drawers (hamburger menus), and cluttered toolbars. The user is presented with exactly two actionable vectors: review a subject, or create a new one via the Floating Action Button.

== Miller's Law: Chunking for Retention
Miller's Law suggests that an average human can hold $7 plus.minus 2$ items in their working memory. In Rivi, we intentionally limit the display of flashcards and categories to small, manageable "chunks" to ensure that the user's focus remains on the learning material rather than the navigation.

== Typography-Driven Visual Hierarchy
In the absence of color and shadow, typographic contrast dictates the spatial structure of the app. The title operates at `32sp` with a bold weight, acting as the structural anchor.
- *Content Text:* Utilizes formal Serif fonts (e.g., New Computer Modern) to establish an authoritative, textbook-like aesthetic for study material.
- *Structural Text:* Utilizes Sans-Serif fonts (like Inter) for metadata (times, locations, navigation prompts) allowing users to easily distinguish between "what they are studying" and "how they use the app."

== "Flat" Elevation Design (0dp Paradigm)
Contemporary Material Design relies heavily on elevation (Z-axis shadows) to express hierarchy. We opted to abandon this in favor of a strictly 2-Dimensional paradigm. Cards and buttons rest at `0dp` elevation. Content segregation is achieved solely through logical whitespace and subtle `1dp` gray bounding boxes, echoing the physical structure of grid-paper or flashcards.

= Design Challenges Encountered

While minimizing visual noise sounds simple, maintaining practical functionality proved technically challenging:

- *ConstraintLayout Orchestration on Tall Displays:* Anchoring elements relative to each other using `ConstraintLayout` was mandatory to prevent the UI from stretching unattractively or overlapping. Balancing the padding of the `RecyclerView` against the persistent positioning of the Extended FAB required dynamic baseline alignment.
- *Signaling Interactivity within a Flat UI:* When you remove shadows and vibrant button colors, users often struggle to identify what is clickable. We resolved this by relying heavily on custom shape ripples and inverse-color interaction states. For example, the "New Subject" button uses a stark, inverted black background to implicitly signal its priority.

#pagebreak()
= Interface Screenshot

#v(20pt)
#align(center)[
  #box(
    width: 65%,
    clip: true,
    radius: 12pt,
    stroke: 1pt + accent-color,
    [
      #image("rivi_screenshot.jpg", width: 100%)
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: secondary-color,
    style: "italic",
  )[Figure 1: Cropped View of the Main Interface Layout (Rivi App)]
]

#pagebreak()
= XML Code Snippet Implementation

The layout snippet below represents the structural foundation of the interface portrayed above. By leveraging `ConstraintLayout`, we execute the rigorous alignment algorithms required to maintain the minimalist aesthetic dynamically across device configurations.

#v(10pt)
#raw(read("rivi_interface_layout.xml"), lang: "xml")
