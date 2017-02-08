//
//  C.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 1/31/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

struct C {
    
    struct CollectionView {
        struct Cell {
            static let reuseIdentifier = "MovieCell"
        }
    }
    
    struct Resource {
        struct Image {
            static let nowPlaying = "now_playing"
            static let topRated = "top_rated"
        }
    }
    
    struct Storyboard {
        
        struct Name {
            static let main = "Main"
        }
        
        struct VC {
            struct Identifier {
                static let movieVC = "MovieViewController"
            }
        }
    }
    
    struct TabIndex {
        static let NowPlaying = 0
        static let TopRated = 1
    }
}
