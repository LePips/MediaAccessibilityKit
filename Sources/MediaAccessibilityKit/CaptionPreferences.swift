import Foundation
import MediaAccessibility

/// A snapshot of the user's caption track preferences.
public struct CaptionPreferences: Sendable, Hashable {
    public let displayType: CaptionDisplayType

    /// Canonical language identifiers in preference order.
    public let selectedLanguages: [String]

    /// Media characteristic identifiers in preference order, including unknown values.
    public let preferredCharacteristics: [String]

    public init(
        displayType: CaptionDisplayType,
        selectedLanguages: [String],
        preferredCharacteristics: [String]
    ) {
        self.displayType = displayType
        self.selectedLanguages = selectedLanguages
        self.preferredCharacteristics = preferredCharacteristics
    }
}

public extension CaptionPreferences {
    /// The user's current caption track preferences.
    static var current: Self {
        load(from: .user)
    }

    /// The fixed system preferences used for comparison.
    static let systemDefaults = load(from: .default)

    /// Yields current preferences immediately and when caption settings change.
    ///
    /// Each access creates a separate stream that buffers only the latest unread value.
    /// Cancel the consuming task to stop observing.
    @MainActor
    static var updates: AsyncStream<Self> {
        preferenceUpdates(named: Notification.Name(kMACaptionAppearanceSettingsChangedNotification as String)) {
            current
        }
    }

    private static func load(from domain: MACaptionAppearanceDomain) -> Self {
        Self(
            displayType: CaptionDisplayType(MACaptionAppearanceGetDisplayType(domain)),
            selectedLanguages: MACaptionAppearanceCopySelectedLanguages(domain).takeRetainedValue() as? [String] ?? [],
            preferredCharacteristics: MACaptionAppearanceCopyPreferredCaptioningMediaCharacteristics(domain)
                .takeRetainedValue() as? [String] ?? []
        )
    }
}
