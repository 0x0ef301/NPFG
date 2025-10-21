# Night Plinkers — SwiftUI Starter (Act 0 Intro)

This is a tiny **copy‑paste** kit to help you follow the step‑by‑step guide in ChatGPT.
You will still create an Xcode project yourself, then copy these files into it.

## What’s Included
- `NPFieldApp.swift` — App entry point
- `AppState.swift` — Shared state object (XP, badges, active job)
- `RootTabView.swift` — Bottom tab bar
- `IntroFlowView.swift` — The multi‑step Intro flow shell
- `CreateJobStep.swift` — Your first working screen (client + property form)

## How to Use These Files
1) Open **Xcode** → **File > New > Project…** → iOS **App**.
   - Product Name: `Night Plinkers`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Save anywhere you like.

2) In the Xcode Project Navigator, delete the default `ContentView.swift` to avoid conflicts.

3) In Finder, open this starter folder **side‑by‑side** with your Xcode project’s folder.
   - Drag each `.swift` file into your Xcode project (choose **Copy items if needed**).
   - When asked, add to the main target (checkbox).

4) Build & Run ▶️ (choose any iPhone simulator). You should see:
   - A tab bar (Home, Capture, Jobs, Reports, Profile)
   - A button on Home that opens the Intro flow
   - A “Create Job” screen with fields and a working “Save & Continue”

5) Next steps (optional):
   - Create more steps: BaselineStoryStep, GoalAgreementStep, etc.
   - Wire up Core Data later; for now the form just prints to console.

Happy building!