# GoRise (Rosannalie)

GoRise (Rosannalie) is a highly visual, comprehensive Flutter-based mobile application centered around personal growth, productivity, and mental well-being. It acts as a personal life coach to help users build goals that stick, maintain daily motivation, track their habits, and visualize their future.

## � App Experience & Screenshots Breakdown
Based on the app's interfaces, here is what a user experiences:

*   **🏠 Master Dashboard (Home):**
    *   **Personalized Greeting:** Welcomes the user by name.
    *   **Daily Quote:** A prominently displayed motivational quote (e.g., "Fall seven times, stand up eight.").
    *   **Mood Tracker:** Users can log their current feelings ("How are you feeling right now?") using expressive emojis (Amazing, Good, Okay, Low, Drained).
    *   **Quick Access Grid:** Big, beautiful cards to jump straight into **To Do's**, **Goals**, **Quotes**, and **Future Me**.
    *   **Persistent Navigation:** A smooth, floating bottom navigation bar providing easy access to Home, Gratitude, AI Coach, Wins, and Profile.

*   **✅ Task & Goal Management:**
    *   **Today's Tasks:** A dedicated screen featuring a progress bar that fills up as tasks are completed.
    *   **Task Details:** Tasks have category/priority tags (e.g., "High", "Health"), an interactive checkbox for completion, easy deletion, and a toggle to "Set for daily" recurrence.

*   **✨ Future Me:**
    *   **Vision & Journey Timeline:** A visually rich workspace showing the user's "Glow-UP" progress.
    *   It contains an editable **My Vision** text area and a **My Journey** timeline tracking milestones like "First big goal set", "7-day streak", "30-day milestone", and "First goal complete".

*   **💖 Gratitude Journal:**
    *   **Moment of Gratitude:** Prompts the user with "What are you grateful for right now?"
    *   **Statistics:** Displays engaging stats like Total gratitude notes, Day streak, and Days logged this month.
    *   **Recent Entries:** Shows a historical log of recent gratitude diary entries.

*   **🤖 Rise AI Coach:**
    *   **Conversational Chat UI:** A beautiful, responsive chat interface where users interact with "Rise AI" — a personal productivity and mindfulness coach.
    *   It guides users, providing positive reinforcement and prompting them to maintain momentum on their goals. Includes a "Quick start" action button for easy prompts.

## 🚀 Key Features Recap
*   **Secure Authentication:** Traditional email registration and Social Logins.
*   **Wins & Gratitude:** Cultivate a positive mindset using daily logs. 
*   **Subscription & Freemium Model:** Premium flows for engaged users upgrading to Pro features.
*   **Full Profile & Settings:** Custom avatars, app settings, and a fully integrated Help & Support center (support tickets, FAQs).

## 🗂️ Folder Structure

The project uses a structured, feature-based architecture utilizing **GetX** for powerful State Management, Dependency Injection, and Routing.

```text
lib/
├── core/                       # Core application utilities
│   ├── dependency_injection/   # GetX bindings and initializations
│   ├── route/                  # Navigation routes (AppPages & AppRoutes)
│   └── services/               # API definitions & GetX Controllers
│
├── general_widget/             # Highly reusable, generic UI components
│   ├── custombutton.dart       # App-wide standard buttons
│   └── custom_background.dart  # Standard background wrappers (glassmorphism/gradients)
│
├── presention/                 # Feature-specific UI layers (Views/Widgets)
│   ├── auth/                   # Sign In, Sign Up, OTP, Forgot Password
│   ├── onloading/              # App Onboarding flow & questionnaire
│   ├── home/                   # Main Dashboard, To-Dos, My Vision
│   ├── profile/                # User Profile, Help Center, Settings
│   ├── ai_chart/               # AI Coach interface & history logs
│   ├── Gratitude/              # Gratitude logging flow
│   ├── wins/                   # Dashboard for celebrating wins
│   └── subscription_Promotion/ # Premium plan upselling
│
├── utils/                      # Constants, styling, and static helpers
│   ├── appcolors.dart          # Application color palette
│   └── appString.dart          # Text Styles, Typography, string assets
│
└── main.dart                   # Application Entry Point
```

## 🛠️ Tech Stack & Architecture
*   **Framework:** Flutter (Dart)
*   **State Management:** GetX (simplifies State, Routing, and Dependency Injection)
*   **Networking:** `http` package with bearer-token authorization.
*   **Local Storage:** `shared_preferences` for quick-loading persistent user sessions.

## 💡 What type of app is this?
It is a **Premium Productivity, Mindfulness & Habit-Tracking Application**. It is designed for users who want to take extreme ownership of their time through a beautiful, clean, and gamified interface. It goes beyond a simple to-do app by integrating long-term psychological goal-setting combined with conversational AI assistance.
