# MediaAccessibilityKit

Swift and SwiftUI types for Apple's [MediaAccessibility](https://developer.apple.com/documentation/mediaaccessibility) caption settings.

## Usage

Use `CaptionText` to display text with the viewer's current caption font, size, colors, background, window, and edge style:

```swift
import MediaAccessibilityKit

CaptionText("Welcome", baseSize: 28)
```