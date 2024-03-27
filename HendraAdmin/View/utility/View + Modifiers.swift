//
//  View + Modifiers.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI

extension View {
    func fieldSelectedUserInformation(index: Int, activeField: Field?) -> some View  {
     self
        .padding(13)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(activeField == activeStateForIndex(index: index) ? .blue :
                            Color.gray.opacity(0.8)   ,  lineWidth:  1)
        }
    }
}
    
