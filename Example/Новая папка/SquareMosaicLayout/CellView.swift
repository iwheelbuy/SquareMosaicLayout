import UIKit

final class CellView: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.imageView.contentMode = .scaleAspectFill
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
            imageView.frame = bounds
        }
    }
}
