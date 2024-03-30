//
//  productSearchToken.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 29/03/2024.
//

import Foundation

enum ProductSearchToken: String, Hashable, CaseIterable, Identifiable {
    case draftStatus
    case uploaddStatus
    case usdz
    case photos
    case last7Days
    
    var id: Self{self}
    
    var name: String {
        
        switch self {
        case .draftStatus:
            return "Draft"
        case .uploaddStatus:
            return "Upload"
        case .last7Days:
            return "7 Days"
        case .usdz:
            return "USDZ"
        case .photos:
            return "Photos"
        }
    }
    
    var fullName: String {
        
        switch self {
        case .draftStatus:
            return "Draft Status"
        case .uploaddStatus:
            return "Upload Status"
        case .last7Days:
            return "Last 7 Days"
        case .usdz:
            return "USDZ"
        case .photos:
            return "Photos"
        }
    }
    
    func icon() -> String {
        
        switch self {
        case .draftStatus:
            return "square.and.pencil"
        case .uploaddStatus:
            return "paperplane"
        case .last7Days:
            return "calendar.day.timeline.right"
        case .usdz:
            return "move.3d"
        case .photos:
            return "camera"
        }
    }
    
    func isStatusToken() -> Bool {
        switch self {
        case .uploaddStatus, .draftStatus: return true
        case .photos, .last7Days, .usdz: return false
        }
    }
    
}
