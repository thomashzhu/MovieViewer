//
//  S.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 1/31/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

struct S {
    
    struct ErrorMessage {
        static let incorrectJSONKey = "Unknown data structure"
        static let invalidURL = "Invalid destination URL"
        static let movieNotLoaded = "Movie cannot be loaded"
        static let resourceNotAccessible = "Resource not accessible"
        static let uiLoadingError = "UI loading error"
        static let unrecognizedDataFormat = "Incoming data error"
    }
    
    struct UI {
        
        struct TabName {
            static let nowPlaying = "Now Playing"
            static let topRated = "Top Rated"
        }
        
        static func getNavigationTitle(endpoint: Endpoint) -> String {
            switch endpoint {
            case .NowPlaying:
                return TabName.nowPlaying
            case .TopRated:
                return TabName.topRated
            }
        }
    }
}
