/// The complete set of caption font preferences.
public struct CaptionFonts: Sendable, Hashable {
    public let `default`: CaptionSetting<CaptionFont>
    public let monospacedSerif: CaptionSetting<CaptionFont>
    public let proportionalSerif: CaptionSetting<CaptionFont>
    public let monospacedSansSerif: CaptionSetting<CaptionFont>
    public let proportionalSansSerif: CaptionSetting<CaptionFont>
    public let casual: CaptionSetting<CaptionFont>
    public let cursive: CaptionSetting<CaptionFont>
    public let smallCaps: CaptionSetting<CaptionFont>

    public init(
        default: CaptionSetting<CaptionFont>,
        monospacedSerif: CaptionSetting<CaptionFont>,
        proportionalSerif: CaptionSetting<CaptionFont>,
        monospacedSansSerif: CaptionSetting<CaptionFont>,
        proportionalSansSerif: CaptionSetting<CaptionFont>,
        casual: CaptionSetting<CaptionFont>,
        cursive: CaptionSetting<CaptionFont>,
        smallCaps: CaptionSetting<CaptionFont>
    ) {
        self.default = `default`
        self.monospacedSerif = monospacedSerif
        self.proportionalSerif = proportionalSerif
        self.monospacedSansSerif = monospacedSansSerif
        self.proportionalSansSerif = proportionalSansSerif
        self.casual = casual
        self.cursive = cursive
        self.smallCaps = smallCaps
    }

    public subscript(style: CaptionFontStyle) -> CaptionSetting<CaptionFont> {
        switch style {
        case .default: `default`
        case .monospacedSerif: monospacedSerif
        case .proportionalSerif: proportionalSerif
        case .monospacedSansSerif: monospacedSansSerif
        case .proportionalSansSerif: proportionalSansSerif
        case .casual: casual
        case .cursive: cursive
        case .smallCaps: smallCaps
        }
    }
}
