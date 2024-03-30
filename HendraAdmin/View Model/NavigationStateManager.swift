//
//  NavigationStateManager.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import Foundation
import Combine
import CoreData

class NavigationStateManager: ObservableObject {
    @Published var selectedUser: Users? = nil
    @Published var selectedProduct: Product? = nil
    
    @Published var searchUser: String = ""
    @Published var searchProduct: String = ""

    @Published private var searchUserPredicate: NSPredicate? = nil
    @Published private var searchProductPredicate: NSPredicate? = nil
    @Published private var userSelectedPredicate: NSPredicate? = nil
    @Published private var tokenPredicate: NSPredicate? = nil

   
    @Published var predicate: NSPredicate = .none
    @Published var predicateProduct: NSPredicate = .none
    
    @Published  var searchTokens = [ProductSearchToken]()
    @Published var suggestedTokens = ProductSearchToken.allCases


    var productObserver: ProductObserverViewModel?
    var userObserver: UserObserverViewModel?
    
    let predicateHelper = NSpredicateHelper()

    var subscriptions = Set<AnyCancellable>()
    var getUserbyMail =  PassthroughSubject<String, Never>()


    
    init() {
        $selectedUser.compactMap({$0}).sink { [unowned self]  user in
            self.userSelectedPredicate = predicateHelper.createScopePredicate(user: user)
            self.createFullPredicateForProduct()
        }.store(in: &subscriptions)
        
        $searchUser
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [unowned self] search in
                self.searchUserPredicate = predicateHelper.createSearchUserPredicate(text: search)
                self.createFullPredicateForUser()
            }.store(in: &subscriptions)
        
       
        $searchProduct
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [unowned self] search in
                self.searchProductPredicate = predicateHelper.createSearchProductPredicate(text: search)
                self.createFullPredicateForProduct()
            }.store(in: &subscriptions)
        
        $searchTokens.dropFirst().sink { [unowned self] tokens in
            if let first = tokens.first {
                self.tokenPredicate = predicateHelper.createTokenPredicates(token: first)
            } else {
                self.tokenPredicate = nil
            }
            
            self.createFullPredicateForProduct()
        }
        .store(in: &subscriptions)
        
        createUserObserverTrigger()
        createProductObserverTrigger()
        
    }
    
    func addToken(_ token: ProductSearchToken) {
        guard searchTokens.contains(where: {$0 == token}) == false else {return}
        
        if token.isStatusToken() {
            for existingToken in searchTokens {
                if existingToken.isStatusToken() {
                    guard let index = searchTokens.firstIndex(of: existingToken) else { return}
                    searchTokens.remove(at: index)
                }
            }
        }
        searchTokens.append(token)
    }
    
    func isTokenSelected(_ token: ProductSearchToken) -> Bool {
        
        searchTokens.firstIndex(of: token) != nil
    }
    
    func userChanged(to user: Users) {
        
        guard user != self.selectedUser  else {return}
        
        self.selectedUser = user
        self.selectedProduct = nil

    }
    
    func productChanged(to product: Product) {
        
        guard product != self.selectedProduct  else {return}
        
        self.selectedProduct = product
    }
    
    func addUser(name: String, country: Country, email: String, phoneNumber: String) {
        let context = PersistenceController.shared.container.viewContext
        let newUser = Users(name: name, context: context)
        newUser.country = country
        newUser.email = email
        newUser.phoneNumber = phoneNumber
        self.userChanged(to: newUser)
    }
    
    func addProduct(name: String, type: String) {
        let context = PersistenceController.shared.container.viewContext
        let newProduct = Product(name: name, context: context)
        newProduct.type = Type(rawValue: type)!
        newProduct.name = name
        newProduct.user = selectedUser
      
        self.productChanged(to: newProduct)
    }
    
    func createFullPredicateForUser() {
        var predicates = [NSPredicate]()
        
        if let searchUserPredicate  = self.searchUserPredicate {
            predicates.append(searchUserPredicate)
        }
        
        if predicates.count == 0 {
            self.predicate = NSPredicate.all
        } else if predicates.count == 1 {
            self.predicate = predicates.first ?? .none
        }
    }
    
    func createFullPredicateForProduct() {
        var predicates = [NSPredicate]()
        
        if let searchProductPredicate  = self.searchProductPredicate {
            predicates.append(searchProductPredicate)
        }
        
        if let userSelectedPredicate = self.userSelectedPredicate {
            predicates.append(userSelectedPredicate)
        }
        if let tokenPredicate = self.tokenPredicate {
            predicates.append(tokenPredicate)
        }
        
        if predicates.count == 0 {
            self.predicateProduct = NSPredicate.all
        } else if predicates.count == 1 {
            self.predicateProduct = predicates.first ?? .none
        } else {
            self.predicateProduct = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
}
