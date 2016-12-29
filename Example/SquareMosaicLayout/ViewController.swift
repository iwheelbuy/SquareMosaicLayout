//
//  ViewController.swift
//

import SquareMosaicLayout
import UIKit

class ViewController: UIViewController {
   
   lazy var count: Int = {
      return 1
   }()
   lazy var viewLayout: SquareMosaicLayout = {
      let layout = SquareMosaicLayout()
      layout.delegate = self
      layout.prepare()
      return layout
   }()
   lazy var viewCollection: UICollectionView = {
      let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.viewLayout)
      view.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
      view.contentInset = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
      view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
      view.dataSource = self
      view.delegate = self
      return view
   }()
   lazy var viewButtonAdd: UIBarButtonItem = {
      let view = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(add))
      view.tintColor = .black
      return view
   }()
   lazy var viewButtonRemove: UIBarButtonItem = {
      let view = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(remove))
      view.tintColor = .black
      return view
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "UICollectionView animation"
      self.navigationItem.rightBarButtonItem = viewButtonAdd
      self.navigationItem.leftBarButtonItem = viewButtonRemove
      self.view.addSubview(viewCollection)
   }
   
   @objc private func add() {
      count += 1
      let sectionUpdates = CollectionSectionUpdates(delete: IndexSet(), insert: IndexSet())
      let insert = [IndexPath.init(row: 0, section: 0)]
      let rowUpdates = CollectionRowUpdates(delete: [], insert: insert, reload: [])
      let updates = CollectionUpdates(rowUpdates: rowUpdates, sectionUpdates: sectionUpdates)
      viewCollection.reloadData(updates)
   }
   
   @objc private func remove() {
      let sectionUpdates = CollectionSectionUpdates(delete: IndexSet(), insert: IndexSet())
      var delete = [IndexPath]()
      for row in 0..<count {
         delete.append(IndexPath.init(row: row, section: 0))
      }
      count = 0
      let rowUpdates = CollectionRowUpdates(delete: delete, insert: [], reload: [])
      let updates = CollectionUpdates(rowUpdates: rowUpdates, sectionUpdates: sectionUpdates)
      viewCollection.reloadData(updates)
   }
}

extension ViewController: SquareMosaicLayoutDelegate {
   
   var padding: CGFloat {
      return 6.0
   }
   
   var pattern: SquareMosaicPattern {
      return SnakeSquareMosaicPattern()
   }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
      cell.backgroundColor = .black
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let sectionUpdates = CollectionSectionUpdates(delete: IndexSet(), insert: IndexSet())
      let delete = [IndexPath.init(row: indexPath.row, section: 0)]
      count -= 1
      let rowUpdates = CollectionRowUpdates(delete: delete, insert: [], reload: [])
      let updates = CollectionUpdates(rowUpdates: rowUpdates, sectionUpdates: sectionUpdates)
      collectionView.reloadData(updates)
   }
}

extension UICollectionView {
   
   func reloadData(_ updates: CollectionUpdates) {
      DispatchQueue.main.async { [weak self] in
         self?.performBatchUpdates({
            self?.deleteItems(at: updates.rowUpdates.delete)
            self?.reloadItems(at: updates.rowUpdates.reload)
            self?.insertItems(at: updates.rowUpdates.insert)
            self?.deleteSections(updates.sectionUpdates.delete)
            self?.insertSections(updates.sectionUpdates.insert)
         })
      }
   }
}
