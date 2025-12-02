import SwiftUI
import UIKit

// MARK: - Data models (unchanged)

struct ActStep: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let textBullets: [String]
    let imageName: String?
    let caption: String?
}

struct ActDefinition {
    let actNumber: Int
    let actTitle: String
    let actSubtitle: String
    let steps: [ActStep]
    let nextActBuilder: (() -> AnyView)?
}

// MARK: - Cards (unchanged)

struct TextCard: View {
    let title: String
    let bullets: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline).foregroundColor(.white)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(bullets, id: \.self) { b in
                    HStack(alignment: .top, spacing: 8) {
                        Circle().fill(Color.green).frame(width: 6, height: 6).padding(.top, 6)
                        Text(b).foregroundColor(.white)
                    }
                }
            }
        }
        .padding(16)
        .background(.black.opacity(0.5))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.green.opacity(0.6), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .green.opacity(0.25), radius: 12)
    }
}

struct VisualCard: View {
    let imageName: String
    let caption: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.green.opacity(0.5), lineWidth: 1))
                .shadow(color: .green.opacity(0.25), radius: 12)
            if let caption = caption {
                Text(caption).font(.footnote).foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Flow container

struct ActFlowView: View {
    let def: ActDefinition

    // State
    @State private var stepIndex: Int = 0
    @State private var showCongrats = false          // Acts 1–4: show "Proceed to Act N+1"
    @State private var goNext = false                // Acts 1–4: push next act
    @State private var goEpilogueOverview = false    // Act 5: push Epilogue Overview
    @Environment(\.dismiss) private var dismiss

    // Derived
    private var progress: Double { Double(stepIndex + 1) / Double(def.steps.count) }
    private var isLastAct: Bool { def.actNumber >= 5 }
    private var nextButtonTitle: String {
        if stepIndex < def.steps.count - 1 { return "Next" }
        return isLastAct ? "Finish Act V" : "Finish"
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {

                    // Header
                    header

                    // Content (current step cards)
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 16) {
                                let step = def.steps[stepIndex]
                                // Add an anchor view for the top
                                Color.clear
                                    .frame(height: 0)
                                    .id("top")

                                TextCard(title: step.title, bullets: step.textBullets)

                                if let name = step.imageName {
                                    VisualCard(imageName: name, caption: step.caption)
                                }
                            }
                            .padding(16)
                        }
                        .scrollIndicators(.visible)
                        .scrollBounceBehavior(.basedOnSize)
                        // 👇 Reset scroll position when stepIndex changes
                        .onChange(of: stepIndex) { oldValue, newValue in
                            withAnimation(.easeInOut) {
                                proxy.scrollTo("top", anchor: .top)
                            }
                        }
                    }
                    
                    // Lower 1/5 navigation pane
                    navPane
                        .frame(height: max(140, geo.size.height * 0.20))
                        .background(.black.opacity(0.8))
                        .overlay(Divider().background(Color.green.opacity(0.4)), alignment: .top)
                }
                .background(Color.black.ignoresSafeArea())
            }
            .navigationBarHidden(true)
        }
        // iOS 16+ destination pushes
        .navigationDestination(isPresented: $goNext) {
            if let builder = def.nextActBuilder {
                builder()  // AnyView from the next act
            } else {
                EmptyView()
            }
        }
        .navigationDestination(isPresented: $goEpilogueOverview) {
            Epilogue_OverviewView()
        }

        // Acts 1–4: Congrats sheet with "Proceed to Act N+1"
        .sheet(isPresented: $showCongrats) {
            CongratsView(
                actNumber: def.actNumber,
                nextTitle: "Proceed to Act \(def.actNumber + 1)",
                onHome: {
                    showCongrats = false
                    dismiss()
                },
                onNextAct: {
                    // Close the sheet and push the next act in THIS NavigationStack
                    showCongrats = false
                    goNext = true
                }
            )
            .presentationDetents([.fraction(0.8)])
        }

        .preferredColorScheme(.dark)
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Back
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.green)
                        .padding(8)
                }

                Spacer()

                // Home
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    dismiss()
                } label: {
                    Image(systemName: "house.fill")
                        .foregroundColor(.green)
                        .padding(8)
                }
            }

            Text("Act \(def.actNumber) — \(def.actTitle)")
                .font(.title2.bold())
                .foregroundColor(.white)

            Text(def.actSubtitle)
                .font(.subheadline)
                .foregroundColor(.green)

            ProgressView(value: progress)
                .tint(.green)
                .padding(.top, 4)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Bottom Nav Pane
    private var navPane: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Step \(stepIndex + 1) of \(def.steps.count)")
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .foregroundColor(.green)
                    .bold()
            }
            .padding(.horizontal, 16)

            HStack(spacing: 12) {
                // Back step
                Button {
                    guard stepIndex > 0 else { return }
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    withAnimation(.easeInOut) { stepIndex -= 1 }
                } label: {
                    Label("Back", systemImage: "arrow.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.gray)
                .disabled(stepIndex == 0)

                // Next / Finish
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.easeInOut) {
                        if stepIndex < def.steps.count - 1 {
                            stepIndex += 1
                        } else {
                            handleFinish()
                        }
                    }
                } label: {
                    Label(
                        nextButtonTitle,
                        systemImage: stepIndex < def.steps.count - 1 ? "arrow.right" : "checkmark.seal.fill"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Helpers
    private func handleFinish() {
        if isLastAct {
            // Act V finishes → go to the Epilogue Overview (then user taps "Finish Introduction")
            goEpilogueOverview = true
        } else {
            // Acts I–IV: show sheet with "Proceed to Act N+1"
            showCongrats = true
        }
    }
}

// MARK: - Congrats sheet for Acts 1–4

struct CongratsView: View {
    let actNumber: Int
    let nextTitle: String
    let onHome: () -> Void
    let onNextAct: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles").font(.system(size: 56, weight: .bold)).foregroundColor(.green)
            Text("Congratulations!").font(.largeTitle.bold()).foregroundColor(.white)
            Text("You’ve completed the Act \(actNumber) Overview.").foregroundColor(.white)
            Spacer()
            VStack(spacing: 12) {
                Button(nextTitle) { onNextAct() }
                    .buttonStyle(.borderedProminent).tint(.green).frame(maxWidth: .infinity)
                Button("Return Home") { onHome() }
                    .buttonStyle(.bordered).tint(.gray).frame(maxWidth: .infinity)
            }
            Spacer(minLength: 16)
        }
        .padding(24)
        .background(Color.black.ignoresSafeArea())
    }
}
