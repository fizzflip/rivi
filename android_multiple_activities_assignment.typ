#set document(title: "Developing Multiple Android Activities", author: "Student Name")

// --- DESIGN SYSTEM CONFIGURATION ---
#let primary-color = rgb("000000")
#let secondary-color = rgb("444444")
#let accent-color = rgb("EEEEEE")
#let code-bg = rgb("F7F9FC")

#set page(
  paper: "a4",
  margin: (left: 20mm, right: 20mm, top: 30mm, bottom: 30mm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, 1fr),
        text(8pt, font: "Inter", fill: secondary-color)[Multiple Android Activities],
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

#set text(font: "Inter", size: 10pt, fill: rgb("1A1A1A"))
#set par(leading: 0.6em, justify: true)
#set heading(numbering: (..n) => [3.#n.pos().map(str).join(".")])

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
  inset: 12pt,
  radius: 4pt,
  width: 100%,
  breakable: true,
  {
    set text(size: 7.5pt, font: "Fira Code", fill: rgb("333333"))
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
    #text(42pt, font: "New Computer Modern", weight: "regular")[Multiple \ Android Activities]
    #v(10pt)
    #text(14pt, style: "italic", fill: secondary-color)[Engineering Intent-Based Navigation and Lifecycle Management]
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
            text(8pt, fill: secondary-color)[ASSIGNMENT],
            text(9pt, weight: "semibold")[03: Multi-Activity Architecture],
          )
        ]
      ],
    )
  ]
]

#pagebreak()

= Application Architecture Context

- *Contextual Application:* Rivi (Minimalist Academic Microlearning)
- *Architectural Driver:* Model-View-ViewModel (MVVM) Design Pattern
- *Core Features Elaborated:* Real-world educational applications heavily rely on segregating user workflows into distinct spatial sandboxes. By distributing the user-flow across multiple `Activities`, the application naturally inherits built-in back-stack management handled by the Android OS.

In Rivi, we focus on engineering the explicit mapping between a global navigation dashboard and hyper-focused functional interfaces, bridging them through the strategic dispatch of `Intents` bearing bundled payload data (such as primitive subject identification keys).

= Core Blueprint: AndroidManifest.xml

The manifest serves as the directory for all entry points. Each activity must be registered here to be accessible via Intent dispatching.

#v(10pt)
#raw(read("app/src/main/AndroidManifest.xml"), lang: "xml")

#pagebreak()
= Activity 1: Dashboard (MainActivity)

The `MainActivity` operates as the primary entry gateway. It is responsible for orchestrating global user progression by fetching subjects and allowing navigation to study sessions or management views.

- *Functional Logic:* It observes a Room database via a ViewModel. When a category is clicked, it synthesizes an `Explicit Intent`, attaches a `SubjectID`, and invokes `startActivity()`.

#align(center)[
  #box(width: 50%, clip: true, radius: 8pt, stroke: 1pt + accent-color, [
    #image("rivi_screenshot.jpg", width: 100%)
  ])
]

== Implementation Code
#raw(read("app/src/main/java/me/prasad/study_app/MainActivity.java"), lang: "java")

== Layout Declaration
#raw(read("app/src/main/res/layout/activity_main.xml"), lang: "xml")

#pagebreak()
= Activity 2: Flashcard Study (StudySessionActivity)

This activity facilitates the core "Active Recall" protocol. It abandons lists for a high-intensity, distraction-free card interface.

- *Functional Logic:* It extracts the `SubjectID` from the incoming intent, queries the specific flashcard set, and manages user feedback (Again, Hard, Good, Easy) back to the SR algorithm.

#align(center)[
  #box(width: 50%, clip: true, radius: 8pt, stroke: 1pt + accent-color, [
    #image("rivi_study_screenshot.jpg", width: 100%)
  ])
]

== Implementation Code
#raw(read("app/src/main/java/me/prasad/study_app/ui/StudySessionActivity.java"), lang: "java")

== Layout Declaration
#raw(read("app/src/main/res/layout/activity_study_session.xml"), lang: "xml")

#pagebreak()
= Activity 3: Administration (CardManagementActivity)

Provides CRUD operations for the knowledge graph. It allows users to modify or inject new flashcards into the database.

- *Functional Logic:* Connects to the Room DAO layer directly. It uses a RecyclerView to list existing cards and provides a floating action button for additions.

#align(center)[
  #box(width: 50%, clip: true, radius: 8pt, stroke: 1pt + accent-color, [
    #image("rivi_card_manage_screenshot.jpg", width: 100%)
  ])
]

== Implementation Code
#raw(read("app/src/main/java/me/prasad/study_app/ui/CardManagementActivity.java"), lang: "java")

== Layout Declaration
#raw(read("app/src/main/res/layout/activity_card_management.xml"), lang: "xml")

#pagebreak()
= Activity 4: Session Analytics (SessionRecapActivity)

Bridges the study session and the dashboard, providing positive reinforcement through data visualization.

- *Functional Logic:* Receives accuracy metrics via Intent extras and renders them into progress charts before allowing the user to return home.

#align(center)[
  #box(width: 50%, clip: true, radius: 8pt, stroke: 1pt + accent-color, [
    #image("rivi_session_recap_screenshot.jpg", width: 100%)
  ])
]

== Implementation Code
#raw(read("app/src/main/java/me/prasad/study_app/ui/SessionRecapActivity.java"), lang: "java")

== Layout Declaration
#raw(read("app/src/main/res/layout/activity_session_recap.xml"), lang: "xml")
