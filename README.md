![ios](https://img.shields.io/badge/iOS-13-green)

# Containers

Useful SwiftUI container view's for additional convenience.

Includes:

- FittingGeometryReader (auto-sizes its height)
- ScrollView (support various contentMode options)
- LayoutReader (supports readable and other other guides)

## FittingGeometry

A geometry reader that automatically sizes its height to 'fit' its content.

```swift
FittingGeometryReader { geo in
    Text("The height is now \(geo.size.height)")
}
```

## LayoutReader

A container view that provides a layout proxy, allowing you to query various layout properties usually only available via UIKit.

The most useful example is layout-relative to the `readableContentGuide`

__Features__

- Familiar API (similar to GeometryReader)
- SafeArea, content (layoutMargins) and readable content guide layouts
- Responds automatically to dynamic type changes
- Respects interface orientation and other layout changes

```swift
LayoutReader { layout in
    Rectangle()
        .foregroundColor(.red)
        .frame(maxWidth: layout.frame(in: .readable).width)
}
```

## ScrollView

A scrollview that behaves more similarly to a `VStack` when its content size is small enough.

```swift
ScrollView(contentMode: .fit) {
    Text("I'm aligned to the top")
    Spacer()
    Text("I'm aligned to the bottom, until you scroll ;)")
}
```

## Installation

The code is packaged as a framework. You can install manually (by copying the files in the `Sources` directory) or using Swift Package Manager (__preferred__)

To install using Swift Package Manager, add this to the `dependencies` section of your `Package.swift` file:

`.package(url: "https://github.com/SwiftUI-Plus/Containers.git", .upToNextMinor(from: "1.0.0"))`

## Other Packages

If you want easy access to this and more packages, add the following collection to your Xcode 13+ configuration:

`https://benkau.com/packages.json`
