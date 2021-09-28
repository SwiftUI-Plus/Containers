import SwiftUI

#if os(iOS)

/// A SwiftUI view that provides similar behaviour to a `UIPageViewController` that includes automatic sizing options.
@available(iOS 14, *)
public struct PageView<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {

    private var selection: Binding<SelectionValue>?
    private var contentMode: ContentMode
    private var content: () -> Content

    @State private var height: CGFloat = 10 // must be non-zero

    /// Makes a new page view
    /// - Parameters:
    ///   - selection: A binding to the currently selected page, can be used to keep a separate view in-sync
    ///   - contentMode: Apply `fit` to have the height automatically resize to fit the content. Defaults to `fill`
    ///   - content: The content for this page view. Each view will be shown on its own page
    public init(selection: Binding<SelectionValue>, contentMode: ContentMode = .fill, @ViewBuilder content: @escaping () -> Content) {
        self.selection = selection
        self.contentMode = contentMode
        self.content = content
    }

    public var body: some View {
        TabView(selection: selection) {
            content()
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) {
                    height = $0.height
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: contentMode == .fit ? height : nil)
    }

}

@available(iOS 14, *)
extension PageView where SelectionValue == Int {
    public init(contentMode: ContentMode = .fill, @ViewBuilder content: @escaping () -> Content) {
        self.selection = .constant(0)
        self.contentMode = contentMode
        self.content = content
    }
}

@available(iOS 14, *)
struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(contentMode: .fill) {
            Text("Page 1")
            Text("Page 2")
            Text("Page 3")
        }
        .previewLayout(.sizeThatFits)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct SizeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                Color.clear.preference(key: SizePreferenceKey.self, value: geo.size)
            }
        )
    }
}

#endif
