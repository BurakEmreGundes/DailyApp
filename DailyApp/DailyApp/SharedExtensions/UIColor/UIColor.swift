//
//  UIColor.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 14.12.2022.
//

import UIKit

extension UIColor {
   
    static let baseGreen = UIColor(red: 56.0 / 255.0, green: 229.0 / 255.0, blue: 77.0 / 255.0, alpha: 1)
    static let baseYellow = UIColor(red: 250 / 255.0, green: 223 / 255.0, blue: 112 / 255.0, alpha: 1)
    static let baseGreenLight = UIColor(red: 56.0 / 255.0, green: 229.0 / 255.0, blue: 77.0 / 255.0, alpha: 0.8)

    
    
    
    static func from(hex: Int) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat((hex & 0x0000FF) >> 0)
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
        
    struct Shadow {
        static let kolodaCard = UIColor(red: 175 / 255.0, green: 166 / 255.0, blue: 159 / 255.0, alpha: 0.2)
        static let ND_kolodaCard = UIColor(red: 125 / 255.0, green: 126 / 255.0, blue: 130 / 255.0, alpha: 0.5)
    }
    
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    static func getGradientColor(from startColor: UIColor, to endColor: UIColor, with percentage: CGFloat) -> UIColor {
        let correctedPercentage = UIColor.correct(percentage)
        let newRedValue = startColor.rgba.red + (endColor.rgba.red - startColor.rgba.red) * correctedPercentage
        let newGreenValue = startColor.rgba.green + (endColor.rgba.green - startColor.rgba.green) * correctedPercentage
        let newBlueValue = startColor.rgba.blue + (endColor.rgba.blue - startColor.rgba.blue) * correctedPercentage
        let newAlphaValue = startColor.rgba.alpha + (endColor.rgba.alpha - startColor.rgba.alpha) * correctedPercentage
        return UIColor(red: newRedValue, green: newGreenValue, blue: newBlueValue, alpha: newAlphaValue)
    }
    
    private static func correct(_ percentage: CGFloat) -> CGFloat {
        var correctedPercentage = percentage
        if percentage > 1 {
            correctedPercentage = 1
        } else if percentage < 0 {
            correctedPercentage = 0
        }
        return correctedPercentage
    }
    
    static func convertHex(hex: String) -> UIColor? {
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
                                b = CGFloat((hexNumber & 0x0000FF) >> 0) / 255

                                return UIColor(red: r, green: g, blue: b, alpha: 1)
                            
                            }
                }
        }
        return nil
    }
    
}

