import UIKit
import SquareMosaicLayout

final class TRMosaicLayoutController: UIViewController, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: TRMosaicLayout())
        collection.register(UICollectionViewCell.self)
        collection.dataSource = self
        self.title = "TRMosaicLayout"
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

final class TRMosaicLayout: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }

    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return TRMosaicLayoutPattern()
    }
    
    func layoutSeparatorBetweenSections() -> CGFloat {
        return 0
    }
    
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
        return false
    }
    
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
    
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
}

class TRMosaicLayoutPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            TRMosaicLayoutBlock1(),
            TRMosaicLayoutBlock2()
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return 0.0
    }
}

public class TRMosaicLayoutBlock1: SquareMosaicBlock {
    
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

public class TRMosaicLayoutBlock2: SquareMosaicBlock {
    
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
