import SquareMosaicLayout
import UIKit

class ViewController: UIViewController {
    
    lazy var viewCollection: UICollectionView = self.getViewCollection()
    lazy var viewControl: UISegmentedControl = self.getViewControl()
    lazy var viewLayout: SquareMosaicLayout = self.getViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = viewControl
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(viewCollection)
    }
    
    @objc fileprivate func changeLayout() {
        viewCollection.setCollectionViewLayout(getViewLayout(), animated: true)
    }
}

fileprivate extension ViewController {
    
    func getViewCollection() -> UICollectionView {
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.viewLayout)
        view.backgroundColor = UIColor.groupTableViewBackground
        view.contentInset = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 50.0)
        view.register(CellView.self)
        view.register(SupplementaryView.self, identifier: SquareMosaicLayoutSectionFooter, kind: SquareMosaicLayoutSectionFooter)
        view.register(SupplementaryView.self, identifier: SquareMosaicLayoutSectionHeader, kind: SquareMosaicLayoutSectionHeader)
        view.register(DecorationView.self, identifier: SquareMosaicLayoutSectionBacker, kind: SquareMosaicLayoutSectionBacker)
        view.dataSource = self
        view.delegate = self
        return view
    }
    
    func getViewControl() -> UISegmentedControl {
        let view = UISegmentedControl(items: ["Mosaic Layout", "Grid Layout", "Single Layout"])
        view.addTarget(self, action: #selector(changeLayout), for: UIControlEvents.valueChanged)
        view.selectedSegmentIndex = 0
        return view
    }
    
    func getViewLayout() -> SquareMosaicLayout {
        switch viewControl.selectedSegmentIndex {
        case 0:
            return Layout(direction: .vertical, pattern: VerticalMosaicPattern())
        case 1:
            return Layout(direction: .vertical, pattern: VerticalTriplePattern())
        default:
            return Layout(direction: .vertical, pattern: VerticalSinglePattern())
        }
    }
}

final class Layout: SquareMosaicLayout, SMLSource {
    
//    let vertical: Bool
    var pattern: SMLPattern!

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(aspect: SMLObjectAspect? = nil, direction: SMLObjectDirection, pattern: SMLPattern) {
        self.init(aspect: aspect, direction: direction)
        self.pattern = pattern
    }
    
    required init(aspect: SMLObjectAspect?, direction: SMLObjectDirection) {
        super.init(aspect: aspect, direction: direction)
        self.source = self
    }
    
    func smlSourcePattern(section: Int) -> SMLPattern {
        switch section {
        case 2:     return VerticalSinglePattern()
        default:    return pattern
        }
    }
    
    func smlSourceSectionSpacing() -> CGFloat {
        return offset
    }
    
    func smlSourceBacker(section: Int) -> String? {
        return SquareMosaicLayoutSectionBacker
    }
    
    func smlSourceFooter(section: Int) -> SMLSupplementary? {
        return VerticalSupplementary(kind: SquareMosaicLayoutSectionFooter)
    }
    
    func smlSourceHeader(section: Int) -> SMLSupplementary? {
        return VerticalSupplementary(kind: SquareMosaicLayoutSectionHeader)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:     return 6
        case 1:     return 6
        case 2:     return 1
        default:    return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellView = collectionView.dequeueCell(indexPath: indexPath)
        switch indexPath.section {
        case 0:     cell.imageView.image = UIImage(named: "golf_\(indexPath.row % 6).jpeg")
        case 1:     cell.imageView.image = UIImage(named: "scirocco_\(indexPath.row % 6).jpeg")
        default:    cell.imageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SquareMosaicLayoutSectionBacker:
            let view: DecorationView = collectionView.dequeueSupplementary(kind, indexPath: indexPath, kind: kind)
            return view
        case SquareMosaicLayoutSectionFooter:
            let view: SupplementaryView = collectionView.dequeueSupplementary(kind, indexPath: indexPath, kind: kind)
            if #available(iOS 8.2, *) {
                view.label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
            } else {
                view.label.font = UIFont.systemFont(ofSize: 12)
            }
            switch indexPath.section {
            case 2:     view.label.text = "Tap to add!"
            default:    view.label.text = "View more..."
            }
            return view
        case SquareMosaicLayoutSectionHeader:
            let view: SupplementaryView = collectionView.dequeueSupplementary(kind, indexPath: indexPath, kind: kind)
            if #available(iOS 8.2, *) {
                view.label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
            } else {
                view.label.font = UIFont.systemFont(ofSize: 16)
            }
            switch indexPath.section {
            case 0:     view.label.text = "Golf VI"
            case 1:     view.label.text = "Scirocco"
            default:    view.label.text = "Your car?"
            }
            return view
        default:
            fatalError()
        }
    }
}
