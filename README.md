# 📖 Rivi — Minimalist Academic Microlearning

Rivi is a focused, academic-first flashcard application designed to combat burnout through intentional constraints. Built for students who value depth over volume, Rivi enforces a **"Smart 5"** daily limit and uses an exam-aware Spaced Repetition System (SRS).

![Rivi Hero](https://via.placeholder.com/800x400.png?text=Rivi:+Focus+on+what+matters)

## ✨ Features

- **The "Smart 5" Logic**: Unlike other SRS apps that overwhelm you with hundreds of reviews, Rivi limits you to the 5 most critical cards per subject each day.
- **Exam-Aware SRS**: A modified SM-2 algorithm that automatically increases review frequency as your exam date approaches.
- **Academic UI**: 
    - **Typography**: Elegant Serif fonts for learning content; clean Sans-serif for navigation.
    - **Micro-interactions**: 3D card flip animations and smooth list entry effects.
    - **Minimalist Design**: 0dp elevation cards with 1dp strokes for a modern, paper-like feel.
- **Data Portability**: Full JSON Export/Import support. Share subjects with classmates without leaking your personal SRS progress metadata.
- **Emergency Cram Mode**: Within 48 hours of an exam, the "Smart 5" limit is lifted, allowing for unlimited reviews.

## 🛠 Tech Stack

- **Language**: Java
- **Architecture**: MVVM (Model-View-ViewModel)
- **Database**: Room Persistence Library
- **JSON Engine**: GSON (for data portability)
- **UI Components**: Material Design 3, ConstraintLayout
- **Animations**: Android Property Animators (`AnimatorSet`)

## 🧠 The Algorithm: Modified SM-2

Rivi uses a sophisticated scheduling logic defined in `SRSLogic.java`:

1.  **Standard SM-2**: Calculates Ease Factor and Intervals based on user performance (Again, Hard, Good, Easy).
2.  **Exam Proximity Compression**:
    - **> 30 days**: Standard intervals.
    - **14–30 days**: 25% interval reduction.
    - **7–14 days**: 50% interval reduction.
    - **< 7 days**: Maximum interval capped at 2 days.
3.  **Emergency Cram**: If the exam is within 48 hours, the app switches to a high-intensity mode.

## 🚀 Getting Started

### Prerequisites
- Android Studio Iguana or newer
- JDK 17
- Android SDK 34 (API Level 34)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/rivi.git
   ```
2. Open the project in Android Studio.
3. Sync Gradle and run the `app` module on an emulator or physical device.

## 📂 Data Portability

Rivi uses a decoupled DTO (Data Transfer Object) system for sharing:
- **`SubjectExportDto`**: Contains subject metadata and a list of `FlashcardDto`.
- **Privacy**: Only the question and answer text are exported. Your personal ease factors, intervals, and streaks stay private on your device.

\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
---
*“Non multa, sed multum” – Not many things, but much.*