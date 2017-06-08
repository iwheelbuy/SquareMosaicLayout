import UIKit
import SquareMosaicLayout

final class TRMosaicLayoutCopyController: UIViewController, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: TRMosaicLayoutCopy())
        collection.register(UICollectionViewCell.self)
        collection.dataSource = self
        self.title = "TRMosaicLayoutCopy"
        self.view = collection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.init(white: (30.0 + CGFloat(indexPath.row * 4)) / 255.0, alpha: 1.0)
        return cell
    }
}

final class TRMosaicLayoutCopy: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }

    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return TRMosaicLayoutCopyPattern()
    }
}

class TRMosaicLayoutCopyPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            TRMosaicLayoutCopyBlock1(),
            TRMosaicLayoutCopyBlock2()
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return 0.0
    }
}

public class TRMosaicLayoutCopyBlock1: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let minWidth = side / 3.0
        let maxWidth = side - minWidth
        let minHeight = minWidth * 1.5
        let maxHeight = minHeight + minHeight
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: maxWidth, height: maxHeight))
        frames.append(CGRect(x: maxWidth, y: origin, width: minWidth, height: minHeight))
        frames.append(CGRect(x: maxWidth, y: origin + minHeight, width: minWidth, height: minHeight))
        return frames
    }
}

public class TRMosaicLayoutCopyBlock2: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let minWidth = side / 3.0
        let maxWidth = side - minWidth
        let minHeight = minWidth * 1.5
        let maxHeight = minHeight + minHeight
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: minWidth, height: minHeight))
        frames.append(CGRect(x: 0, y: origin + minHeight, width: minWidth, height: minHeight))
        frames.append(CGRect(x: minWidth, y: origin, width: maxWidth, height: maxHeight))
        return frames
    }
}
