#set document(title: "Exploring Android Basics", author: "Student Name")

// --- DESIGN SYSTEM CONFIGURATION ---
#let primary-color = rgb("000000")
#let secondary-color = rgb("666666")
#let accent-color = rgb("EEEEEE")
#let code-bg = rgb("F7F9FC")

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 35mm, bottom: 35mm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, 1fr),
        text(8pt, font: "Inter", fill: secondary-color)[Exploring Android Basics],
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
#set heading(numbering: (..n) => [1.#n.pos().map(str).join(".")])

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

// Styled blocks for definitions
#let defblock(title, body) = block(
  fill: code-bg,
  stroke: (left: 2pt + primary-color),
  inset: 12pt,
  radius: 2pt,
  width: 100%,
  [
    #text(weight: "bold", size: 9pt, title) \
    #v(2pt)
    #text(size: 9.5pt, body)
  ],
)

// --- COVER PAGE ---
#page(header: none, footer: none)[
  #v(15%)
  #align(center)[
    #text(12pt, weight: "light", tracking: 2pt)[ANDROID DEVELOPMENT SERIES]
    #v(10pt)
    #line(length: 40%, stroke: 0.5pt + secondary-color)
    #v(20pt)
    #text(42pt, font: "New Computer Modern", weight: "regular")[Exploring \ Android Basics]
    #v(10pt)
    #text(14pt, style: "italic", fill: secondary-color)[Architecture, Components, and the Rivi Framework]
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
            text(8pt, fill: secondary-color)[ASSIGNMENT], text(9pt, weight: "semibold")[01: Architecture Basics],
          )
        ]
      ],
    )
  ]
]

#pagebreak()

= Introduction to the Android Architecture

At the core of the Android ecosystem lies a sophisticated, multi-layered architecture designed to offer maximum flexibility, security, and hardware abstraction. The foundation is built upon the *Linux Kernel*, which acts as an abstraction layer between the device hardware and the upper software stack, managing core services like memory management, process isolated sandboxing, and device drivers.

Above the kernel sits the *Hardware Abstraction Layer (HAL)* and the *Android Runtime (ART)*. ART utilizes a highly optimized compilation architecture (combining Ahead-of-Time and Just-in-Time compilation) to execute dex bytecode natively, drastically improving app performance and battery efficiency. Higher up, the *Application Framework* exposes Java/Kotlin APIs representing the fundamental building blocks of Android: Activities, Services, and Providers.

#v(10pt)
#defblock(
  "Architectural Goal",
)[The primary objective of this stack is to decouple hardware-specific implementations from the application logic, allowing developers to write "Hardware Agnostic" code that runs consistently across thousands of distinct device configurations.]

= Core Components of the Framework

The Android application framework relies on four highly decoupled operational primitives. These components can be instantiated dynamically and are meticulously tracked by the OS to ensure smooth background continuity and optimized memory usage.

== AndroidManifest.xml: The Application Blueprint
Every Android project must include an `AndroidManifest.xml` file at the root of the project source set. The manifest acts as the definitive blueprint for the OS. It declares the app's structural components—allowing the system to map explicit intents to respective Activities or Services safely. Furthermore, it enforces security by explicitly listing the `uses-permission` tags necessary for hardware access.

== Activities: The Presentation Layer
An `Activity` represents a single, self-contained visual interface. It serves as the bridge between the user and the application data, driven by a strict execution lifecycle. Using *Intents*, Activities communicate context and parameters with each other, forming seamless navigation paths.

== Services: Autonomous Background Execution
When user-facing visual continuity is not required, `Services` are dispatched. They are application components capable of operating robustly in the background, entirely decoupled from the UI thread.
- *Foreground Services:* High-priority operations (e.g., Music Players).
- *Background Services:* Data syncing or cache maintenance (e.g., Syncing flashcards).

== Broadcast Receivers: System-Wide Event Handlers
The OS and individual applications routinely dispatch system-wide events. A `BroadcastReceiver` behaves as an event-listener for these intents, allowing an application to react passively without constantly draining CPU cycles polling for state changes.

== Content Providers: Unified Data Abstraction
Due to Android's strict process isolation, one application cannot access the file directory of another. *Content Providers* mitigate this by acting as a secure interface exposing structured data across the IPC (Inter-Process Communication) boundary via standardized URIs.

#pagebreak()
= Structural Architecture Outline: The Rivi Application

To visually demonstrate these core primitives interacting within a cohesive environment, we utilize the *Rivi* application—a distraction-free, spaced-repetition microlearning platform.

#v(20pt)
#align(center)[
  #block(
    fill: white,
    stroke: 1pt + accent-color,
    radius: 8pt,
    inset: 30pt,
    width: 100%,
    [
      // --- CUSTOM ARCHITECTURE DIAGRAM ---
      #let node(title, body, fill: white) = block(
        fill: fill,
        stroke: 1pt + rgb("DDDDDD"),
        inset: 10pt,
        radius: 4pt,
        width: 100%,
        align(center)[
          #text(8pt, weight: "bold", fill: primary-color)[#title] \
          #v(2pt)
          #text(7pt, fill: secondary-color)[#body]
        ],
      )

      #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 15pt,
        row-gutter: 20pt,

        // Layer 1: Interfaces
        grid.cell(colspan: 3)[
          #node(
            "USER INTERFACE LAYER",
            "MainActivity | StudySessionActivity | CardManagementActivity",
            fill: rgb("FAFAFA"),
          )
        ],

        // Layer 2: Logic
        grid.cell(colspan: 3)[
          #align(center)[#text(10pt)[$arrow.b$]]
        ],

        node("PRESENTATION", "ViewModel & \n LiveData / Flow"),
        node("COMMUNICATION", "Intents & \n Broadcast Receivers"),
        node("LOGIC", "Use Cases & \n Domain Models"),

        // Layer 3: Data
        grid.cell(colspan: 3)[
          #align(center)[#text(10pt)[$arrow.b$]]
        ],

        grid.cell(colspan: 3)[
          #node("REPOSITORY LAYER", "Single Source of Truth abstraction", fill: rgb("F7F9FC"))
        ],

        // Layer 4: Storage
        node("LOCAL STORE", "Room SQLite Database"),
        node("REMOTE", "Cloud Sync Service"),
        node("RESOURCES", "Asset Manager"),
      )
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: secondary-color,
    style: "italic",
  )[Figure 1: Hierarchical Architecture Overview of Rivi]
]

== Diagram Component Analysis

- *User Interface Layer:* The entry point for user interaction, consisting of various Activities mapped to specific microlearning workflows.
- *ViewModel & Presentation:* lifecycle-aware components that manage UI state and survive configuration changes.
- *Inters-Process Communication:* Managed via Intents and Broadcast Receivers to handle external triggers or internal navigation.
- *Repository Layer:* Decouples the UI from the concrete data source, managing the logic for local vs. remote data retrieval.
- *Local Store (Room):* Provides a structured, type-safe interface to the local SQLite database for persistent flashcard storage.
