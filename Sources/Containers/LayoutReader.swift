import SwiftUI

/// A container view that provides a layout proxy, allowing you to query various layout properties usually only available via UIKit.
/// The most useful example is layout-relative to the `readableContentGuide`
public struct LayoutReader<Content: View>: UIViewControllerRepresentable {

    @State private var proxy: LayoutProxy = .zero
    private let content: (LayoutProxy) -> Content

    /// A new layout reader
    /// - Parameter content: The content for this view, the proxy provides layout-guide-relative frames for convenience
    public init(@ViewBuilder content: @escaping (LayoutProxy) -> Content) {
        self.content = content
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        LayoutController(proxy: $proxy, rootView: content(proxy))
    }

    public func updateUIViewController(_ controller: UIViewController, context: Context) {
        guard let controller = controller as? LayoutController<Content> else { return }
        controller.rootView = content(proxy)
    }

}

private final class LayoutController<Content: View>: UIHostingController<Content> {

    private let proxy: Binding<LayoutProxy>

    init(proxy: Binding<LayoutProxy>, rootView: Content) {
        self.proxy = proxy
        super.init(rootView: rootView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        proxy.wrappedValue = LayoutProxy(
            safeArea: view.safeAreaLayoutGuide.layoutFrame,
            content: view.layoutMarginsGuide.layoutFrame,
            readable: view.readableContentGuide.layoutFrame
        )
    }

}

public struct LayoutProxy {
    public enum Layout {
        case safeArea
        case content
        case readable
    }

    fileprivate let safeArea: CGRect
    fileprivate let content: CGRect
    fileprivate let readable: CGRect

    public func frame(in layout: Layout) -> CGRect {
        switch layout {
        case .safeArea:
            return safeArea
        case .content:
            return content
        case .readable:
            return readable
        }
    }
}

private extension LayoutProxy {
    static var zero = Self(safeArea: .zero, content: .zero, readable: .zero)
}
