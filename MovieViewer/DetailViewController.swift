//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 2/3/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var overviewTextView: TopAlignedLabel!
    
    @IBOutlet weak var infoViewOffsetConstraint: NSLayoutConstraint!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        
        scrollView.contentSize = CGSize(width: posterImageView.bounds.size.width * 0.9,
                                        height: posterImageView.bounds.size.height * 0.5)
        
        infoView.layoutMargins = UIEdgeInsets(top: D.horizontalMargin, left: D.verticalMargin, bottom: D.horizontalMargin, right: D.verticalMargin)
        infoView.isLayoutMarginsRelativeArrangement = true
        infoViewOffsetConstraint.constant = D.DetailViewController.topOffset
        
        titleLabel.text = (movie[N.TMDB.Movie.JSONKey.title] as? String) ?? ""
        dateLabel.text = (movie[N.TMDB.Movie.JSONKey.releaseDate] as? String) ?? ""
        if let rating = movie[N.TMDB.Movie.JSONKey.rating] as? Double {
            ratingLabel.text = "\(rating)"
        } else {
            ratingLabel.text = ""
        }
        overviewTextView.text = (movie[N.TMDB.Movie.JSONKey.overview] as? String) ?? ""
        
        if let posterPath = movie[N.TMDB.Movie.JSONKey.posterPath] as? String,
           let imageUrl = URL(string: N.TMDB.Movie.ImageURL.highResolution + posterPath) {
            posterImageView.setImageWith(imageUrl)
        }
        
        runtimeLabel.text = N.loadingText
        loadMovieRunTime()
    }
    
    private func loadMovieRunTime() {
        
        if let id = movie[N.TMDB.Movie.JSONKey.id] as? Int, let url = URL(string: N.TMDB.URL(id: id)) {
            
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        if let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                            if let runtime = dataDictionary[N.TMDB.Movie.JSONKey.runtime] as? Int {
                                self.runtimeLabel.text = "\(runtime) minutes"
                            } else {
                                self.runtimeLabel.text = ""
                            }
                        }
                    } catch _ {
                        fatalError(S.ErrorMessage.unrecognizedDataFormat)
                    }
                }
            }
            task.resume()
        }
    }
}
