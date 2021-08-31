import SwiftUI

/// A container view that provides a layout proxy, allowing you to query various layout properties usually only available via UIKit.
/// The most useful example is layout-relative to the `readableContentGuide`
public struct LayoutReader<Content: View>: View {

    @State private var proxy: LayoutProxy = .zero
    private let content: (LayoutProxy) -> Content

    /// A new layout reader
    /// - Parameter content: The content for this view, the proxy provides layout-guide-relative frames for convenience
    public init(@ViewBuilder _ content: @escaping (LayoutProxy) -> Content) {
        self.content = content
    }

    public var body: some View {
        Representable(proxy: $proxy) { layout in
            VStack(spacing: 0) { content(layout) }
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: proxy.size(in: .container).width)
        }
    }

}

private extension LayoutReader {

    struct Representable<Content: View>: UIViewRepresentable {

        let proxy: Binding<LayoutProxy>
        let content: (LayoutProxy) -> Content

        func makeCoordinator() -> Coordinator {
            Coordinator(content: content(proxy.wrappedValue), proxy: proxy)
        }

        func makeUIView(context: Context) -> UIView {
            context.coordinator.controller.view
        }

        func updateUIView(_ view: UIView, context: Context) {
            context.coordinator.update(content: content(proxy.wrappedValue))
        }

    }

}

private extension LayoutReader.Representable {

    final class Coordinator {
        let content: Content
        let controller: Controller

        init(content: Content, proxy: Binding<LayoutProxy>) {
            self.content = content
            controller = Controller(proxy: proxy, content: content)
            controller.view.setContentHuggingPriority(.required, for: .vertical)
            controller.view.setContentCompressionResistancePriority(.required, for: .vertical)
            controller.view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            controller.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            controller.view.backgroundColor = .clear
        }

        func update(content: Content) {
            controller.rootView = content
            controller.view.setNeedsDisplay()
        }
    }

    final class Controller: UIHostingController<Content> {
        private let proxy: Binding<LayoutProxy>

        init(proxy: Binding<LayoutProxy>, content: Content) {
            self.proxy = proxy
            super.init(rootView: content)
        }

        @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            let layout = LayoutProxy(
                safeArea: view.safeAreaLayoutGuide.layoutFrame,
                content: view.layoutMarginsGuide.layoutFrame,
                readable: view.readableContentGuide.layoutFrame,
                container: view.bounds
            )

            guard proxy.wrappedValue != layout else { return }
            proxy.wrappedValue = layout
        }
    }

}

/// A proxy for access to the size of the container view relative to a layout
public struct LayoutProxy: Equatable {
    public enum Layout {
        /// The safeArea relative layout
        case safeArea
        /// The layoutMargins relative layout
        case content
        /// The readableContent relative layout
        case readable
        /// The container relative layout
        case container
    }

    internal let safeArea: CGRect
    internal let content: CGRect
    internal let readable: CGRect
    internal let container: CGRect

    /// Returns the container's size, relative to the defined layout
    public func size(in layout: Layout) -> CGSize {
        switch layout {
        case .safeArea:
            return safeArea.size
        case .content:
            return content.size
        case .readable:
            return readable.size
        case .container:
            return container.size
        }
    }
}

internal extension LayoutProxy {
    static var zero = Self(safeArea: .zero, content: .zero, readable: .zero, container: .zero)
}
