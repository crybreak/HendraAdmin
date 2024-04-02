//
//  UserManager.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 22/03/2024.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class UserManager: ObservableObject {
    
    @Published var users: [SUser] = []
    @Published var product: Product? = nil
    @Published var message: String? = nil
    @Published var isLoding: Bool = false
    @Published var imgLoading: Bool = false
    @Published var usdzLoading: Bool = false


    var sendProduct =  PassthroughSubject<Product, Never>()
    var createProduct = PassthroughSubject<SUser, Never>()
    var uploadProduct = PassthroughSubject<SUser, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    
    let opQueue = OperationQueue()
    
   

    let db = Firestore.firestore()
    let path = "users"

    init() {
        self.opQueue.maxConcurrentOperationCount = 3
       
        sendProduct
            .map({ [unowned self] product in
                return self.db.collection(self.path)
                    .whereField(SUser.CodingKeys.email.rawValue,
                                isEqualTo: product.user!.email)
            })
            .map { query -> AnyPublisher<[SUser], Never> in
                FirestoreUserAPI.getDocs(ref: query)
                    .handleEvents(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("❇️ User has taken successfully")
                        case .failure( _ ):
                            print("user raise error")
                            break
                        }
                    })
                    .tryMap({ snap in
                        try snap.documents.compactMap({ try $0.data(as: SUser.self) })
                    })
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [unowned self ] users in
                self.users = users
                print(self.users)
                if users.isEmpty {
                    message = "Aucun compte avec à cet email."
                } else {
                    createProduct.send(users.first!)
                    uploadProduct.send(users.first!)
                }
            }
            .store(in: &subscriptions)
        
        
        createProduct
            .filter({[unowned self] _ in !self.product!.send})
            .tryMap {[unowned self] user in
                try DBProductManager.shared.createNewProduct(userId: user.userId,  product: DBProduct(product: self.product!, userId: user.userId))
            }
            .replaceError(with: ())
            .sink {[unowned self] _ in
                self.product!.send = true
            }
            .store(in: &subscriptions)

        uploadTumbnailImage()
        uploadFullImage()
        uploadUsdzThumbnailImage()
        uploadUsdzData()
        
       
    }
    
}
