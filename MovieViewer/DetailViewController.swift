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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let title = movie[C.Movie.JSONKey.title] as? String {
            titleLabel.text = title
        }
        
        if let overview = movie[C.Movie.JSONKey.overview] as? String {
            overviewLabel.text = overview
        }
        
        guard let posterPath = movie[C.Movie.JSONKey.posterPath] as? String else {
            fatalError(S.ErrorMessage.incorrectJSONKey)
        }
        guard let imageUrl = URL(string: C.Movie.posterBaseUrl + posterPath) else {
            fatalError(S.ErrorMessage.invalidURL)
        }
        posterImageView.setImageWith(imageUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
