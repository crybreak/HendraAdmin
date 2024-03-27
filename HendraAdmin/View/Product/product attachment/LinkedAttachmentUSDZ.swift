//
//  LinkedAttachmentUSDZ.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 18/03/2024.
//

import SwiftUI
import UniformTypeIdentifiers


struct LinkedAttachmentUSDZ: View {
    @ObservedObject var product: Product
    @Environment(\.managedObjectContext) var viewContext
   
    @Binding var selected3D: AttahcmentUSDZ?
    
    
    @State private var selected3dImage: Date =  Date() + TimeInterval()
    
    @Namespace var animation
    

    var body: some View {
        VStack (alignment: .leading, content: {
            if !product.usdz.isEmpty {
                Text("Select your Model")
                    .font(.title3)
                    .fontWeight(.heavy)
            }
            ScrollView(.horizontal, showsIndicators: false)  {
                HStack {
                    ForEach(product.usdz.sorted()) { attachment in
                        HStack {
                            ProductAttachmentUSDZView(product: product, attachment: attachment)
                        }
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.gray.opacity(0.1))
                                
                                if selected3dImage == attachment.creationDate {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(hex: "093855")!.opacity(0.4))
                                        .matchedGeometryEffect(id:"ID", in: animation)
                                }
                            }
                        }
                        .onTapGesture {
                            selected3D = attachment
                            withAnimation (.easeInOut) {
                                selected3dImage = attachment.creationDate
                            }
                        }
                    }
                }
            }
        })
    }
}
