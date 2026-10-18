import Foundation
import Synchronization

/// Registers before reading the initial snapshot so changes during startup are observed.
@MainActor
func preferenceUpdates<Value: Sendable>(
    named name: Notification.Name,
    center: NotificationCenter = .default,
    read: @escaping @MainActor @Sendable () -> Value
) -> AsyncStream<Value> {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
        let observation = Mutex<(any NSObjectProtocol)?>(nil)
        observation.withLock { token in
            token = center.addObserver(forName: name, object: nil, queue: nil) { _ in
                Task { @MainActor in
                    guard observation.withLock({ $0 != nil }) else { return }
                    continuation.yield(read())
                }
            }
        }
        continuation.onTermination = { _ in
            observation.withLock { token in
                if let token {
                    center.removeObserver(token)
                }
                token = nil
            }
        }
        continuation.yield(read())
    }
}
