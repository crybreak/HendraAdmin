//
//  Type.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import Foundation


enum Type: String, Identifiable, CaseIterable{
    
    case meuble = "Meuble"
    case decoration = "Décoration"
    case mode = "Mode"

    
    
    var id: String {
        return self.rawValue
    }
}
