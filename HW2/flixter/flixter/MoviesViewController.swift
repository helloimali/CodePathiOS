//
//  MoviesViewController.swift
//  flixter
//
//  Created by Ali Malik on 2/20/21.
//

import UIKit
//Step 1, add UITableViewDataSource, UITableViewDelegate

//After doing pod init, pod AlamofireImage, pod install
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //Step 2, have these 2 functions [see below]


    //Properties
    // Avalible for the lifetime of this screen
    
    //Array of Dictionaryes
    var movies  = [[String:Any]]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Step 3
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    
        //print("HELLO")
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                //print(dataDictionary)
                //movies is set to the "results" key value
                //Casting
                self.movies = dataDictionary["results"] as! [[String:Any]]
                // calls the functions below once more
                self.tableView.reloadData()
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
    //Step 2
    //These fucntions are not called continuosly
    // called when view loader is spun up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of rows
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Returns cell
        //let cell = UITableViewCell()
        // Instead we use this
        // Why? Because we like saving memory.
        // If another cell is off screen, then lets recycle a cell.
        // Else, new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // movies[index]
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let summary = movie["overview"] as! String
        
        // \() is throwing in a variable
        //cell.textLabel!.text = "row: \(indexPath.row)"
        //cell.textLabel!.text = title
        cell.titleLbl.text = title
        cell.synopsisLbl.text = summary
        //why ? or !
        // Swift
        
        //movie poster
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        //URL() Validates URL
        let posterURL = URL(string: baseURL + posterPath)
        
        //takes care of downloading and setting image
        cell.posterView.af_setImage(withURL: posterURL!)
        // '?' are about optionals
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading Details")
        
        // Find selected Movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass selected movie to the details view controller
        let detailViewController = segue.destination as! MovieDetailsViewController
        detailViewController.movie = movie
        
        //Clean up touch
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
