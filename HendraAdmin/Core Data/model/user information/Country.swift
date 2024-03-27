//
//  Country.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import Foundation

enum Country: String, Identifiable, CaseIterable{
   
 
    case RDC = "RDC"
    case CI = "Côte d'Ivoire"
    case BN = "Bénin"
    case CN = "Congo"
    case TG = "Togo"

    
    var id: String {
        return self.rawValue
    }
    
    var code: String {
        switch self {
        case .RDC:
            return "+243"
        case .CI:
            return "+225"
        case .BN:
            return "+229"
        case .CN:
            return "+242"
        case .TG:
            return "+248"
        }
    }
}
