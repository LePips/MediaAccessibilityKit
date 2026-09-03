import MediaAccessibility

/// Controls whether system or authored caption styling takes precedence.
public enum CaptionSettingBehavior: Sendable, Hashable {
    case overrideContent
    case preferContent

    /// A newer system behavior; resolution keeps the system value.
    case unknown(rawValue: Int)

    package init(_ value: MACaptionAppearanceBehavior) {
        switch value {
        case .useValue: self = .overrideContent
        case .useContentIfAvailable: self = .preferContent
        @unknown default: self = .unknown(rawValue: value.rawValue)
        }
    }
}
