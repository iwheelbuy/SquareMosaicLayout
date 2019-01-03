import CoreGraphics
import Foundation

public protocol SMLayoutDelegate: class {
    
    func smLayoutDelegateChanged(collectionViewContentSize: CGSize)
}
