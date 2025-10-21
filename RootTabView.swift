
import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            CaptureHubView()
                .tabItem { Label("Capture", systemImage: "camera.viewfinder") }
            JobsListView()
                .tabItem { Label("Jobs", systemImage: "briefcase.fill") }
            ReportsView()
                .tabItem { Label("Reports", systemImage: "doc.richtext") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .preferredColorScheme(.dark)
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showIntro = false

    var body: some View {
        if appState.operatorProfile == nil {
            OperatorRegistrationView()   // ← show registration first
        } else {
            NavigationStack {
                VStack(spacing: 16) {
                    Image("NightPlinkersLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .padding(.top, 40)

                    Text("Night Plinkers")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)

                    Text("Act 0: Welcome & Setup")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    NavigationLink("Start Intro") {
                        IntroFlowView()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("")
            }
        }
    }
}

// Placeholders so project builds:
struct CaptureHubView: View { var body: some View { Text("Capture").padding() } }
struct JobsListView: View { var body: some View { Text("Jobs").padding() } }
struct ReportsView: View { var body: some View { Text("Reports").padding() } }
//struct ProfileView: View { var body: some View { Text("Profile").padding() } }
