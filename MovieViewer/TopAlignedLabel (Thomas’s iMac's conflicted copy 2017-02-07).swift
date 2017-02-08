//
//  TopAlignedLabel.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/7/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

@IBDesignable
class TopAlignedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        if let text = text {
            let labelStringSize = (text as NSString).boundingRect(with: CGSize(width: frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0, y: 0, width: frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
}
