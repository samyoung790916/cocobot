//
//  UIColor.swift
//  cocobot
//
//  Created by samyoung79 on 09/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//


import UIKit

extension UIColor {
    static let bc_upper : UIColor = UIColor(hex: "#d8f900")
    static let bc_under : UIColor = UIColor(hex: "#1a1a1a")
    static var barColor : UIColor = UIColor(hex : "#ffe92d")
    static let customGray : UIColor = UIColor(hex : "#f7f7f7")
    static let customBlack : UIColor = UIColor(hex : "#323232")
    static let barMain : UIColor = UIColor(hex : "#ffffff")
    static let barMainGray : UIColor = UIColor(hex : "#474747")
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
extension UIStackView {
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}

