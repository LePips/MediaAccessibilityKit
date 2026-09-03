import MediaAccessibility

/// An edge treatment for caption text.
public enum CaptionEdgeStyle: Sendable, Hashable {
    case unspecified
    case none
    case raised
    case depressed
    case uniform
    case dropShadow
    case unknown(rawValue: Int)

    package init(_ value: MACaptionAppearanceTextEdgeStyle) {
        switch value {
        case .undefined: self = .unspecified
        case .none: self = .none
        case .raised: self = .raised
        case .depressed: self = .depressed
        case .uniform: self = .uniform
        case .dropShadow: self = .dropShadow
        @unknown default: self = .unknown(rawValue: value.rawValue)
        }
    }
}
