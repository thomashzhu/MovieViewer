//
//  UIColorExtension.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/7/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redHex: CGFloat, greenHex: CGFloat, blueHex: CGFloat, alpha: CGFloat) {
        self.init(red: redHex / 255, green: greenHex / 255, blue: blueHex / 255, alpha: alpha)
    }
}
