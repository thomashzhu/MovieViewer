//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 1/28/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.autoresizingMask.insert(.flexibleHeight)
//        self.contentView.autoresizingMask.insert(.flexibleWidth)
//        self.contentView.translatesAutoresizingMaskIntoConstraints = true
    }
}
