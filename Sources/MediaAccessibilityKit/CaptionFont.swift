import CoreText

/// A caption font backed by a Core Text descriptor.
public struct CaptionFont: @unchecked Sendable, Hashable {
    public let descriptor: CTFontDescriptor

    public init(descriptor: CTFontDescriptor) {
        self.descriptor = descriptor
    }
}
