import Foundation
import MediaAccessibility
import SwiftUI

public extension View {
    /// Installs the current style and keeps it up to date.
    func mediaCaptionStyle() -> some View {
        modifier(CurrentMediaCaptionStyleModifier())
    }

    /// Installs a specific caption style.
    func mediaCaptionStyle(_ style: CaptionStyle) -> some View {
        environment(\.mediaCaptionStyle, style)
            .environment(\.isMediaCaptionStyleManaged, true)
    }
}

private struct CurrentMediaCaptionStyleModifier: ViewModifier {
    @Environment(\.scenePhase)
    private var scenePhase
    @State
    private var style = CaptionStyle.current

    func body(content: Content) -> some View {
        content
            .environment(\.mediaCaptionStyle, style)
            .environment(\.isMediaCaptionStyleManaged, true)
            .task {
                let changes = NotificationCenter.default
                    .notifications(named: mediaCaptionAppearanceSettingsDidChange)
                    .map { _ in () }

                style = .current
                for await _ in changes {
                    style = .current
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                style = .current
            }
    }
}

private let mediaCaptionAppearanceSettingsDidChange = Notification.Name(
    kMACaptionAppearanceSettingsChangedNotification as String
)
