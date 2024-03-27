//
//  StorageManager.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 22/03/2024.
//


import Foundation
import FirebaseStorage
import UIKit
import Combine

final class StorageManager {
    static let shared = StorageManager()
    
    private init () {}
    
    private let storage = Storage.storage().reference()
    
    private var imageReference: StorageReference {
        storage.child("users")
    }
    

    func saveImage(image: AttahcmentImage, userId: String, type: String, 
                   product: Product) -> Future<StorageMetadata?, Error> {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let data: Data
        
        if type.contains("ThumbnaiData") {
            data = image.thumbnailData_!
        } else {
            data = image.fullImageData_!
        }
        let path = "\(image.creationDate.description).jpeg"
        
        
        return Future <StorageMetadata?, Error>  {[self] promise in
            self.imageReference.child(userId).child("Product")
                .child(product.name + " " + product.genre + " " + product.type.rawValue)
                .child(type)
                .child(path).putData(data, metadata: meta) { storage, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(Result.failure(error))
                } else {
                    image.send = true
                    if let path = storage?.path {
                        self.getUrlForPath(path: path) { url in
                            if let url = url {
                                if type.contains("ThumbnaiData") {
                                    DBProductManager.shared
                                        .updatedThumbnailImageUrl(product: DBProduct(product: product, userId: userId),
                                                                  url: url.absoluteString)
                                } else {
                                    DBProductManager.shared
                                        .updatedfullImageUrl(product: DBProduct(product: product, userId: userId),
                                                                                url: url.absoluteString)
                                }
                                 
                            }
                        }
                    }
                    print(storage?.path ?? "")
                    promise(Result.success(storage))
                }
            }
        }
    }
    
    func saveUsdz(usdz: AttahcmentUSDZ, userId: String,
                  product: Product) -> Future<StorageMetadata?, Error> {
        let meta = StorageMetadata()
        meta.contentType = "application/octet-stream"
        
        let path = "\(usdz.creationDate.description).usdz"
        
        return Future <StorageMetadata?, Error>  { [self] promise in
            self.imageReference.child(userId).child("Product")
                .child(product.name + " " + product.genre + " " + product.type.rawValue)
                .child("USDZ")
                .child(path)
                .putData(usdz.data_!, metadata: meta) { storage, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(Result.failure(error))
                } else {
                    usdz.send = true
                    if let path = storage?.path {
                        self.getUrlForPath(path: path) { url in
                            if let url = url {
                                DBProductManager.shared
                                    .updatedusdzUrl(product: DBProduct(product: product,
                                                                       userId: userId), url: url.absoluteString)
                            }
                        }
                    }
                    promise(Result.success(storage))
                }
            }
        }
    }
    
    func saveUsdzImage(usdz: AttahcmentUSDZ, userId: String, 
                       product: Product)  -> Future<StorageMetadata?, Error> {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(usdz.creationDate.description).jpeg"
        
        return Future <StorageMetadata?, Error>  { [self] promise in
            guard let data = UIImage(data: usdz.thumbnailImageData_!)?.jpegData(compressionQuality: 1.0) else {
                promise(Result.failure(URLError(.backgroundSessionWasDisconnected)))
                return
            }
            
            self.imageReference.child(userId).child("Product")
                .child(product.name + " " + product.genre + " " + product.type.rawValue)
                .child("USDZ")
                .child(path)
                .putData(data, metadata: meta) { storage, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(Result.failure(error))
                } else {
                    usdz.send = true
                    if let path = storage?.path {
                        self.getUrlForPath(path: path) { url in
                            if let url = url {
                                DBProductManager.shared
                                    .updateusdzImageUrl(product: DBProduct(product: product,
                                                                           userId: userId), url: url.absoluteString)
                            }
                        }
                    }
                    print(storage?.path ?? "path")
                    promise(Result.success(storage))

                }
            }
        }
    }

    func getUrlForPath(path: String, completion: @escaping (URL?) -> Void) {
        Storage.storage().reference(withPath: path).downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else {
                completion(url)
            }
        }
    }

}

