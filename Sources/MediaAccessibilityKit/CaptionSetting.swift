/// A caption value and its precedence behavior.
public struct CaptionSetting<Value> {
    public let value: Value
    public let behavior: CaptionSettingBehavior

    public init(value: Value, behavior: CaptionSettingBehavior) {
        self.value = value
        self.behavior = behavior
    }

    /// Resolves the setting against an optional authored value.
    public func resolved(contentValue: Value?) -> Value {
        switch behavior {
        case .preferContent:
            contentValue ?? value
        case .overrideContent, .unknown:
            value
        }
    }
}

extension CaptionSetting: Sendable where Value: Sendable {}
extension CaptionSetting: Equatable where Value: Equatable {}
extension CaptionSetting: Hashable where Value: Hashable {}
