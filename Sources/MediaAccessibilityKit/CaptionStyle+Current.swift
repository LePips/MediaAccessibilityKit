import CoreGraphics
import CoreText
import MediaAccessibility

extension CaptionStyle {
    /// The user's current style.
    public static var current: Self {
        load(from: .user)
    }

    /// The fixed system style used for comparison.
    public static let systemDefaults = load(from: MACaptionAppearanceDomain.default)

    private static func load(from domain: MACaptionAppearanceDomain) -> Self {
        let textColor = setting {
            MACaptionAppearanceCopyForegroundColor(domain, $0).takeRetainedValue()
        }
        let textOpacity = setting {
            MACaptionAppearanceGetForegroundOpacity(domain, $0)
        }
        let sizeScale = setting {
            MACaptionAppearanceGetRelativeCharacterSize(domain, $0)
        }
        let edgeStyle = setting {
            CaptionEdgeStyle(MACaptionAppearanceGetTextEdgeStyle(domain, $0))
        }
        let textBackgroundColor = setting {
            MACaptionAppearanceCopyBackgroundColor(domain, $0).takeRetainedValue()
        }
        let textBackgroundOpacity = setting {
            MACaptionAppearanceGetBackgroundOpacity(domain, $0)
        }
        let windowColor = setting {
            MACaptionAppearanceCopyWindowColor(domain, $0).takeRetainedValue()
        }
        let windowOpacity = setting {
            MACaptionAppearanceGetWindowOpacity(domain, $0)
        }
        let windowCornerRadius = setting {
            MACaptionAppearanceGetWindowRoundedCornerRadius(domain, $0)
        }

        func font(_ style: CaptionFontStyle) -> CaptionSetting<CaptionFont> {
            setting {
                let descriptor = MACaptionAppearanceCopyFontDescriptorForStyle(
                    domain,
                    $0,
                    style.mediaAccessibilityValue
                ).takeRetainedValue()
                return CaptionFont(descriptor: descriptor)
            }
        }

        return Self(
            text: .init(
                color: textColor,
                opacity: textOpacity,
                sizeScale: sizeScale,
                edgeStyle: edgeStyle,
                fonts: CaptionFonts(
                    default: font(.default),
                    monospacedSerif: font(.monospacedSerif),
                    proportionalSerif: font(.proportionalSerif),
                    monospacedSansSerif: font(.monospacedSansSerif),
                    proportionalSansSerif: font(.proportionalSansSerif),
                    casual: font(.casual),
                    cursive: font(.cursive),
                    smallCaps: font(.smallCaps)
                )
            ),
            textBackground: .init(
                color: textBackgroundColor,
                opacity: textBackgroundOpacity
            ),
            window: .init(
                color: windowColor,
                opacity: windowOpacity,
                cornerRadius: windowCornerRadius
            ),
            isCustomized: MACaptionAppearanceIsCustomized(domain)
        )
    }

    private static func setting<Value>(
        _ load: (UnsafeMutablePointer<MACaptionAppearanceBehavior>) -> Value
    ) -> CaptionSetting<Value> {
        var rawBehavior = MACaptionAppearanceBehavior.useValue
        let value = load(&rawBehavior)
        return CaptionSetting(value: value, behavior: CaptionSettingBehavior(rawBehavior))
    }
}
