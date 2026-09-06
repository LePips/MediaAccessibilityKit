import Foundation
import MediaAccessibility
import SwiftUI

/// Displays text with a supplied style, or follows system appearance when `style` is nil.
public struct CaptionText: View {
    private let content: Text
    private let baseSize: CGFloat
    private let fontStyle: CaptionFontStyle
    private let style: CaptionStyle?

    public init(
        _ content: String,
        baseSize: CGFloat,
        fontStyle: CaptionFontStyle = .default,
        style: CaptionStyle? = nil
    ) {
        self.init(
            Text(verbatim: content),
            baseSize: baseSize,
            fontStyle: fontStyle,
            style: style
        )
    }

    public init(
        _ content: Text,
        baseSize: CGFloat,
        fontStyle: CaptionFontStyle = .default,
        style: CaptionStyle? = nil
    ) {
        self.content = content
        self.baseSize = baseSize
        self.fontStyle = fontStyle
        self.style = style
    }

    @ViewBuilder
    public var body: some View {
        if let style {
            CaptionTextBody(
                content: content,
                baseSize: baseSize,
                fontStyle: fontStyle,
                style: style
            )
        } else {
            ObservedCaptionText(
                content: content,
                baseSize: baseSize,
                fontStyle: fontStyle
            )
        }
    }
}

private struct ObservedCaptionText: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @State
    private var style = CaptionStyle.load(from: .user)

    let content: Text
    let baseSize: CGFloat
    let fontStyle: CaptionFontStyle

    var body: some View {
        CaptionTextBody(
            content: content,
            baseSize: baseSize,
            fontStyle: fontStyle,
            style: style
        )
        .task {
            let changes = NotificationCenter.default
                .notifications(named: Notification.Name(kMACaptionAppearanceSettingsChangedNotification as String))
                .map { _ in () }

            style = CaptionStyle.load(from: .user)
            for await _ in changes {
                style = CaptionStyle.load(from: .user)
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                style = CaptionStyle.load(from: .user)
            }
        }
    }
}

private struct CaptionTextBody: View {
    let content: Text
    let baseSize: CGFloat
    let fontStyle: CaptionFontStyle
    let style: CaptionStyle

    var body: some View {
        styledContent
            .font(font)
            .foregroundStyle(foregroundColor)
            .textRenderer(
                CaptionTextRenderer(
                    backgroundColor: style.textBackground.swiftUIColor(),
                    edgeStyle: style.text.edgeStyle.value
                )
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                style.window.swiftUIColor(),
                in: RoundedRectangle(
                    cornerRadius: max(style.window.cornerRadius.value, 0),
                    style: .continuous
                )
            )
    }

    private var styledContent: Text {
        var result = content

        if overridesAuthoredFont {
            result = result.font(font)
        }
        if overridesAuthoredColor {
            result = result.foregroundStyle(foregroundColor)
        }

        return result
    }

    private var font: Font {
        style.text.swiftUIFont(for: fontStyle, baseSize: baseSize)
    }

    private var foregroundColor: Color {
        style.text.swiftUIColor()
    }

    private var overridesAuthoredFont: Bool {
        style.text.fonts[fontStyle].behavior.overridesAuthoredContent
            || style.text.sizeScale.behavior.overridesAuthoredContent
    }

    private var overridesAuthoredColor: Bool {
        style.text.color.behavior.overridesAuthoredContent
            || style.text.opacity.behavior.overridesAuthoredContent
    }
}

private struct CaptionTextRenderer: TextRenderer {
    let backgroundColor: Color
    let edgeStyle: CaptionEdgeStyle

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            let bounds = line.typographicBounds.rect.insetBy(dx: -2, dy: -1)
            context.fill(Path(bounds), with: .color(backgroundColor))
        }

        switch edgeStyle {
        case .raised:
            drawShadow(
                layout,
                color: .white.opacity(0.7),
                radius: 0,
                x: -1,
                y: -1,
                in: context
            )
            drawShadow(
                layout,
                color: .black,
                radius: 0,
                x: 1,
                y: 1,
                in: context
            )
        case .depressed:
            drawShadow(
                layout,
                color: .black,
                radius: 0,
                x: -1,
                y: -1,
                in: context
            )
            drawShadow(
                layout,
                color: .white.opacity(0.7),
                radius: 0,
                x: 1,
                y: 1,
                in: context
            )
        case .uniform:
            drawShadow(
                layout,
                color: .black,
                radius: 1.5,
                in: context
            )
        case .dropShadow:
            drawShadow(
                layout,
                color: .black,
                radius: 1,
                x: 2,
                y: 2,
                in: context
            )
        case .unspecified, .none, .unknown:
            break
        }

        for line in layout {
            context.draw(line)
        }
    }

    private func drawShadow(
        _ layout: Text.Layout,
        color: Color,
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0,
        in context: GraphicsContext
    ) {
        var shadowContext = context
        shadowContext.addFilter(
            .shadow(
                color: color,
                radius: radius,
                x: x,
                y: y,
                options: .shadowOnly
            )
        )

        for line in layout {
            shadowContext.draw(line)
        }
    }
}

fileprivate extension CaptionSettingBehavior {
    var overridesAuthoredContent: Bool {
        switch self {
        case .preferContent:
            false
        case .overrideContent, .unknown:
            true
        }
    }
}
