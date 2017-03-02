import UIKit

extension Collection where Iterator.Element == NSLayoutConstraint {
    
    func activate() {
        guard let constraints = self as? [NSLayoutConstraint] else { return }
        NSLayoutConstraint.activate(constraints)
    }
}
