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
    
    var endpoint: Endpoint?
    
    var filteredMovies: [NSDictionary]?
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = F.Theme.Color.red
        
        navigationItem.titleView = {
            
            let titleLabel = UILabel();
            
            let shadow: NSShadow = {
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.white.withAlphaComponent(0.2)
                shadow.shadowOffset = CGSize(width: 2, height: 2)
                shadow.shadowBlurRadius = 4
                return shadow
            }()
            
            let titleText = NSAttributedString(
                string: (tabBarController?.selectedViewController?.tabBarItem.title ?? "Movies"),
                attributes: [
                    NSFontAttributeName: UIFont(name: F.Theme.Font.avenirBook, size: 24) ?? UIFont.boldSystemFont(ofSize: 24),
                    NSForegroundColorAttributeName: UIColor.white,
                    NSShadowAttributeName: shadow
            ])
            
            titleLabel.attributedText = titleText
            titleLabel.sizeToFit()
            
            return titleLabel
        }()
        
        movieSearchBar.delegate = self
        
        let movieSearchBarTextField = movieSearchBar.value(forKey: "searchField") as? UITextField
        movieSearchBarTextField?.layer.borderColor = F.Theme.Color.red.withAlphaComponent(0.75).cgColor
        movieSearchBarTextField?.layer.borderWidth = 1.5
        movieSearchBarTextField?.layer.cornerRadius = 8.0
        movieSearchBarTextField?.clipsToBounds = true
        movieSearchBarTextField?.textColor = F.Theme.Color.red
        
        movieSearchBar.barTintColor = UIColor.white
        movieSearchBar.backgroundImage = UIImage()
        
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
                if let title = element[N.TMDB.Movie.JSONKey.title] as? String {
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
            
            guard let posterPath = filteredMovie[N.TMDB.Movie.JSONKey.posterPath] as? String else {
                fatalError(S.ErrorMessage.incorrectJSONKey)
            }
            
            guard
                let lowResolutionImageUrl = URL(string: N.TMDB.Movie.ImageURL.lowResolution + posterPath),
                let highResolutionImageUrl = URL(string: N.TMDB.Movie.ImageURL.highResolution + posterPath)
            else {
                fatalError(S.ErrorMessage.invalidURL)
            }
            
            cell.posterView.setImageWith(
                URLRequest(url: lowResolutionImageUrl),
                placeholderImage: nil,
                success: { (request, response, lowResImg) in
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = lowResImg;
                    
                    UIView.animate(
                        withDuration: 0.3,
                        animations: { cell.posterView.alpha = 1.0 },
                        completion: { _ in
                            cell.posterView.setImageWith(
                                URLRequest(url: highResolutionImageUrl),
                                placeholderImage: lowResImg,
                                success: { (largeImageRequest, largeImageResponse, highResImg) -> Void in
                                    cell.posterView.image = highResImg;
                            })
                    })
                }
            )
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl? = nil) {
        
        guard let endpoint = endpoint, let url = URL(string: N.TMDB.URL(endPoint: endpoint)) else {
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
                        
                        self.movies = dataDictionary[N.TMDB.Movie.JSONKey.results] as? [NSDictionary]
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
                
                self.networkErrorMsgConstraint.constant = self.movieSearchBar.frame.size.height
                self.networkErrorMsgView.isHidden = false
                
                refreshControl?.endRefreshing()
                
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailViewController = segue.destination as? DetailViewController {
            
            guard let movies = filteredMovies,
                let cell = sender as? MovieCell,
                let indexPath = collectionView.indexPath(for: cell) else {
                fatalError(S.ErrorMessage.movieNotLoaded)
            }
            
            let movie = movies[indexPath.row]
            detailViewController.movie = movie
            
            let backButtonText = (tabBarController?.selectedViewController?.tabBarItem.title ?? "Back")
            navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonText, style: .plain, target: nil, action: nil)
        }
    }
}
