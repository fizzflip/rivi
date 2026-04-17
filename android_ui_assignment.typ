#set document(title: "Mobile App Interface Design", author: "Student Name")

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 35mm, bottom: 35mm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, 1fr),
        text(
          8pt,
          font: "Inter",
          fill: rgb("666666"),
        )[Mobile App Interface Design],
        align(right)[#text(
          8pt,
          font: "Inter",
          fill: rgb("666666"),
        )[Student Name]],
      )
      v(-5pt)
      line(length: 100%, stroke: 0.5pt + rgb("EEEEEE"))
    }
  },
  footer: context {
    line(length: 100%, stroke: 0.5pt + rgb("EEEEEE"))
    v(5pt)
    align(center)[#text(
      8pt,
      font: "Inter",
      fill: rgb("666666"),
    )[Page #counter(page).display("1")]]
  },
)

#set text(font: "Inter", size: 10.5pt, fill: rgb("333333"))
#set par(leading: 0.7em)
#set heading(numbering: "I.")

// Clean, sleek, app-like headings
#show heading.where(level: 1): it => block(
  width: 100%,
  stroke: (bottom: 1pt + rgb("EEEEEE")),
  inset: (bottom: 0.5em),
  below: 1em,
  text(
    font: "New Computer Modern",
    fill: rgb("000000"),
    weight: "regular",
    size: 18pt,
    it,
  ),
)

#show heading.where(level: 2): it => block(
  below: 0.8em,
  above: 1.5em,
  text(font: "Inter", fill: rgb("111111"), weight: "semibold", size: 12pt, it),
)

// Title Area
#align(center)[
  #v(30pt)
  #text(
    36pt,
    font: "New Computer Modern",
    fill: black,
    weight: "regular",
  )[Mobile App Interface Design]
  #v(40pt)
]

= Application Theme & Target Environment

- *Application Context:* Rivi (Minimalist Academic Microlearning)
- *Selected Theme:* "Minimalist Academic" --- Our interface embraces a stark, distraction-free environment. It specifically simulates the psychological state of reading a physical paper document. This means implementing high-contrast black typography against a pure white background, completely omitting saturated color palettes, drop shadows, and complex gradient fills.
- *Screen Size Paradigm:* Architected responsively for modern tall aspect ratios (ranging from standard 16:9 to contemporary 20:9 screens, approximately 6.1" to 6.7" displays).
- *Target Densities:* Calibrated strictly for `xxhdpi` (Extra-Extra-High Density) and `xxxhdpi` displays. High density allows us to use exceptionally thin 1dp stroke containers and crisp serif font structures without sub-pixel blurring.

= Design Principles Followed

The implementation of the visual language heavily hinged on psychological and standardized UI principles:

== 1. Hick's Law & Cognitive Load Reduction
Hick's Law states that the time it takes to make a decision increases logarithmically with the number of choices. By enforcing a strict "distraction-free" interface, the primary dashboard completely omits bottom navigation bars, side-drawers (hamburger menus), and cluttered toolbars. The user is presented with exactly two actionable vectors: review a subject, or create a new one via the Floating Action Button.

== 2. Typography-Driven Visual Hierarchy
In the absence of color and shadow, typographic contrast dictates the spatial structure of the app. The title operates at `32sp` with a bold weight, acting as the structural anchor. Crucially, the app splits its font families conceptually:
- *Content Text:* Utilizes formal Serif fonts to establish an authoritative, textbook-like aesthetic for study material.
- *Structural Text:* Utilizes Sans-Serif fonts (like Inter) for metadata (times, locations, navigation prompts) allowing users to easily distinguish between "what they are studying" and "how they use the app."

== 3. "Flat" Elevation Design (0dp Paradigm)
Contemporary Material Design relies heavily on elevation (Z-axis shadows) to express hierarchy. We opted to abandon this in favor of a strictly 2-Dimensional paradigm. Cards and buttons rest at `0dp` elevation. Content segregation is achieved solely through logical whitespace and subtle `1dp` gray bounding boxes, echoing the physical structure of grid-paper or flashcards.

== 4. Target Accessibility & Spacing
All interactive elements, despite their minimalist visual footprint, contain invisible padding constraints ensuring they meet or exceed the standard `48dp x 48dp` Material touch-target guidelines, maximizing ergonomic usability for rapid one-handed engagement.

= Design Challenges Encountered

While minimizing visual noise sounds simple, maintaining practical functionality proved technically challenging:

- *ConstraintLayout Orchestration on Tall Displays:* Anchoring elements relative to each other using `ConstraintLayout` was mandatory to prevent the UI from stretching unattractively or overlapping. Balancing the padding of the `RecyclerView` against the persistent positioning of the Extended FAB required dynamic baseline alignment to handle 16:9 versus ultra-wide 20:9 aspect ratios correctly.
- *Signaling Interactivity within a Flat UI:* When you remove shadows and vibrant button colors, users often struggle to identify what is clickable. We resolved this by relying heavily on custom shape ripples and inverse-color interaction states. For example, the "New Subject" button isn't immediately obvious as a FAB because it lacks a drop-shadow; however, its stark, inverted black background implicitly signals it as a primary interaction node against the white canvas.

#pagebreak()
= Interface Screenshot

#align(center)[
  #v(10pt)
  #box(
    width: 80%,
    height: 380pt,
    clip: true,
    radius: 8pt,
    stroke: 1pt + rgb("DDDDDD"),
    [
      #image("rivi_screenshot.jpg", width: 100%, fit: "cover")
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: rgb("888888"),
    style: "italic",
  )[Figure 1: Cropped View of the Main Interface Layout (Rivi App)]
]

= XML Code Snippet Implementation

The layout snippet below represents the structural foundation of the interface portrayed above. By leveraging `ConstraintLayout`, we execute the rigorous alignment algorithms required to maintain the minimalist aesthetic dynamically across device configurations.

#show raw.where(block: true): it => block(
  fill: rgb("F7F9FC"),
  stroke: 1pt + rgb("EEEEEE"),
  inset: 15pt,
  radius: 8pt,
  width: 100%,
  breakable: true,
  {
    set text(size: 8pt, fill: rgb("333333"))
    it
  },
)

#raw(read("rivi_interface_layout.xml"), lang: "xml")
