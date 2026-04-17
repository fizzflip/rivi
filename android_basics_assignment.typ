#set document(title: "Exploring Android Basics", author: "Student Name")

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 35mm, bottom: 35mm),
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, 1fr),
        text(8pt, font: "Inter", fill: rgb("666666"))[Exploring Android Basics],
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
    font: "Linux Libertine",
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
    font: "Linux Libertine",
    fill: black,
    weight: "regular",
  )[Exploring Android Basics]
  #v(40pt)
]

= Introduction to the Android Architecture

At the core of the Android ecosystem lies a sophisticated, multi-layered architecture designed to offer maximum flexibility, security, and hardware abstraction. The foundation is built upon the *Linux Kernel*, which acts as an abstraction layer between the device hardware and the upper software stack, managing core services like memory management, process isolated sandboxing, and device drivers.

Above the kernel sits the *Hardware Abstraction Layer (HAL)* and the *Android Runtime (ART)*. ART utilizes a highly optimized compilation architecture (combining Ahead-of-Time and Just-in-Time compilation) to execute dex bytecode natively, drastically improving app performance and battery efficiency. Higher up, the *Application Framework* exposes Java/Kotlin APIs representing the fundamental building blocks of Android: Activities, Services, and Providers, which developers harness to build robust user applications.

= Core Components of the Framework

The Android application framework relies on four highly decoupled operational primitives. These components can be instantiated dynamically and are meticulously tracked by the OS to ensure smooth background continuity and optimized memory usage.

== AndroidManifest.xml: The Application Blueprint
Every Android project must include an `AndroidManifest.xml` file at the root of the project source set. The manifest acts as the definitive blueprint for the OS. It declares the app's structural components—allowing the system to map explicit intents to respective Activities or Services safely. Furthermore, it enforces security by explicitly listing the `uses-permission` tags necessary for hardware access (such as network states or camera hardware) and registers external libraries and runtime minimum API parameters essential for Google Play filtering.

== Activities: The Presentation Layer
An `Activity` represents a single, self-contained visual interface. It serves as the bridge between the user and the application data, driven by a strict execution lifecycle:
- *onCreate():* The initialization phase where the UI layout (XML) is inflated via `setContentView()` and data bindings are established.
- *onStart() / onResume():* The progression of the UI becoming visible and fully interactive to the user.
- *onPause() / onStop() / onDestroy():* The teardown phase triggered by system interrupts, memory pressures, or explicit termination, mandating developers to strictly save user state.

Using *Intents*, Activities communicate context and parameters with each other, forming seamless navigation paths (e.g., transitioning from a list of folders to a specific study session).

== Services: Autonomous Background Execution
When user-facing visual continuity is not required, `Services` are dispatched. They are application components capable of operating robustly in the background, entirely decoupled from the UI thread.
- *Foreground Services* execute high-priority operations that the user must remain actively aware of, mandated by an ongoing system tray notification (such as a music player or an active fitness tracker).
- *Background Services* perform lower-priority data syncing or cache invalidation when the device sits idle, often heavily scheduled to prevent systemic battery drain via the `WorkManager` API.

== Broadcast Receivers: System-Wide Event Handlers
The OS and individual applications routinely dispatch system-wide events. A `BroadcastReceiver` behaves essentially as an event-listener for these intents. For example, a receiver could be registered dynamically to trigger specific logic whenever the device boot sequence is completed or the battery drops to a critical threshold, effectively allowing an application to react passively without constantly draining CPU cycles polling for state changes.

== Content Providers: Unified Data Abstraction
Due to Android's strict process isolation and sandboxing, one application cannot naively access the file directory of another. *Content Providers* mitigate this by acting as a secure, structured interface exposing a subset of data (like an SQLite schema) across the IPC (Inter-Process Communication) boundary. Through a standardized URI interface, developers can perform standard CRUD operations on complex external stores, such as querying the global 'Contacts' database without actually manipulating the underlying tables directly.

#pagebreak()
= Structural Architecture Outline: The Rivi Application

To visually demonstrate these core primitives interacting within a cohesive environment, we utilize the *Rivi* application—a distraction-free, spaced-repetition microlearning platform.

#align(center)[
  #v(10pt)
  #block(
    fill: white,
    stroke: 1pt + rgb("EEEEEE"),
    radius: 8pt,
    inset: 40pt,
    width: 100%,
    [
      #grid(
        columns: (1fr, 2fr, 1fr),
        align: center,
        row-gutter: 25pt,
        column-gutter: 15pt,

        [],
        block(
          fill: white,
          stroke: 1pt + rgb("CCCCCC"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*User Interface* \ (Activities / Fragments)],
        ),
        [],

        block(
          fill: white,
          stroke: 1pt + rgb("CCCCCC"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*Broadcast Receiver* \ (Alarm Constraints)],
        ),
        block(
          fill: rgb("F7F9FC"),
          stroke: 1pt + rgb("DDDDDD"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*Presentation / Logic* \ (ViewModel & State Handler)],
        ),
        block(
          fill: white,
          stroke: 1pt + rgb("CCCCCC"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*Background Service* \ (Cloud Synchronization)],
        ),

        [],
        block(
          fill: rgb("F7F9FC"),
          stroke: 1pt + rgb("DDDDDD"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*Persistence Repository* \ (Data Abstraction Layer)],
        ),
        [],

        [],
        block(
          fill: rgb("F7F9FC"),
          stroke: 1pt + rgb("DDDDDD"),
          inset: 12pt,
          radius: 4pt,
          width: 100%,
          [*Internal Database* \ (Room SQLite Architecture)],
        ),
        [],
      )
    ],
  )
  #v(10pt)
  #text(
    8pt,
    fill: rgb("888888"),
    style: "italic",
  )[Structural Flowchart of Rivi's Android Architecture]
]

== Diagram Component Analysis

- *User Interface (Activities):* The visual front-end consists of multiple activities, like the dashboard and the flashcard review layout, interacting directly with user touch events.
- *ViewModel & Presentation:* Acts as a lifecycle-aware intermediary. It ensures that UI data survives configuration changes like device rotations, decoupling the heavy data logic from the relatively brittle UI context.
- *Persistence Repository:* Operates under the hood, wrapping the complex logic required to determine whether to pull data from internal networks, external APIs, or local persistence.
- *Internal Database:* Implemented via Google's `Room` library to handle the SQLite transactions locally on device IO threads.
- *Broadcast Receivers / Services:* In Rivi, background services are triggered by receivers when specific system conditions are met, pushing notifications or syncing flashcards asynchronously.
