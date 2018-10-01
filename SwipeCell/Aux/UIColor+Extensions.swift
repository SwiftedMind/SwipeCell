//
//  UIColor+Extensions.swift
//  SwipeCell
//
//  Created by Dennis Müller on 01.10.18.
//  Copyright © 2018 Dennis Müller. All rights reserved.
//

import UIKit

extension UIColor {
    var readableTextColor: UIColor {
        let luminance: Double = 1 - (0.299 * Double(rgbComponents.red) + 0.587 * Double(rgbComponents.green) + 0.114 * Double(rgbComponents.blue)) / 255.0
        
        if luminance < 0.5 {
            return UIColor(hex: 0x222222)!
        } else {
            return UIColor(hex: 0xeeeeee)!
        }
    }
}
