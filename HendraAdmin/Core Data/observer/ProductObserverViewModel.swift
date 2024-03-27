//
//  ProductObserverViewModel.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 14/03/2024.
//

import Foundation
import CoreData

class ProductObserverViewModel: NSObject {
    
    let context: NSManagedObjectContext
    
    var fetchResultsController: NSFetchedResultsController<Product>? = nil
    
    @Published var deleteProduct: Product? = nil
    @Published var isUpdatingFetch: Bool = false
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        createResultController(with: context)
        startFetching()
    }
    
    func createResultController(with context: NSManagedObjectContext) {
        let fetchRequest = Product.fetch(.all)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchResultsController = controller
        
    }
    
    func startFetching() {
        guard let controller = fetchResultsController else {return}
        
        do {
            try controller.performFetch()
        } catch {
            print("Unable to Perform Fetch Request for notes: \(error)")
        }
    }
}

extension ProductObserverViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        isUpdatingFetch = true
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let product = anObject as? Product else {return}

        switch type {
        case .insert:
            return
        case .delete:
            self.deleteProduct = product
        case .move:
            return
        case .update:
            return
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        isUpdatingFetch = false
    }
    
}
