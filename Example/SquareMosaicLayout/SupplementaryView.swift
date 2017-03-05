import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    private(set) lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        addSubview(label)
        label.frame = bounds
        label.textAlignment = .center
        label.textColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
