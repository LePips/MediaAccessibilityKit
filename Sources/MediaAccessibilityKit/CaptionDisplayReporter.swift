import Foundation
import MediaAccessibility

/// Reports visible captions to system accessibility clients.
///
/// Report through the active renderer. Reports have no player identifier.
@MainActor
public enum CaptionDisplayReporter {
    /// Reports all visible captions in reading order.
    ///
    /// Call when visible text changes. Include every caption region.
    /// This does not post a VoiceOver announcement.
    public static func report(_ captions: [String]) {
        MACaptionAppearanceDidDisplayCaptions(captions as CFArray)
    }

    /// Reports that no captions are visible.
    public static func clear() {
        report([])
    }
}
