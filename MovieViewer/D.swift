//
//  D.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 1/31/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

struct D {
    
    private static let bounds = UIScreen.main.bounds
    
    static let horizontalMargin: CGFloat = 8
    static let verticalMargin: CGFloat = 8
    
    struct Screen {
        static let height = bounds.height
        static let width = bounds.width
    }
    
    struct CollectionView {
        
        static let numberOfCellPerRow: CGFloat = 2.0
        
        struct Cell {
            struct Spacing {
                static let top: CGFloat = 5.0
                static let bottom: CGFloat = 5.0
                static let left: CGFloat = 5.0
                static let right: CGFloat = 5.0
            }
        }
    }
    
    struct DetailViewController {
        
        static let topOffset: CGFloat = 100
    }
}
