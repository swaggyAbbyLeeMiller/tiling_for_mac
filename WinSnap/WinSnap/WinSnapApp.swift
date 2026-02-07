import SwiftUI


@main
struct WinSnapApp: App {
    let hotKeyTap = HotKeyTap()  // Keep as a property to retain it

    init() {
        hotKeyTap.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

