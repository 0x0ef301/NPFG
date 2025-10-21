import SwiftUI

struct IntroFlowView: View {
    @State private var step = 1
    var body: some View {
        VStack {
            switch step {
            case 1:
                CreateJobStep(onNext: { step = 2 })
            default:
                IntroFinishStep()
            }
        }
        .animation(.easeInOut, value: step)
        .navigationTitle("Intro")
    }
}

struct IntroFinishStep: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill").font(.system(size: 48))
            Text("Intro Complete").font(.title2).bold()
            Text("Next: Act I — Discovery & Trust")
                .foregroundStyle(.secondary)
        }.padding()
    }
}