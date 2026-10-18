import MediaAccessibility

/// The system preference for when to display captions.
public enum CaptionDisplayType: Sendable, Hashable {
    /// Display only forced captions, such as dialogue translations.
    case forcedOnly

    /// Display captions matching the system locale when the audio language differs.
    case automatic

    /// Always display the best available captions.
    case alwaysOn

    /// An unrecognized system display preference.
    case unknown(rawValue: Int)

    package init(_ value: MACaptionAppearanceDisplayType) {
        switch value {
        case .forcedOnly: self = .forcedOnly
        case .automatic: self = .automatic
        case .alwaysOn: self = .alwaysOn
        @unknown default: self = .unknown(rawValue: value.rawValue)
        }
    }
}
