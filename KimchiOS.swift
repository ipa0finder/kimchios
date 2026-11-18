
import SwiftUI

@main
struct KimchiOSApp: App {
    @StateObject private var manager = VMManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .preferredColorScheme(.dark)
        }
    }
}
