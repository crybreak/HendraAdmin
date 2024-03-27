//
//  DocumentPickerButton.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 17/03/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerButton: View {
    
    @ObservedObject var product: Product
    var attachment: AttahcmentUSDZ?
    let uttype: [UTType]

    @State private var presented: Bool = false

    var body: some View {
        
        Button  {
            presented.toggle()
        } label: {
            attachment == nil ?
            Label("3D", systemImage: "view.3d")
            :  Label("change photo", systemImage: "arrow.uturn.forward.circle")
        }
        .sheet(isPresented: $presented, content: {
            DocumentPicker(product: product, attachment: attachment, uttype: uttype)
        })
    }
}
