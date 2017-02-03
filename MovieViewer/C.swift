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
    
    struct Movie {
        
        static let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
        
        static let JSONKey = (
            overview: "overview",
            posterPath: "poster_path",
            results: "results",
            title: "title"
        )
    }
}
