import SwiftUI

/// A scrollview that behaves more similarly to a `VStack` when its content size is small enough.
public struct ScrollableView<Content: View>: View {

    private let content: Content
    private let showsIndicators: Bool
    private let contentMode: ContentMode

    /// A new scrollview
    /// - Parameters:
    ///   - showsIndicators: If true, the scroll view will show indicators when necessary
    ///   - contentMode: How the content should be sized. Defaults to `fill` which behaves identically to a standard `ScrollView`
    ///   - content: The content for this scroll view
    public init(showsIndicators: Bool = true, contentMode: ContentMode = .fit, @ViewBuilder content: () -> Content) {
        self.showsIndicators = showsIndicators
        self.contentMode = contentMode
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top) {
                    SwiftUI.ScrollView(showsIndicators: showsIndicators) {
                        VStack(spacing: 10) {
                            content
                        }
                        .frame(
                            maxWidth: contentMode == .fill ? geo.size.width : nil,
                            minHeight: contentMode == .fill ? geo.size.height : nil
                        )
                    }
                }
            }
        }
    }
}
