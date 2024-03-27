//
//  Predicate + Helper.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import Foundation
import CoreData

extension NSPredicate {
    
    static let all = NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
}

class NSpredicateHelper {
    
    func createScopePredicate(user: Users) -> NSPredicate? {
        return NSPredicate(format: "%K == %@", ProductProperties.user, user)
    }
    
    func createSearchUserPredicate(text: String) -> NSPredicate? {
        
        guard text.count > 0 else {return nil}
        
        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", UserProperties.name, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", UserProperties.email, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", UserProperties.phoneNumber, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", UserProperties.country, text as CVarArg)]
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    func createSearchProductPredicate(text: String) -> NSPredicate? {
        
        guard text.count > 0 else {return nil}
        
        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", ProductProperties.name, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", ProductProperties.type, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", ProductProperties.genre , text as CVarArg)]
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
}
