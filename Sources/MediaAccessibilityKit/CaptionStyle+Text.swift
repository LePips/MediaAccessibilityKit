import CoreGraphics

public extension CaptionStyle {
    /// Caption text styling.
    struct Text: Sendable, Hashable {
        public let color: CaptionSetting<CGColor>
        public let opacity: CaptionSetting<CGFloat>
        public let sizeScale: CaptionSetting<CGFloat>
        public let edgeStyle: CaptionSetting<CaptionEdgeStyle>
        public let fonts: CaptionFonts

        public init(
            color: CaptionSetting<CGColor>,
            opacity: CaptionSetting<CGFloat>,
            sizeScale: CaptionSetting<CGFloat>,
            edgeStyle: CaptionSetting<CaptionEdgeStyle>,
            fonts: CaptionFonts
        ) {
            self.color = color
            self.opacity = opacity
            self.sizeScale = sizeScale
            self.edgeStyle = edgeStyle
            self.fonts = fonts
        }
    }
}
