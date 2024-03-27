//
//  NavigationStateManager + Observer.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 14/03/2024.
//

import Foundation
import CoreData

extension NavigationStateManager {
    func createProductObserverTrigger() {
        
        let context = PersistenceController.shared.container.viewContext
        productObserver = ProductObserverViewModel(context: context)
        
        productObserver?.$deleteProduct .sink(receiveValue: { [unowned self] product in

            if self.selectedProduct?.uuid == product?.uuid {
                self.selectedProduct = nil
            }
        })
        .store(in: &subscriptions)
    }
    
    func createUserObserverTrigger() {
        
        let context = PersistenceController.shared.container.viewContext
        userObserver = UserObserverViewModel(context: context)
        
        userObserver?.$deleteuser.sink(receiveValue: { [unowned self] user in

            if self.selectedUser?.uuid == user?.uuid {
                self.selectedUser = nil
            }
        })
        .store(in: &subscriptions)
    }
}

