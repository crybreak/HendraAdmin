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
    
    func createTokenPredicates(token: ProductSearchToken) -> NSPredicate? {
       var predicates = [NSPredicate]()
       
    
        switch token {
        case .uploaddStatus:
            predicates.append(createUploadPredicate(status: .uploaddStatus))
        case .draftStatus:
            predicates.append(createUploadPredicate(status: .draftStatus))
        case .last7Days:
            predicates.append(createLast7DaysPredicate())
        case .usdz:
            predicates.append(createLastUsdzPredicate())
        case .photos:
            predicates.append(createImagePredicate())
            
        }
       
       if predicates.count == 0 {
           return nil
       } else if predicates.count == 1 {
           return predicates.first
       } else {
           return NSCompoundPredicate(orPredicateWithSubpredicates: predicates )
       }
   }
   
   
    func createUploadPredicate(status: ProductSearchToken) -> NSPredicate {
        if status == .uploaddStatus {
            return NSPredicate(format: "%K == true", ProductProperties.send)
        } else {
            return NSPredicate(format: "%K == false", ProductProperties.send)
        }
   }
   
   
   
   private func createLast7DaysPredicate() -> NSPredicate {
       let calendar = Calendar.current
       
       let beginDate = calendar.date(byAdding: .day, value: -7, to: Date())!
       return NSPredicate(format: "%K > %@", ProductProperties.creationDate,
                                           beginDate as NSDate)
   }
   
   
    func createLastUsdzPredicate() -> NSPredicate {
        return NSPredicate(format: "%K.@count > 0", ProductProperties.usdz)
    }
   
   func createImagePredicate() -> NSPredicate {
       return NSPredicate(format: "%K.@count > 0", ProductProperties.images)
   }
}
