//
//  Colors.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 26.05.2023.
//

import UIKit

enum Colors {
    
    static let groupOne = UIColor(hex: "#373f32")
    static let groupTwo = UIColor(hex: "#aa7a54")
    static let groupThree = UIColor(hex: "#635344")
    
    static let mainBackgound = UIColor(hex: "#eae2d8")
}

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000FF) / 255
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

