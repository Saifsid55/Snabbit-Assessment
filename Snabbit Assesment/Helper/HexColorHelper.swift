//
//  HexColorHelper.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit
 
extension UIColor {
 
    convenience init(hex: String, alpha: CGFloat = 1.0) {
 
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitized = sanitized.hasPrefix("#") ? String(sanitized.dropFirst()) : sanitized
 
        var rgb: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgb)
 
        let r, g, b, a: CGFloat
 
        switch sanitized.count {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >>  8) / 255
            b = CGFloat( rgb & 0x0000FF       ) / 255
            a = alpha
        case 8:
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgb & 0x0000FF00) >>  8) / 255
            a = CGFloat( rgb & 0x000000FF       ) / 255
        default:
            r = 1; g = 1; b = 1; a = alpha
        }
 
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
