#set document(
  title: "Developing Multiple Android Activities",
  author: "Student Name",
)

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
        )[Multiple Android Activities],
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

// Code block styling
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

// Title Area
#align(center)[
  #v(30pt)
  #text(
    36pt,
    font: "New Computer Modern",
    fill: black,
    weight: "regular",
  )[Multiple Android Activities]
  #v(40pt)
]

= Application Architecture Context

- *Contextual Application:* Rivi (Minimalist Academic Microlearning)
- *Architectural Driver:* Model-View-ViewModel (MVVM) Design Pattern
- *Core Features Elaborated:* Real-world educational applications heavily rely on segregating user workflows into distinct spatial sandboxes. By distributing the user-flow across multiple `Activities`, the application naturally inherits built-in back-stack management handled seamlessly by the OS. In this scope, we focus on engineering the explicit mapping between a global navigation dashboard surface and a hyper-focused study interface, bridging them through the strategic dispatch of `Intents` bearing bundled payload data (such as primitive subject identification keys).

= Activity Phase 1: Dashboard Interface (MainActivity)

The `MainActivity` operates as the singular entry gateway (defined as `ACTION_MAIN` and `CATEGORY_LAUNCHER` in the manifest). It is structurally responsible for orchestrating global user progression.

- *Functional Elaboration:* The primary operational logic within this activity involves establishing an observable connection to the local Room database via its ViewModel. It retrieves the saved subject matrices asynchronously on background IO threads to prevent UI-stutter, rendering them via a customized `RecyclerView` layout manager. When a user wishes to interact with a specific domain, the `MainActivity` intercepts the `onClick` event and synthesizes an `Explicit Intent`. It attaches the targeted `SubjectID` to the intent's extras bundle, subsequently initiating the hand-off procedure via `startActivity()`.

#align(center)[
  #v(10pt)
  #box(
    width: 75%,
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
  )[Figure 1: Cropped View of the Dashboard Operations]
]

#pagebreak()
= Activity Phase 2: Active Recall Protocol (StudySessionActivity)

The `StudySessionActivity` diverges significantly from the dashboard format. It abandons lists and structural navigation mechanics, embracing a highly constrained, distraction-free flashcard interface that fills the entire viewport matrix.

- *Functional Elaboration:* Upon initialization (`onCreate()`), this activity instantly unpacks the incoming `Intent` bundle to securely extract the targeted `SubjectID`. Instead of loading all data globally, it exclusively queries the persistence layer for flashcards localized entirely into the "Smart 5" daily review limits. It then manages the localized feedback loops—capturing user metric inputs (Again, Hard, Good, Easy) and dispatching them structurally back through the ViewModel to update the specific Spaced Repetition (SM-2) scheduling integers within the local store.

#align(center)[
  #v(10pt)
  #box(
    width: 75%,
    height: 380pt,
    clip: true,
    radius: 8pt,
    stroke: 1pt + rgb("DDDDDD"),
    [
      #image("rivi_study_screenshot.jpg", width: 100%, fit: "cover")
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: rgb("888888"),
    style: "italic",
  )[Figure 2: Cropped View of the Distraction-Free Flashcard Mode]
]

#pagebreak()
= Activity Phase 3: Content Administration (CardManagementActivity)

The `CardManagementActivity` is the operational interface specifically crafted to facilitate Create, Read, Update, and Delete (CRUD) dynamics for the application's core knowledge graphs.

- *Functional Elaboration:* This component is instantiated via an `Intent` that carries necessary hierarchical parameters (i.e. to which Subject these flashcards belong). It provisions a scrolling linear layout mapped inversely to the database via Room DAOs. It supports real-time form inputs, allowing users to modify existing cards or inject new learning material directly into the local SQLite persistence layer which instantly synchronizes with the `MainActivity` state upon finish.

#align(center)[
  #v(10pt)
  #box(
    width: 75%,
    height: 380pt,
    clip: true,
    radius: 8pt,
    stroke: 1pt + rgb("DDDDDD"),
    [
      #image("rivi_card_manage_screenshot.jpg", width: 100%, fit: "cover")
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: rgb("888888"),
    style: "italic",
  )[Figure 3: Cropped View of the Card Management Matrix]
]

#pagebreak()
= Activity Phase 4: Session Analytics (SessionRecapActivity)

Following the completion of an active recall phase, the navigation flow inherently delegates control dynamically to the `SessionRecapActivity`.

- *Functional Elaboration:* Instead of abruptly terminating user engagement, this activity bridges the conclusion of studying and returning to the dashboard. The `StudySessionActivity` invokes this via an explicit parameter launch, passing session accuracy metrics inside the Intent bundle. The `SessionRecapActivity` extracts these parameters formatting them into elegant progress telemetry (e.g. studying intensity, percentage accuracy) reinforcing learning behaviors before safely popping the activity stack and routing the user safely back home.

#align(center)[
  #v(10pt)
  #box(
    width: 75%,
    height: 380pt,
    clip: true,
    radius: 8pt,
    stroke: 1pt + rgb("DDDDDD"),
    [
      #image("rivi_session_recap_screenshot.jpg", width: 100%, fit: "cover")
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: rgb("888888"),
    style: "italic",
  )[Figure 4: Cropped View of the Analytics Summary]
]

#pagebreak()
= Artifact 1: Core Dashboard Implementation

Below is the structured Java architecture that bounds the UI logic for `MainActivity.java`.

#raw(
  read("app/src/main/java/me/prasad/study_app/MainActivity.java"),
  lang: "java",
)

#pagebreak()
= Artifact 2: Active Recall Logic Implementation

Below is the structured Java architecture encompassing the UI operations within `StudySessionActivity.java`.

#raw(
  read("app/src/main/java/me/prasad/study_app/ui/StudySessionActivity.java"),
  lang: "java",
)

#pagebreak()
= Artifact 3: Card Administration Flow
Below is the Java architecture defining the `CardManagementActivity`.

#raw(
  read("app/src/main/java/me/prasad/study_app/ui/CardManagementActivity.java"),
  lang: "java",
)

#pagebreak()
= Artifact 4: Session Analytics Handler
Below is the Java implementation controlling the `SessionRecapActivity` lifecycle.

#raw(
  read("app/src/main/java/me/prasad/study_app/ui/SessionRecapActivity.java"),
  lang: "java",
)
