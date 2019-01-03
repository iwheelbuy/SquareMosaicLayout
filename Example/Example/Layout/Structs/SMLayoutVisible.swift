import UIKit

struct SMLayoutVisible {
    
    private let bounds: CGRect
    let direction: SMLayoutDirection
    
    init?(bounds: CGRect, direction: SMLayoutDirection) {
        self.bounds = bounds
        self.direction = direction
        guard length > 0 else {
            return nil
        }
    }
    
    private var length: CGFloat {
        switch direction {
        case .vertical:
            return bounds.height
        case .horizontal:
            return bounds.width
        }
    }
    
    private var origin: CGFloat {
        switch direction {
        case .vertical:
            return bounds.origin.y
        case .horizontal:
            return bounds.origin.x
        }
    }
    
    var range: ClosedRange<CGFloat> {
        return origin ... length + origin
    }
}
