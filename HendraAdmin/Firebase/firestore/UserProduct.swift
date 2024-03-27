//
//  UserProduct.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 26/03/2024.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



struct DBProduct: Codable {
    let userId: String
    let productId: String
    let dateCreated: Date?
    var type: String?
    var genre: String?
    let ThumbnailImageUrl: [String]?
    let fullImageUrl: [String]?
    let usdzUrl: [String]?
    let usdzImageUrl: [String]?

    
    init(product: Product, userId: String) {
        self.userId = userId
        self.productId = product.uuid.uuidString
        self.dateCreated = Date()
        self.type = product.type.rawValue
        self.genre = product.genre
        self.ThumbnailImageUrl = nil
        self.fullImageUrl = nil
        self.usdzUrl = nil
        self.usdzImageUrl = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case productId = "product_id"
        case dateCreated = "date_created"
        case type = "type"
        case genre = "genre"
        case ThumbnailImageUrl = "thumbnail_image_url"
        case fullImageUrl = "full_image_url"
        case usdzUrl = "usdz_url"
        case usdzImageUrl = "usdz_image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.genre = try container.decodeIfPresent(String.self, forKey: .genre)
        self.ThumbnailImageUrl = try container.decodeIfPresent([String].self, forKey: .ThumbnailImageUrl)
        self.fullImageUrl = try container.decodeIfPresent([String].self, forKey: .fullImageUrl)
        self.usdzUrl = try container.decodeIfPresent([String].self, forKey: .usdzUrl)
        self.usdzImageUrl = try container.decodeIfPresent([String].self, forKey: .usdzImageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.genre, forKey: .genre)
        try container.encodeIfPresent(self.ThumbnailImageUrl, forKey: .ThumbnailImageUrl)
        try container.encodeIfPresent(self.fullImageUrl, forKey: .fullImageUrl)
        try container.encodeIfPresent(self.usdzUrl, forKey: .usdzUrl)
        try container.encodeIfPresent(self.usdzImageUrl, forKey: .usdzImageUrl)
    }
}

final class DBProductManager {
    
    static let shared = DBProductManager()
    
    private init () {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(_ userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private func productDocument(userId: String, productId: String) -> DocumentReference  {
        userDocument(userId).collection("products").document(productId)
    }
    
    private var encoder: Firestore.Encoder  {
        let encoder = Firestore.Encoder()
        return encoder
    }
    
    private var decoder: Firestore.Decoder  {
        let decoder = Firestore.Decoder()
        return decoder
    }
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    func createNewProduct(userId: String,  product: DBProduct)  throws {
        try  productDocument(userId: userId, productId: product.productId)
            .setData(from: product, merge: false)
    }
    
    func updatedfullImageUrl(product: DBProduct, url:  String)   {
        let data: [String: Any?] = [
            DBProduct.CodingKeys.fullImageUrl.rawValue: FieldValue.arrayUnion([url])
            
        ]
        productDocument(userId: product.userId, productId: product.productId).updateData(data as [AnyHashable : Any]) { error in
            if let error = error {
                print("updatedfullImageUrl error: \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    
    func updatedThumbnailImageUrl(product: DBProduct, url:  String)   {
        let data: [String: Any?] = [
            DBProduct.CodingKeys.ThumbnailImageUrl.rawValue: FieldValue.arrayUnion([url])
            
        ]
        productDocument(userId: product.userId, productId: product.productId).updateData(data as [AnyHashable : Any]) { error in
            if let error = error {
                print("updatedThumbnailImageUrl error: \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func updatedusdzUrl(product: DBProduct, url:  String)   {
        let data: [String: Any?] = [
            DBProduct.CodingKeys.usdzUrl.rawValue: FieldValue.arrayUnion([url])
            
        ]
        productDocument(userId: product.userId, productId: product.productId).updateData(data as [AnyHashable : Any]) { error in
            if let error = error {
                print("updatedusdzUrl error: \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func updateusdzImageUrl(product: DBProduct, url:  String)   {
        let data: [String: Any?] = [
            DBProduct.CodingKeys.usdzImageUrl.rawValue: FieldValue.arrayUnion([url])
            
        ]
        productDocument(userId: product.userId, productId: product.productId).updateData(data as [AnyHashable : Any]) { error in
            if let error = error {
                print("updateusdzImageUrl error: \(String(describing: error.localizedDescription))")
            }
        }
    }
    
}
