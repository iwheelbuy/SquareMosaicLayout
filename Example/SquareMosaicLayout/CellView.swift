import UIKit

final class CellView: UICollectionViewCell {
    
    private(set) lazy var view = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        view.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true
        clipsToBounds = true
        view.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

