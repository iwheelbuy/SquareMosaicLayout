import UIKit

final class ViewController: UIViewController {
    
    private lazy var viewCollection: UICollectionView = self.getViewCollection()
    private lazy var viewCollectionLayout: UICollectionViewLayout = self.getViewCollectionLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        self.view.addSubview(viewCollection)
        let constraints = [
            viewCollection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            viewCollection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            viewCollection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            viewCollection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        viewCollection.dataSource = self
        viewCollection.delegate = self
    }
}

private extension ViewController {
    
    func getViewCollection() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.viewCollectionLayout)
        view.backgroundColor = UIColor.yellow
        view.alwaysBounceVertical = true
        view.contentInset = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 50.0)
        view.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: Layout.Constants.backer0, withReuseIdentifier: Layout.Constants.backer0)
        view.register(Supplementary.self, forSupplementaryViewOfKind: Layout.Constants.footer0, withReuseIdentifier: Layout.Constants.footer0)
        view.register(Supplementary.self, forSupplementaryViewOfKind: Layout.Constants.header0, withReuseIdentifier: Layout.Constants.header0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func getViewCollectionLayout() -> SMLayout {
        return Layout(offset: 10)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 24
        case 1:
            return 12
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath)
        cell.backgroundColor = .cyan
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case Layout.Constants.backer0, Layout.Constants.footer0, Layout.Constants.header0:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
            switch kind {
            case Layout.Constants.footer0, Layout.Constants.header0:
                view.backgroundColor = .orange
            default:
                view.backgroundColor = .white
            }
            return view
        default:
            fatalError()
        }
    }
}
