//
//  UIColorExtension.swift
//  Tracker
//
//  Created by Almira Khafizova on 27.10.23.
//

import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypLightGray: UIColor { UIColor(named: "YP Light Gray") ?? UIColor.lightGray }
    static var ypBackgroundDark: UIColor { UIColor(named: "YP Background (Alpha 85)") ?? UIColor.darkGray }
    static var ypBackgroundDay: UIColor { UIColor(named: "YP Background (Alpha 30)") ?? UIColor.lightGray }
    
    static var ypBackground: UIColor { UIColor(named: "YP Background (Alpha 12)") ?? UIColor.lightGray }
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
}

extension UIColor {
    
    public convenience init(rgb color: Int) {
        self.init(
            red: CGFloat((color & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((color & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(color & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public convenience init(rgba color: Int) {
        self.init(
            red: CGFloat((color & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((color & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((color & 0x0000FF00) >> 8) / 255.0,
            alpha: CGFloat(color & 0x000000FF) / 255.0
        )
    }
    
    func convertToRgba() -> Int? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if (getRed(&red, green: &green, blue: &blue, alpha: &alpha)) {
            return (Int(red * 255.0) << 24) +
                (Int(green * 255.0) << 16) +
                (Int(blue * 255.0) << 8) +
                Int(alpha * 255.0)
        } else {
            return nil
        }
    }
}
