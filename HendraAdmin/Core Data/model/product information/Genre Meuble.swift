//
//  Genre.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import Foundation

enum GenreMeuble: String, Identifiable, CaseIterable{
    
    
    case salon = "Salon"
    case salle = "Salle à manger"
    case bureau = "Bureau"
    case chambre = "Chambre"
    case jardin = "Jardin"
    
    
    var id: String {
        return self.rawValue
    }
}
