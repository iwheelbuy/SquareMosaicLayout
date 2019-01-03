import CoreGraphics
import Foundation

final class SMLayoutFrame {
    
    private let direction: SMLayoutDirection
    private(set) var frame: CGRect
    
    init(direction: SMLayoutDirection, frame: CGRect) {
        self.direction = direction
        self.frame = frame
    }
    
    var length: CGFloat {
        get {
            switch direction {
            case .horizontal:
                return frame.size.width
            case .vertical:
                return frame.size.height
            }
        }
        set {
            switch direction {
            case .horizontal:
                frame.size.width = newValue
            case .vertical:
                frame.size.height = newValue
            }
        }
    }
    
    var offset: CGFloat {
        get {
            switch direction {
            case .horizontal:
                return frame.origin.x
            case .vertical:
                return frame.origin.y
            }
        }
        set {
            switch direction {
            case .horizontal:
                frame.origin.x = newValue
            case .vertical:
                frame.origin.y = newValue
            }
        }
    }
}
