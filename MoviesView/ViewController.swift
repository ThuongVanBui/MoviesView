//
//  ViewController.swift
//  MoviesView
//
//  Created by Lon on 6/15/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit
import AFNetworking
import PKHUD
import Foundation
import SystemConfiguration
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var changelayout: UISegmentedControl!
    @IBOutlet var networkErrorView: UIView!
    var movies:[NSDictionary]?
    var gridMovies:[NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String = "now_playing"
    
    var searchBar = UISearchBar()
    let backgroundView = UIView()
    let smallImageUrl: String = "https://image.tmdb.org/t/p/w45"
    let largeImageUrl: String = "https://image.tmdb.org/t/p/original"
    override func viewDidLoad() {
        super.viewDidLoad()
        //createsearchBar()
        tableView.delegate = self
        tableView.dataSource = self
     
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
       
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.didRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        backgroundView.backgroundColor = UIColor.red
        
        self.view.backgroundColor = UIColor.yellow
        tableView.backgroundColor = UIColor.yellow
        
        
        
        
        
     navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)

        let titleLabel = UILabel()
       
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red.withAlphaComponent(0.5)
        shadow.shadowOffset = CGSize(width: 2, height: 2);
        shadow.shadowBlurRadius = 4;
        
        let titleText = NSAttributedString(string: "Movies", attributes: [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 28),
            NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8),
            NSShadowAttributeName : shadow
            ])
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
       
        // Do any additional setup after loading the view, typically from a nib.
        checkConnection()
    }
  
//    @IBAction func changelayout(_ sender: AnyObject) {
//        tableView.isHidden = sender.selectedSegmentIndex == 0
//        collectionView.isHidden = sender.selectedSegmentIndex == 1
//        
//        if (sender.selectedSegmentIndex == 0) {
//            tableView.insertSubview(refreshControl, at: 0)
//            tableView.reloadData()
//        }
//        if(sender.selectedSegmentIndex == 1) {
//            collectionView.insertSubview(refreshControl, at: 0)
//            collectionView.reloadData()
//        }
//
//    }
//    
    //    func createsearchBar(){
//        searchBar = UISearchBar(frame: CGRect(x: 0,y: 0,width: self.view.frame.width, height: 50))
//        searchBar.showsCancelButton = false
//    
//        searchBar.placeholder = "Enter search your here!"
//        
//        searchBar.delegate = self
//        searchBar.showsScopeBar = true
//        
//        searchBar.tintColor = UIColor.lightGray
//self.navigationItem.titleView = searchBar
//        
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == ""{
//        fetchPath()
//        }
//        else{
//            if searchBar.selectedScopeButtonIndex == 0
//            {
//                
//            }
//            else
//            {
//                
//            }
//        }
//    }
func checkConnection(){
        AFNetworkReachabilityManager.shared().startMonitoring()
         AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus?) in
            switch status!.hashValue{
            case AFNetworkReachabilityStatus.notReachable.hashValue:
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                PKHUD.sharedHUD.hide()
                print("No Internet Connection")
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                break;
            case AFNetworkReachabilityStatus.reachableViaWiFi.hashValue,AFNetworkReachabilityStatus.reachableViaWWAN.hashValue:
                self.fetchPath()
                self.refreshControl.endRefreshing()
                break;
            default:
                print("unknown")
            }
            
    }
}
    func fetchPath(_ page: Int = 1) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlAPI = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest( url:urlAPI!,cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        print("response: \(responseDictionary)")
                                        
                                        self.movies = responseDictionary["results"] as?[NSDictionary]
                                      
//                                        if ( page > 1 ) {
//                                            self.gridMovies = self.gridMovies! + self.movies!
//                                        } else {
//                                            self.gridMovies = self.movies
//                                        }
//
//                                        
//                                        if (self.changelayout.selectedSegmentIndex == 1) {
                                            self.tableView.reloadData()
//                                        } else {
//                                            self.collectionView.reloadData()
//                                        }
                                        
                                        PKHUD.sharedHUD.hide()
                                        self.refreshControl.endRefreshing()
                                    
                                }
                                 else {
                                    PKHUD.sharedHUD.hide()
//                                     print("No Internet Connection")
                                   self.refreshControl.endRefreshing()
                               }
                                    }
            })
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies
        {
            return movies.count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MovieCell
        let movie = movies?[indexPath.row]
        
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
         // let baseUrl = "https://image.tmdb.org/t/p/w342"
        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
        let largeImageUrl = "https://image.tmdb.org/t/p/original"
       if let posterPath = movie?["poster_path"] as? String
       {
        let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl + posterPath )! as URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath)! as URL)
       // let imageUrl = NSURL(string: baseUrl + posterPath)
        //cell.posterImage.setImageWith(imageUrl! as URL)
        
        cell.posterImage.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                cell.posterImage.alpha = 0.0
                cell.posterImage.image = smallImage
            
                UIView.animate(withDuration: 0.3, animations: { 
                    cell.posterImage.alpha = 1.0
                }, completion: { (success) in
                    cell.posterImage.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse,largeImage) in
                        cell.posterImage.image = largeImage
                    }, failure: { (request, response, error) in
                        
                    })
                })
        }, failure: { (request, response, error) in
    
            
        })
        
        
        }
      
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.backgroundColor = UIColor.yellow
        cell.selectedBackgroundView = backgroundView

        print("row\(indexPath.row)")
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let gridMovies = gridMovies
//        {
//           return gridMovies.count
//        }
//        else
//        {
//                return 0
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridMovieCell", for: indexPath) as! GridMovieCell
//        let movie = gridMovies?[indexPath.row]
//        
//       
//        // let baseUrl = "https://image.tmdb.org/t/p/w342"
//        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
//        let largeImageUrl = "https://image.tmdb.org/t/p/original"
//        if let posterPath = movie?["poster_path"] as? String
//        {
//            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl + posterPath )! as URL)
//            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath)! as URL)
//            // let imageUrl = NSURL(string: baseUrl + posterPath)
//            //cell.posterImage.setImageWith(imageUrl! as URL)
//            
//            cell.posterImage.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
//                cell.posterImage.alpha = 0.0
//                cell.posterImage.image = smallImage
//                
//                UIView.animate(withDuration: 0.3, animations: {
//                    cell.posterImage.alpha = 1.0
//                }, completion: { (success) in
//                    cell.posterImage.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse,largeImage) in
//                        cell.posterImage.image = largeImage
//                    }, failure: { (request, response, error) in
//                        
//                    })
//                })
//            }, failure: { (request, response, error) in
//                
//                
//            })
//            
//            
//        }
//        
//        
//       
//        cell.backgroundColor = UIColor.yellow
//        cell.selectedBackgroundView = backgroundView
//        
//        print("row\(indexPath.row)")
//        return cell
//    }

    func didRefresh() {
        checkConnection()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movies = movie
        print("prepare for segue called")
    }

}

