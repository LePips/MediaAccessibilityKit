import SwiftUI

@main
struct CaptionExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        #if os(macOS)
        .defaultSize(width: 640, height: 560)
        #endif
    }
}
