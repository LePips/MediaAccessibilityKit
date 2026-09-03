import CoreText
import SwiftUI

public extension CaptionFont {
    func swiftUIFont(size: CGFloat) -> Font {
        let font = CTFontCreateWithFontDescriptor(
            descriptor,
            max(size, .leastNonzeroMagnitude),
            nil
        )
        return Font(font)
    }
}
