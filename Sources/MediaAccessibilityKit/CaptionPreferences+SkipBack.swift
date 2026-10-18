import Darwin
import Foundation

public extension CaptionPreferences {
    /// Whether subtitles appear automatically when skipping back, or `nil` if unavailable.
    static var showOnSkipBack: Bool? {
        readPrivateAccessibilityBoolean(
            "X0FYU0F1dG9tYXRpY1N1YnRpdGxlc1Nob3dPblNraXBCYWNr"
        )
    }
}

private func readPrivateAccessibilityBoolean(_ base64Symbol: String) -> Bool? {
    guard let data = Data(base64Encoded: base64Symbol) else { return nil }

    let symbol = String(data: data, encoding: .utf8)

    let defaultScope = UnsafeMutableRawPointer(bitPattern: -2)
    guard let address = dlsym(defaultScope, symbol) else { return nil }

    typealias Getter = @convention(c) () -> UInt8
    let getter = unsafeBitCast(address, to: Getter.self)
    return getter() != 0
}
