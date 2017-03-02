import UIKit

final internal class DecorationView: UICollectionReusableView {
    
    var view: UIView? = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.view?.removeFromSuperview()
        self.view = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.prepare()
    }
    
    func prepare() {
        guard self.view == nil else { return }
        guard let collectionView = superview as? UICollectionView else { return }
        guard let layout = collectionView.collectionViewLayout as? SquareMosaicLayout else { return }
        guard let section = layout.object.decoration
            .filter({ $0.frame.rounded == frame.rounded })
            .map({ $0.indexPath.section }).first else { return }
        guard let view = layout.dataSource?.background?(section: section) else { return }
        self.view = view
        self.stratch(view)
    }
}

extension UIView {
    
    func stratch(_ view: UIView?) {
        guard let view = view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        var constraints = Array<NSLayoutConstraint>()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": view]
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": view]
            )
        )
        constraints.activate()
    }
}

extension CGRect {
    
    var rounded: CGRect {
        return CGRect(x: floor(origin.x), y: floor(origin.y), width: floor(width), height: floor(height))
    }
}

extension Collection where Iterator.Element == NSLayoutConstraint {
    
    func activate() {
        guard let constraints = self as? [NSLayoutConstraint] else { return }
        NSLayoutConstraint.activate(constraints)
    }
    
    func deactivate() {
        guard let constraints = self as? [NSLayoutConstraint] else { return }
        NSLayoutConstraint.deactivate(constraints)
    }
}
