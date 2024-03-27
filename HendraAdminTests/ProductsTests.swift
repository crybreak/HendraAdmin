//
//  UserTests.swift
//  HendraAdminTests
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import XCTest
import CoreData
@testable import HendraAdmin

final class UserTests: XCTestCase {

    var controller: PersistenceController!
    
    var context: NSManagedObjectContext {
        controller.container.viewContext
    }
    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
    }

    override func tearDownWithError() throws {
        self.controller = nil
    }

    func test_Products_Convenience_init() {
        let name = "Hendra"
        let user = User(name: name, context: context)
        
        XCTAssertTrue(user.name == name , "Note should have the title given in the convenience initializer")
    }
    
    
    func test_Products_CreationDate() {
        let product = Product(context: context)
        let productConvenient = Product(name: "Hendra", context: context)
        
        XCTAssertNotNil(product.creationDate, "note should have creationDate property" )
        XCTAssertTrue(product.creationDate_ != nil)
        XCTAssertFalse(product.creationDate_ == nil)
    }
    
    
    func test_Products_Updating_name() {
        let product = Product(name: "old", context: context)
        product.name = "new"
        
        XCTAssertTrue(product.name == "new")
    }
  
    func test_Fetch_All_Product() {
        _ = Product(name: "Hendra", context: context)
        let fetch = Product.fetch(.all)
        let fetchedProduct = try? context.fetch(fetch)
        
        XCTAssertNotNil(fetchedProduct)
        XCTAssertTrue(fetchedProduct!.count > 0, "Predicate of none should not fetch at least one objects")
    }
    
    func test_Fetch_None_Products () {
        _ = Product(name: "default note", context: context);
        let fetch = Product.fetch(.none)
        let fetchedProducts = try? context.fetch(fetch)
        
        XCTAssertNotNil(fetchedProducts)
        XCTAssertTrue(fetchedProducts!.count == 0, "Predicate of none should not fetch any objects")
    }


}
