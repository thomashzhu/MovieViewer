//
//  N.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/7/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

typealias Endpoint = N.TMDB.Endpoint

struct N {
    
    static let loadingText = "..."
    
    struct TMDB {
        
        enum Endpoint: String {
            case NowPlaying = "now_playing"
            case TopRated = "top_rated"
        }
        
        struct Movie {
            
            static let JSONKey = (
                id: "id",
                overview: "overview",
                posterPath: "poster_path",
                rating: "vote_average",
                releaseDate: "release_date",
                results: "results",
                runtime: "runtime",
                title: "title"
            )
            
            static let ImageURL = (
                lowResolution: "https://image.tmdb.org/t/p/w45",
                highResolution: "https://image.tmdb.org/t/p/original"
            )
        }
        
        private static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        static func URL(endPoint: Endpoint) -> String {
            return "https://api.themoviedb.org/3/movie/\(endPoint.rawValue)?api_key=\(apiKey)"
        }
        
        static func URL(id: Int) -> String {
            return "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)"
        }
    }
}
