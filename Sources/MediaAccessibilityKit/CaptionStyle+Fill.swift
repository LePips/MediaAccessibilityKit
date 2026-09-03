import CoreGraphics

public extension CaptionStyle {
    /// Styling for the background behind caption glyphs.
    struct Fill: Sendable, Hashable {
        public let color: CaptionSetting<CGColor>
        public let opacity: CaptionSetting<CGFloat>

        public init(
            color: CaptionSetting<CGColor>,
            opacity: CaptionSetting<CGFloat>
        ) {
            self.color = color
            self.opacity = opacity
        }
    }
}
