//
//  CollectionUpdates.swift
//

import UIKit

struct CollectionRowUpdates {
   
   let delete: [IndexPath]
   let insert: [IndexPath]
   let reload: [IndexPath]
}

struct CollectionSectionUpdates {
   
   let delete: IndexSet
   let insert: IndexSet
}

struct CollectionUpdates {
   
   let rowUpdates:     CollectionRowUpdates
   let sectionUpdates: CollectionSectionUpdates
   
   static var empty: CollectionUpdates {
      let rowUpdates = CollectionRowUpdates(delete: [], insert: [], reload: [])
      let sectionUpdates = CollectionSectionUpdates(delete: IndexSet(), insert: IndexSet())
      return CollectionUpdates(rowUpdates: rowUpdates, sectionUpdates: sectionUpdates)
   }
   
   var nonEmpty: Bool {
      let counts = [
         rowUpdates.delete.count,
         rowUpdates.insert.count,
         rowUpdates.reload.count,
         sectionUpdates.delete.count,
         sectionUpdates.insert.count
      ]
      return counts.filter{$0>0}.count > 0
   }
   
   var empty: Bool {
      return !nonEmpty
   }
}
