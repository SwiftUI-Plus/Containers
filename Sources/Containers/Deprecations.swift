import SwiftUI

extension LayoutProxy {
    @available(*, deprecated, renamed: "size(in:)", message: "Please use size(in:) instead")
    public func frame(in layout: Layout) -> CGRect {
        switch layout {
        case .safeArea:
            return safeArea
        case .content:
            return content
        case .readable:
            return readable
        case .container:
            return container
        }
    }
}

@available(swift, obsoleted: 1.0, renamed: "ScrollableView")
public typealias ScrollView = ScrollableView
