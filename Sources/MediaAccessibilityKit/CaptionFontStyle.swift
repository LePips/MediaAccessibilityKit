import MediaAccessibility

/// A semantic font category supported by caption preferences.
public enum CaptionFontStyle: Sendable, Hashable, CaseIterable {
    case `default`
    case monospacedSerif
    case proportionalSerif
    case monospacedSansSerif
    case proportionalSansSerif
    case casual
    case cursive
    case smallCaps

    package var mediaAccessibilityValue: MACaptionAppearanceFontStyle {
        switch self {
        case .default: .default
        case .monospacedSerif: .monospacedWithSerif
        case .proportionalSerif: .proportionalWithSerif
        case .monospacedSansSerif: .monospacedWithoutSerif
        case .proportionalSansSerif: .proportionalWithoutSerif
        case .casual: .casual
        case .cursive: .cursive
        case .smallCaps: .smallCapital
        }
    }
}
