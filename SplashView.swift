//import SwiftUI
//
//struct SplashView: View {
//    @State private var spin = false
//    @State private var pulse = false
//
//    var body: some View {
//        ZStack {
//            // Deep black background
//            Color.black.ignoresSafeArea()
//
//            VStack(spacing: 32) {
//                ZStack {
//                    // Outer glow ring (pulsing neon)
//                    Circle()
//                        .stroke(Color.green.opacity(pulse ? 0.8 : 0.3), lineWidth: 30)
//                        .frame(width: 320, height: 320)
//                        .blur(radius: 25)
//                        .scaleEffect(pulse ? 1.15 : 1.0)
//                        .animation(
//                            .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
//                            value: pulse
//                        )
//
//                    // Main logo with spin
//                    Image("NightPlinkersLogo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 280, height: 280)
//                        .rotationEffect(.degrees(spin ? 360 : 0))
//                        .animation(
//                            .linear(duration: 5.0).repeatForever(autoreverses: false),
//                            value: spin
//                        )
//                        .shadow(color: .green.opacity(0.9), radius: 25)
//                        .shadow(color: .green.opacity(0.6), radius: 50)
//                        .shadow(color: .green.opacity(0.4), radius: 80)
//                }
//
//                // Text under the logo
//                Text("Night Plinkers")
//                    .font(.largeTitle.bold())
//                    .foregroundColor(.green)
//                    .shadow(color: .green, radius: 15)
//                    .shadow(color: .green.opacity(0.6), radius: 25)
//                    .padding(.top, 10)
//            }
//            .padding(.bottom, 60)
//        }
//        .onAppear {
//            spin = true
//            pulse = true
//        }
//        .preferredColorScheme(.dark)
//    }
//}
//
import SwiftUI

struct SplashView: View {
    @State private var spin  = false
    @State private var pulse = false

    // Sizes you can tweak
    private let haloSize: CGFloat  = 320
    private let logoSize: CGFloat  = 260

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                // Pulsing neon halo BEHIND the logo
                Circle()
                    .stroke(Color.green.opacity(pulse ? 0.85 : 0.35), lineWidth: 10)
                    .frame(width: haloSize, height: haloSize)
                    .blur(radius: 25)
                    .scaleEffect(pulse ? 1.12 : 1.0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                               value: pulse)

                // Logo centered ON TOP of the halo
                Image("NightPlinkersLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: haloSize, height: haloSize)
                    // 3D flip around the X axis
                    .rotation3DEffect(.degrees(spin ? 360 : 0),
                                      axis: (x: 0, y: 1, z: 0),
                                      anchor: .center,
                                      anchorZ: 0,
                                      perspective: 0.6)
                    // Neon glow
                    .shadow(color: .green.opacity(0.95), radius: 22)
                    .shadow(color: .green.opacity(0.65), radius: 48)
                    .shadow(color: .green.opacity(0.40), radius: 80)
                    .animation(.linear(duration: 4.0).repeatForever(autoreverses: false),
                               value: spin)
            }
            // Ensure both halo and logo stay perfectly centered
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onAppear {
            spin  = true
            pulse = true
        }
        .preferredColorScheme(.dark)
        // Improves rendering quality for layered shadows/3D
        .compositingGroup()
        .drawingGroup()
    }
}
