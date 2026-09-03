import SwiftUI

extension EnvironmentValues {
    /// The caption style for this view hierarchy.
    @Entry
    public var mediaCaptionStyle: CaptionStyle = .current

    @Entry
    package var isMediaCaptionStyleManaged = false
}
