//
//  Genre mODE.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 14/03/2024.
//

import Foundation

enum GenreMode: String, Identifiable, CaseIterable{

    case vetements = "Vetements"
    case chaussures = "Chaussures"
    
    
    var id: String {
        return self.rawValue
    }
}
