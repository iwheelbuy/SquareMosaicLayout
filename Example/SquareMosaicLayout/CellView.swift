import UIKit

final class CellView: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.imageView.frame = bounds
        self.imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.imageView.contentMode = .scaleAspectFill
        self.contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

