import Foundation
import MediaAccessibility

/// A saved system caption style. Use `updates` to follow settings changes.
public struct CaptionProfile: Identifiable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let style: CaptionStyle

    public enum ActivationError: Error {
        case unavailableProfile

        public var localizedDescription: String {
            "This caption style is no longer available"
        }
    }
}

public extension CaptionProfile {
    /// All saved profiles on iOS 26, macOS 26, and tvOS 26 or later.
    ///
    /// Returns an empty array on earlier systems, allowing profile pickers to
    /// fall back to the current caption style without an availability check.
    @MainActor
    static var availableForCurrentPlatform: [Self] {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, *) {
            available
        } else {
            []
        }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, *)
public extension CaptionProfile {
    /// All saved profiles.
    @MainActor
    static var available: [Self] {
        profileIDs.map(load)
    }

    /// Yields saved profiles immediately and whenever caption settings change.
    @MainActor
    static var updates: AsyncStream<[Self]> {
        let changes = NotificationCenter.default
            .notifications(named: Notification.Name(kMACaptionAppearanceSettingsChangedNotification as String))
            .map { _ in () }

        return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            continuation.yield(available)

            let task = Task { @MainActor in
                for await _ in changes {
                    guard !Task.isCancelled else { break }
                    continuation.yield(available)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    /// The currently selected system profile, if it is still available.
    @MainActor
    static var active: Self? {
        let id = MACaptionAppearanceCopyActiveProfileID() as String
        guard profileIDs.contains(id) else { return nil }
        return load(id)
    }

    /// Selects this profile system-wide.
    ///
    /// - Throws: `ActivationError.unavailableProfile` if it is not available.
    @MainActor
    func activate() throws(ActivationError) {
        guard Self.profileIDs.contains(id) else {
            throw ActivationError.unavailableProfile
        }
        MACaptionAppearanceSetActiveProfileID(id as CFString)
    }

    @MainActor
    private static func load(_ id: String) -> Self {
        var style = CaptionStyle.systemDefaults
        MACaptionAppearanceExecuteBlockForProfileID(id as CFString) {
            style = CaptionStyle.load(from: .user)
        }
        return Self(
            id: id,
            name: MACaptionAppearanceCopyProfileName(id as CFString) as String,
            style: style
        )
    }

    @MainActor
    private static var profileIDs: [String] {
        MACaptionAppearanceCopyProfileIDs() as? [String] ?? []
    }
}
