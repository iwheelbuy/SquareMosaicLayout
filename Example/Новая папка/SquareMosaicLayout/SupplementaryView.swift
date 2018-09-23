import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    private(set) lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.frame = bounds
        label.textAlignment = .center
        label.textColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
