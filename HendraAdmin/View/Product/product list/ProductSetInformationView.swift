//
//  ProductSetInformationView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import SwiftUI

struct ProductSetInformationView: View {
    @ObservedObject var product: Product

    @FocusState var activeField: Field?
    @State private var color =  Color.gray.opacity(0.8)

    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (alignment: .leading, spacing: 20) {
                Spacer()
                
                Text(product.name)
                    .font(.system(size: 30))
                    .bold()
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Name")
                        
                        TextField("CHAIR", text: $product.name )
                            .focused($activeField, equals: activeStateForIndex(index: 0))
                            .fieldSelectedUserInformation(index: 0, activeField: activeField)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Type")
                        Picker(selection: $product.type) {
                            ForEach(Type.allCases) {type in
                                Text(type.rawValue)
                                    .font(.system(size: 10))
                                    .tag(type)
                            }
                        } label: {
                            Text("")
                        }
                        .font(.system(size: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.8)   ,  lineWidth:  1)
                        }
                    }
                }
                
                if product.type == .meuble {
                    GenreMeublePicker()
                }
                
                if product.type == .mode {
                    GenreModePicker()
                }
                
            }
            .padding()
        }
        .font(Font.custom("Nunito Sans", size: 14))
        .onChange(of: product.type) {  type in
            if type == .decoration {
                product.genre = ""
            }
        }
    }
    
    
    func GenreMeublePicker() -> some View {
        VStack(alignment: .leading) {
            Text("Select your ")
                .bold()
            FlowLayout(alignment: .leading, spacing: 10) {
                ForEach(GenreMeuble.allCases, id: \.self) { genre in
                    Text(genre.rawValue)
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous).fill(color(for: genre)))
                        .padding(5)
                        .cornerRadius(3.0)
                        .onTapGesture {
                            product.genre = genre.rawValue
                        }
                }
            }
        }
    }
    
    func GenreModePicker() -> some View {
        VStack(alignment: .leading) {
            Text("Select Genre")
                .bold()
            FlowLayout(alignment: .leading, spacing: 10) {
                ForEach(GenreMode.allCases, id: \.self) { genre in
                    Text(genre.rawValue)
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(RoundedRectangle(cornerRadius: 5,
                                                     style: .continuous).fill(color(for: genre)))
                        .padding(5)
                        .cornerRadius(3.0)
                        .onTapGesture {
                            product.genre = genre.rawValue
                        }
                }
            }
        }
    }
    
    func color(for genre: GenreMeuble) -> Color {
        product.genre == genre.rawValue ? Color.indigo : Color.gray
    }
    func color(for genre: GenreMode) -> Color {
        product.genre == genre.rawValue ? Color.indigo : Color.gray
    }
}

#Preview {
    ProductSetInformationView(product: Product.example())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
