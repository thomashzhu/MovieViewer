//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by Thomas Zhu on 1/28/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var networkErrorMsgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var networkErrorMsgConstraint: NSLayoutConstraint!
    
    var filteredMovies: [NSDictionary]?
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieSearchBar.delegate = self
        
        networkErrorMsgView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(
                top: D.CollectionView.Cell.Spacing.top,
                left: D.CollectionView.Cell.Spacing.left,
                bottom: D.CollectionView.Cell.Spacing.bottom,
                right: D.CollectionView.Cell.Spacing.right)
            layout.itemSize = CGSize(
                width: D.Screen.width / D.CollectionView.numberOfCellPerRow - D.CollectionView.Cell.Spacing.left - D.CollectionView.Cell.Spacing.right,
                height: D.Screen.width / D.CollectionView.numberOfCellPerRow - D.CollectionView.Cell.Spacing.top - D.CollectionView.Cell.Spacing.bottom)
            return layout
        }()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        refreshControlAction(refreshControl)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            guard let movies = movies else {
                fatalError(S.ErrorMessage.resourceNotAccessible)
            }
            
            filteredMovies = movies.filter { element -> Bool in
                if let title = element[C.Movie.JSONKey.title] as? String {
                    if title.range(of: searchText, options: .caseInsensitive) != nil {
                        return true
                    }
                }
                return false
            }
        }
        collectionView.reloadData()
    }
    
    @IBAction func networkErrorMsgTapped(_ sender: Any) {
        
        self.networkErrorMsgConstraint.constant = 0
        self.networkErrorMsgView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        refreshControlAction()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.CollectionView.Cell.reuseIdentifier, for: indexPath) as? MovieCell {
            
            guard let filteredMovies = filteredMovies else {
                fatalError(S.ErrorMessage.resourceNotAccessible)
            }
            
            let filteredMovie = filteredMovies[indexPath.row]
            
            guard let posterPath = filteredMovie[C.Movie.JSONKey.posterPath] as? String else {
                fatalError(S.ErrorMessage.incorrectJSONKey)
            }
            
            
            guard let imageUrl = URL(string: C.Movie.posterBaseUrl + posterPath) else {
                fatalError(S.ErrorMessage.invalidURL)
            }
            
            cell.posterView.setImageWith(
                URLRequest(url: imageUrl),
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        cell.posterView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl? = nil) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)") else {
            fatalError(S.ErrorMessage.invalidURL)
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                do {
                    if let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                        self.networkErrorMsgConstraint.constant = 0
                        self.networkErrorMsgView.isHidden = true
                        
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.movies = dataDictionary[C.Movie.JSONKey.results] as? [NSDictionary]
                        self.filteredMovies = self.movies
                        self.collectionView.reloadData()
                        
                        // Tell the refreshControl to stop spinning
                        refreshControl?.endRefreshing()
                    }
                } catch _ {
                    fatalError(S.ErrorMessage.unrecognizedDataFormat)
                }
                
            } else {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                self.networkErrorMsgConstraint.constant = 30
                self.networkErrorMsgView.isHidden = false
                
                refreshControl?.endRefreshing()
                
            }
        }
        task.resume()
    }
}
