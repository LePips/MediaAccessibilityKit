/// A snapshot of the system caption style.
public struct CaptionStyle: Sendable, Hashable {
    public let text: Text
    public let textBackground: Fill
    public let window: Window
    public let isCustomized: Bool

    public init(
        text: Text,
        textBackground: Fill,
        window: Window,
        isCustomized: Bool
    ) {
        self.text = text
        self.textBackground = textBackground
        self.window = window
        self.isCustomized = isCustomized
    }
}
