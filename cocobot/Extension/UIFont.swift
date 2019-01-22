//
//  UIFont.swift
//  cocobot
//
//  Created by samyoung79 on 10/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//


import UIKit

extension UIFont {
    
    enum FontType {
        case bold
        case regular
        case medium
        case nanumBold
        case nanumRegular
        case nanumExtraBold
        case nanumLight
    }
    
    static func font(type : FontType, size : CGFloat) -> UIFont? {
        var newSize = size
        if UIScreen.main.bounds == CGRect(origin: .zero, size: CGSize(width: 320, height: 568)) {
            newSize = size - 1
        }
        
        switch type {
        case .bold:
            return UIFont(name: "NotoSansKR-Bold", size : newSize)
        case .regular:
            return UIFont(name: "NotoSansKR-Regular", size : newSize)
        case .medium:
            return UIFont(name: "NotoSansKR-Medium", size : newSize)
        case .nanumBold:
            return UIFont(name: "NanumSquareOTFBold", size : newSize)
        case .nanumRegular:
            return UIFont(name: "NanumSquareOTFRegular", size : newSize)
        case .nanumExtraBold:
            return UIFont(name: "NanumSquareOTFExtraBold", size : newSize)
        case .nanumLight:
            return UIFont(name: "NanumSquareOTFLight", size : newSize)
        }
    }
    
}
