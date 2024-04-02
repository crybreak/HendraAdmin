//
//  Genre mODE.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 14/03/2024.
//

import Foundation

enum GenreMode: String, Identifiable, CaseIterable{

    case vetements = "Vêtements"
    case chaussures = "Chaussures"
    case accessoire = "Accessoires"
    
    
    var id: String {
        return self.rawValue
    }
}
