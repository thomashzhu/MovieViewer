//
//  UIViewControllerExtension.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/7/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var navigationBarHeight: CGFloat {
        return (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    var tabBarHeight: CGFloat {
        return (tabBarController?.tabBar.frame.height ?? 0)
    }
}   
