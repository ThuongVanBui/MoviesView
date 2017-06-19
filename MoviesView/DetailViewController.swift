//
//  DetailViewController.swift
//  MoviesView
//
//  Created by Lon on 6/16/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var release_dateLabel: UILabel!
    @IBOutlet weak var votea_verageLabel: UILabel!
    
  //  @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var movies: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width,height: self.infoView.frame.origin.y + self.infoView.frame.height)
        let title = movies["title"] as! String
        let overview = movies["overview"] as! String
        let date = movies["release_date"] as! String
       // let voteaverage = movies["popularity"] as! String

        titleLabel.text = title
        overviewLabel.text = overview
        release_dateLabel.text = date
      //  votea_verageLabel.text = voteaverage
        
        
        
        titleLabel.sizeToFit()
        overviewLabel.sizeToFit()
        infoView.sizeToFit()
        scrollView.sizeToFit()
        //let baseUrl = "https://image.tmdb.org/t/p/w342"
        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
        let largeImageUrl = "https://image.tmdb.org/t/p/original"
       

        if let posterPath = movies?["poster_path"] as? String
        {
            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageUrl + posterPath )! as URL)
            let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageUrl + posterPath)! as URL)
          //  let imageUrl = NSURL(string: baseUrl + posterPath)
            //posterImageView.setImageWith(imageUrl! as URL)
            self.posterImageView.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage
                
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.posterImageView.alpha = 1.0
                }, completion: { (success) in
                    self.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) in
                        self.posterImageView.image = largeImage
                    }, failure: { (request, response, error) in
                        
                    })
                })
            }, failure: { (request, response, error) in
                
            })
        }
        
        print(movies)
        self.navigationItem.title = "Detail Movies"
        if let navigaBar = navigationController?.navigationBar{
            navigaBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)

            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 4;
            navigaBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
        // Do any additional setup after loading the view.
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
