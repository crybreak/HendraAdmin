//
//  Product.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import CoreData

extension Product {
    
    var uuid: UUID  {
#if DEBUG
        self.uuid_!
#else
        self.uuid_ ?? UUID()
#endif
    }
    
    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
    
    var send: Bool {
        get {  self.send_}
        set (newValue){ self.send_ = newValue}
    }
    
    
    var name: String {
        get { self.name_ ?? "" }
        set (newValue) { self.name_ = newValue }
    }
    
    var type: Type {
        get{
            if let rawType = self.type_, let type = Type(rawValue: rawType) {
                return type
            } else {
                return Type.meuble
            }
        }
        set (newValue) { self.type_ = newValue.rawValue }
        
    }
   
    var images: Set<AttahcmentImage> {
        get { (self.images_ as? Set<AttahcmentImage>) ?? [] }
        set {self.images_ = newValue as NSSet}
    }
    
    var usdz: Set<AttahcmentUSDZ> {
        get { (self.usdz_ as? Set<AttahcmentUSDZ>) ?? [] }
        set {self.usdz_ = newValue as NSSet}
    }
    
    
    
    var genre: String {
        get {self.genre_ ?? "" }
        set (newValue) { self.genre_ = newValue}
    }
    
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.uuid_ = UUID()
        self.send_ = false

    }
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
    }
    
    static func fetch(_ predicate: NSPredicate ) -> NSFetchRequest<Product> {
        let request = NSFetchRequest<Product>(entityName: "Product")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Product.creationDate_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    
    static func fetch(_ uuidString: String, context: NSManagedObjectContext)-> Product? {
        guard let uuid = UUID(uuidString: uuidString) else {return nil}
        return Product.fetch(uuid, context: context)
    }
    
    static func fetch (_ uuid: UUID, context: NSManagedObjectContext) -> Product? {
        let predicate = NSPredicate(format:  "%K == %@", UserProperties.uuid, uuid as CVarArg)
        let request = Product.fetch(predicate)
        request.fetchLimit = 1
        
        if let products = try? context.fetch(request), let product = products.first {
            return product
        } else {
            return nil
        }
    }
    
    static func delete(_ product: Product) {
        
        guard let context = product.managedObjectContext else {return}
        context.delete(product)
    }
    
    
    func addUSDZ(url: URL, usdz: Data, attachment: AttahcmentUSDZ?)  {
        if attachment != nil {
            attachment?.data_ = usdz
            attachment?.url = url
            attachment?.thumbnailImageData_ = nil
        } else {
            guard let context = self.managedObjectContext else {return}
            let attachment = AttahcmentUSDZ(url: url, usdz: usdz, context: context)
            attachment.product = self
        }
    }
    
    func addImage(imageData: Data, attachment: AttahcmentImage?)  {
        if let attachment = attachment {
            attachment.fullImageData_ = imageData
            attachment.thumbnailData_ = nil
        } else {
            guard let context = self.managedObjectContext else {return}
            let attachment = AttahcmentImage(image: imageData, context: context)
            attachment.product = self
        }
    }
}


// Product Helper

struct ProductProperties {
    static let uuid = "uuid_"

    static let name = "name_"
    static let type = "type_"
    static let genre = "genre_"
    static let creationDate = "creationDate_"
    
    static let user = "user"
    static let usdz = "usdz_"
    static let images = "images_"
    static let send = "send_"
}



extension Product
{
    static func example() -> Product {
        let context = PersistenceController.preview.container.viewContext
        let product = Product(name: "Chair", context: context)
        product.type = Type.meuble
        product.user = Users.nestedUserExemple(context: context)
        
        product.user = Users.nestedUserExemple(context: context)
        return product
    }
    
}
