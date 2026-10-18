import Foundation
import MediaAccessibility

/// A snapshot of the user's audio track preferences.
public struct AudibleMediaPreferences: Sendable, Hashable {
    /// Media characteristic identifiers in preference order, including unknown values.
    public let preferredCharacteristics: [String]

    public init(preferredCharacteristics: [String]) {
        self.preferredCharacteristics = preferredCharacteristics
    }
}

public extension AudibleMediaPreferences {
    /// The user's current audio track preferences.
    static var current: Self {
        Self(
            preferredCharacteristics: MAAudibleMediaCopyPreferredCharacteristics().takeRetainedValue() as? [String] ?? []
        )
    }

    /// Yields current preferences immediately and when audio settings change.
    ///
    /// Each access creates a separate stream that buffers only the latest unread value.
    /// Cancel the consuming task to stop observing.
    @MainActor
    static var updates: AsyncStream<Self> {
        preferenceUpdates(named: Notification.Name(kMAAudibleMediaSettingsChangedNotification as String)) {
            current
        }
    }
}
