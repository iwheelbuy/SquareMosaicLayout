import UIKit
import SquareMosaicLayout

final class Hungcao: UIViewController, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: HungcaoLayout())
        collection.backgroundColor = UIColor.white
        collection.contentInset = UIEdgeInsets(top: 60.0, left: 20.0, bottom: 10.0, right: 20.0)
        collection.register(UICollectionViewCell.self)
        collection.register(UICollectionReusableView.self, identifier: SquareMosaicLayoutSectionBacker, kind: SquareMosaicLayoutSectionBacker)
        collection.register(UICollectionReusableView.self, identifier: SquareMosaicLayoutSectionHeader, kind: SquareMosaicLayoutSectionHeader)
        collection.dataSource = self
        self.title = "Hungcao"
        self.view = collection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.text = "Cell \(indexPath.row)"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.frame = cell.contentView.bounds
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SquareMosaicLayoutSectionBacker:
            let view: UICollectionReusableView = collectionView.dequeueSupplementary(kind, indexPath: indexPath, kind: kind)
            view.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
            view.layer.cornerRadius = 10.0
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.black.cgColor
            return view
        case SquareMosaicLayoutSectionHeader:
            let view: UICollectionReusableView = collectionView.dequeueSupplementary(kind, indexPath: indexPath, kind: kind)
            view.layer.backgroundColor = UIColor.clear.cgColor
            
            let label = UILabel()
            label.text = "header"
            label.font = UIFont.systemFont(ofSize: 20)
            label.textAlignment = .center
            label.frame = view.bounds
            view.addSubview(label)
            
            return view
        default:
            fatalError()
        }
    }
}

final class HungcaoLayout: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return HungcaoPattern()
    }
    
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
        return true
    }
    
    func layoutSeparatorBetweenSections() -> CGFloat {
        return 60.0
    }
    
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary? {
        return HungcaoSupplementary()
    }
}

final class HungcaoSupplementary: SquareMosaicSupplementary {
    
    func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: side, height: 60)
    }
}

final class HungcaoPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [HungcaoBlock()]
    }
}

public class HungcaoBlock: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 4
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let width = side / 2.0
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: width, height: 80))
        frames.append(CGRect(x: width, y: origin, width: width, height: 80))
        frames.append(CGRect(x: 0, y: origin + 80, width: width, height: 80))
        frames.append(CGRect(x: width, y: origin + 80, width: width, height: 80))
        return frames
    }
}
