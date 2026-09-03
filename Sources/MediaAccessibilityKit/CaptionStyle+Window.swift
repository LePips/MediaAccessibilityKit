import CoreGraphics

public extension CaptionStyle {
    /// Styling for the window behind a complete caption.
    struct Window: Sendable, Hashable {
        public let color: CaptionSetting<CGColor>
        public let opacity: CaptionSetting<CGFloat>
        public let cornerRadius: CaptionSetting<CGFloat>

        public init(
            color: CaptionSetting<CGColor>,
            opacity: CaptionSetting<CGFloat>,
            cornerRadius: CaptionSetting<CGFloat>
        ) {
            self.color = color
            self.opacity = opacity
            self.cornerRadius = cornerRadius
        }
    }
}
