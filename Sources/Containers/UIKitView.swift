import SwiftUI

/// A SwiftUI view that accepts a single UIView instance to be presented in the hierarchy.
///
/// Note: Some views do not automatically size correctly and may require special handling. This may provide some convenience however in other cases.
public struct UIKitView<Content: UIView>: View {

    @State private var height: CGFloat = 10
    private let content: Content

    public init(@UIViewBuilder _ content: () -> Content) {
        self.content = content()
        self.content.backgroundColor = .clear
    }

    public var body: some View {
        Representable(content: content, height: $height)
            .frame(height: height)
    }
}

private extension UIKitView {

    struct Representable<Content: UIView>: UIViewRepresentable {
        let content: Content
        let height: Binding<CGFloat>

        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }

        func makeUIView(context: Context) -> Content {
            context.coordinator.content
        }

        func updateUIView(_ view: Content, context: Context) {
            Self.calculateHeight(view: view, result: height)
            context.coordinator.update(content: view)
        }

        fileprivate static func calculateHeight(view: UIView, result: Binding<CGFloat>) {
            let newSize = view.sizeThatFits(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude))
            guard result.wrappedValue != newSize.height else { return }
            DispatchQueue.main.async { // call in next render cycle.
                result.wrappedValue = newSize.height
            }
        }
    }

}

private extension UIKitView.Representable {

    final class Coordinator {
        let content: Content

        init(content: Content) {
            self.content = content
            content.setContentHuggingPriority(.defaultLow, for: .horizontal)
            content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            content.backgroundColor = .clear
        }

        func update(content: Content) {
            content.setNeedsDisplay()
        }
    }

}

@resultBuilder
public struct UIViewBuilder {
    public static func buildBlock(_ components: UIView) -> UIView {
        components
    }
}
