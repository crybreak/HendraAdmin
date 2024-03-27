//
//  User.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import CoreData

extension Users {
    
    var uuid: UUID  {
#if DEBUG
        self.uuid_!
#else
        self.uuid_ ?? UUID()
#endif
    }
    
    var name: String {
        get { self.name_ ?? "" }
        set (newValue) { self.name_ = newValue }
    }

    
    var email: String {
        get { self.email_ ?? "" }
        set (newValue) { self.email_ = newValue }
    }
    
    var phoneNumber: String {
        get { self.phoneNumber_ ?? "" }
        set (newValue) { self.phoneNumber_ = newValue }
    }
    

    var country: Country {
        get {
            if let rawCountry = self.country_, let country = Country(rawValue: rawCountry) {
                return country
            } else {
                return Country.BN
            }
        }
        set (newValue) { self.country_ = newValue.rawValue }
    }

    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
    
    var prctsodu: Set<Product> {
        get { (self.products_ as? Set<Product>) ?? [] }
        set {self.products_ = newValue as NSSet}
    }
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
        self.uuid_ = UUID()

    }
    
    static func fetch(_ predicate: NSPredicate ) -> NSFetchRequest<Users> {
        let request = NSFetchRequest<Users>(entityName: "Users")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Users.creationDate_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func delete(_ user: Users) {
        guard let context = user.managedObjectContext else {return}
        context.delete(user)
    }
    
}

struct UserProperties {
    static let uuid = "uuid_"

    static let country = "country_"
    static let name = "name_"
    static let email = "email_"
    
    static let phoneNumber = "phoneNumber_"
    static let creationDate_ = "creationDate_"

}


extension Users {
    static func nestedUserExemple(context: NSManagedObjectContext) -> Users {
        let user = Users(name: "Wilfried GOSSAN", context: context)
        user.email = "gossanguy1@gmail.com"
        user.phoneNumber = "69 59 32 21"
        user.country = Country.BN
        return user
    }
}
