import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    private(set) lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        var constraints = Array<NSLayoutConstraint>()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": label]
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": label]
            )
        )
        constraints.activate()
        label.textAlignment = .center
        label.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
