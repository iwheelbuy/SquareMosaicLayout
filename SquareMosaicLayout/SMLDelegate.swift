import Foundation

public protocol SMLDelegate: class {
    
    func smlDelegateChanged(collectionViewContentSize: CGSize) -> Void
}
