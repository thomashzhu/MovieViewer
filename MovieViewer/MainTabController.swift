//
//  MainTabController.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/6/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: C.Storyboard.Name.main, bundle: nil)
        
        guard
            let nowPlayingNavigationVC = storyboard.instantiateViewController(withIdentifier: C.Storyboard.VC.Identifier.movieVC) as? UINavigationController,
            let topRatedNavigationVC = storyboard.instantiateViewController(withIdentifier: C.Storyboard.VC.Identifier.movieVC) as? UINavigationController
        else {
            fatalError(S.ErrorMessage.uiLoadingError)
        }
        
        nowPlayingNavigationVC.tabBarItem = UITabBarItem(title: S.UI.TabName.nowPlaying, image: UIImage(named: C.Resource.Image.nowPlaying), tag: C.TabIndex.NowPlaying)
        if let nowPlayingVC = nowPlayingNavigationVC.topViewController as? MovieViewController {
            nowPlayingVC.endpoint = Endpoint.NowPlaying
        }
        
        topRatedNavigationVC.tabBarItem = UITabBarItem(title: S.UI.TabName.topRated, image: UIImage(named: C.Resource.Image.topRated), tag: C.TabIndex.NowPlaying)
        if let topRatedVC = topRatedNavigationVC.topViewController as? MovieViewController {
            topRatedVC.endpoint = Endpoint.TopRated
        }
        
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        tabBar.barTintColor = F.Theme.Color.red
        
        viewControllers = [nowPlayingNavigationVC, topRatedNavigationVC]
    }
}
