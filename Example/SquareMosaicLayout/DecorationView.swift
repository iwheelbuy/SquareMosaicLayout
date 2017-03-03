import UIKit

final class DecorationView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.cornerRadius = offset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
