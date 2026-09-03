# MediaAccessibilityKit

Swift and SwiftUI types for [MediaAccessibility](https://developer.apple.com/documentation/mediaaccessibility).

## Usage

Use `CaptionText` to display text with the viewer's current caption font, size, colors, background, window, and edge style:

```swift
import MediaAccessibilityKit

CaptionText("Welcome", baseSize: 28)
```

`CaptionText` observes caption-setting changes automatically. For a custom caption view, read a snapshot directly or install it in the SwiftUI environment:

```swift
let style = CaptionStyle.current
let color = style.text.swiftUIColor()
let font = style.text.swiftUIFont(baseSize: 28)

MyCaptionView()
  .mediaCaptionStyle()
```
