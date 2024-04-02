//
//  UserManager + UploadProduct.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 01/04/2024.
//

import Combine
import Foundation

extension UserManager {
    func uploadTumbnailImage () {
        uploadProduct
            .filter{[unowned self] _ in
                if product!.images.isEmpty {
                    return false
                }
                return true
            }
            .map({ [unowned self] SUser   in
                product?.images.publisher
                    .filter({!$0.send})
                    .map { image -> AnyPublisher<String?, Never> in
                        StorageManager.shared.saveImage(image: image , userId: SUser.userId , type: "ThumbnaiData", product: self.product!)
                            .compactMap { storage in
                                storage?.path
                            }
                            .replaceError(with: nil)
                            .subscribe(on: self.opQueue)
                            .eraseToAnyPublisher()
                    }
            })
            .receive(on: DispatchQueue.main)
            .sink { _ in}
            .store(in: &subscriptions)
    }
    
    func uploadFullImage() {
        uploadProduct
            .filter{[unowned self] _ in
                if product!.images.isEmpty {
                    self.isLoding = imgLoading && false

                    return false
                }
                self.isLoding = true
                self.imgLoading = true

                return true
            }
            .map({ [unowned self] SUser in
                
                return product?.images.publisher
                    .filter({!$0.send})
                    .flatMap { image -> AnyPublisher<String?, Never>  in
                        StorageManager.shared.saveImage(image: image , userId: SUser.userId , type: "FullImageData", product: self.product!)
                            .compactMap {storage in
                                storage?.path
                            }
                            .replaceError(with: nil)
                            .subscribe(on: self.opQueue)
                            .eraseToAnyPublisher()
                    }.receive(on: DispatchQueue.main)
                
                    .sink(receiveCompletion: { completion in
                        self.imgLoading = false
                        if !self.imgLoading && !self.usdzLoading {
                            self.isLoding = false
                        }
                        switch completion {
                        case .finished:
                            print("Finished")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }, receiveValue: {
                        print("Received \(String(describing: $0)) images on mainthread \(Thread.current.isMainThread) \n")
                    })
                     .store(in: &subscriptions)
                    
                
            })
            .sink { _ in}
            .store(in: &subscriptions)
    }
    
    func uploadUsdzData() {
        uploadProduct
            .filter{[unowned self] _ in
                if product!.usdz.isEmpty {
                    return false
                }
                self.isLoding = true
                self.usdzLoading = true
                return true
            }
            .map({ [unowned self] SUser in
                return product?.usdz.publisher
                    .filter({!$0.send})
                    .flatMap { usdz -> AnyPublisher<String?, Never>  in
                        StorageManager.shared.saveUsdz(usdz: usdz, userId: SUser.userId, product: self.product!)
                            .compactMap {storage in
                                storage?.path
                            }
                            .replaceError(with: nil)
                            .subscribe(on: self.opQueue)
                            .eraseToAnyPublisher()
                    }.receive(on: DispatchQueue.main)
                
                    .sink(receiveCompletion: { completion in
                        self.usdzLoading = false
                        if !self.imgLoading && !self.usdzLoading {
                            self.isLoding = false
                        }

                        switch completion {
                        case .finished:
                            print("Finished")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }, receiveValue: {
                        print("Received \(String(describing: $0)) udsz on mainthread \(Thread.current.isMainThread) \n")
                    })
                     .store(in: &subscriptions)

            })
            .sink { _ in}
            .store(in: &subscriptions)
    }
    
    func  uploadUsdzThumbnailImage() {
        uploadProduct
            .filter{[unowned self] _ in
                if product!.usdz.isEmpty {
                    return false
                }
                return true
            }
            .map({ [unowned self] SUser   in
                product?.usdz.publisher
                    .filter({!$0.send})
                    .map { usdz -> AnyPublisher<String?, Never> in
                        StorageManager.shared.saveUsdzImage(usdz: usdz, userId: SUser.userId, product: self.product!)
                            .compactMap {storage in
                                storage?.path
                            }
                            .replaceError(with: nil)
                            .subscribe(on: self.opQueue)
                            .eraseToAnyPublisher()
                    }
            })
            .receive(on: DispatchQueue.main)
            .sink { _ in}
            .store(in: &subscriptions)
    }
}
