//
//  ProductSortedView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import SwiftUI

struct ProductSortedView: View {
    init(predicate: NSPredicate) {
        self._products = FetchRequest(fetchRequest: Product.fetch(predicate))
    }
    
    @FetchRequest(fetchRequest: Product.fetch(.none))
    private var products: FetchedResults<Product>
    
    var body: some View {
        ForEach(products) {product in
            ProductRow(product: product)
                .tag(product)
        } .onDelete(perform: deleteProduct(offsets:))
    }
    
    
    private func deleteProduct(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(Product.delete(_:))

        }
    }
}
