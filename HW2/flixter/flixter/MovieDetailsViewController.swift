//
//  MovieDetailsViewController.swift
//  flixter
//
//  Created by Ali Malik on 2/27/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    var movie: [String:Any]!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var synopLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(movie["title"])
        // Do any additional setup after loading the view.
        
        titleLbl.text = movie["title"] as? String
        titleLbl.sizeToFit()
        synopLbl.text = movie["overview"] as? String
        synopLbl.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        //URL() Validates URL
        let posterURL = URL(string: baseURL + posterPath)
        
        //takes care of downloading and setting image
        posterView.af_setImage(withURL: posterURL!)
        
        let backdropPath = movie["backdrop_path"] as! String
        
        //URL() Validates URL
        let backdropPathURL = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        //takes care of downloading and setting image
        backdropView.af_setImage(withURL: backdropPathURL!)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
