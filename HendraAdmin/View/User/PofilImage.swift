//
//  UserImage.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI
import UIKit


struct ProfilImage {
    
    var name: String
    
    init( name: String) {
        self.name = name
    }
    
    func generateProfileImage() -> UIImage? {
        if name.count > 0 {
            let imageSize = CGSize(width: 70, height: 70)
            let renderer = UIGraphicsImageRenderer(size: imageSize)
            
            let image = renderer.image { context in
                let labelSize = CGSize(width: imageSize.width * 0.8, height: imageSize.height * 0.8)
                let labelOrigin = CGPoint(x: (imageSize.width - labelSize.width) / 2, y: (imageSize.height - labelSize.height) / 2)
                
                let uiLabel = UILabel(frame: CGRect(origin: labelOrigin, size: labelSize))
                let firstCharacter = name.split(separator: " ").map { $0.first ?? Character("") }.reduce("") { $0 + String($1) }
                uiLabel.text = firstCharacter
                
                uiLabel.backgroundColor = pickColor(alphabet: name[name.startIndex])
                uiLabel.isEnabled = true
                uiLabel.textAlignment = .center
                uiLabel.font = UIFont.boldSystemFont(ofSize: 20)
                uiLabel.textColor = UIColor.white
                uiLabel.layer.cornerRadius = labelSize.width / 2
                uiLabel.layer.masksToBounds = true
                
                uiLabel.layer.borderWidth = 2
                uiLabel.layer.borderColor = UIColor.white.cgColor
                
                uiLabel.layer.render(in: context.cgContext)
            }
            
            return image
        }
        return nil
    }
       
       func pickColor(alphabet: Character) -> UIColor {
           let alphabetColors = [0x5A8770, 0xB2B7BB, 0x6FA9AB, 0xF5AF29, 0x0088B9, 0xF18636, 0xD93A37, 0xA6B12E, 0x5C9BBC, 0xF5888D, 0x9A89B5, 0x407887, 0x9A89B5, 0x5A8770, 0xD33F33, 0xA2B01F, 0xF0B126, 0x0087BF, 0xF18636, 0x0087BF, 0xB2B7BB, 0x72ACAE, 0x9C8AB4, 0x5A8770, 0xEEB424, 0x407887]
           let str = String(alphabet).unicodeScalars
           let unicode = Int(str[str.startIndex].value)
           if 65...90 ~= unicode {
               let hex = alphabetColors[unicode - 65]
               return UIColor(red: CGFloat(Double((hex >> 16) & 0xFF)) / 255.0, green: CGFloat(Double((hex >> 8) & 0xFF)) / 255.0, blue: CGFloat(Double((hex >> 0) & 0xFF)) / 255.0, alpha: 1.0)
           }
           return UIColor.black
       }
}
