import CoreGraphics
import SwiftUI

public extension CaptionStyle.Text {
    func swiftUIColor(
        contentColor: CGColor? = nil,
        contentOpacity: CGFloat? = nil
    ) -> Color {
        Color(cgColor: color.resolved(contentValue: contentColor))
            .opacity(Double(opacity.resolved(contentValue: contentOpacity)))
    }

    func swiftUIFont(
        for style: CaptionFontStyle = .default,
        baseSize: CGFloat,
        contentFont: CaptionFont? = nil,
        contentSizeScale: CGFloat? = nil
    ) -> Font {
        let font = fonts[style].resolved(contentValue: contentFont)
        let scale = sizeScale.resolved(contentValue: contentSizeScale)
        return font.swiftUIFont(size: baseSize * scale)
    }
}

public extension CaptionStyle.Fill {
    func swiftUIColor(
        contentColor: CGColor? = nil,
        contentOpacity: CGFloat? = nil
    ) -> Color {
        Color(cgColor: color.resolved(contentValue: contentColor))
            .opacity(Double(opacity.resolved(contentValue: contentOpacity)))
    }
}

public extension CaptionStyle.Window {
    func swiftUIColor(
        contentColor: CGColor? = nil,
        contentOpacity: CGFloat? = nil
    ) -> Color {
        Color(cgColor: color.resolved(contentValue: contentColor))
            .opacity(Double(opacity.resolved(contentValue: contentOpacity)))
    }
}
