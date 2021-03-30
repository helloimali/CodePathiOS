//
//  FeedViewController.swift
//  instagram
//
//  Created by Ali Malik on 3/30/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        
//        print("CELL PRINT2")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("CELL PRINT3")
        let query = PFQuery(className: "post")
        // Fetch the actual object, need to do it for author, but not file
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackground { (posts, err) in
            if posts != nil{
                self.posts = posts!
//                print(self.posts)
//                print("ERROR", err)
                self.tblView.reloadData()
            }else{
                print("No posts found!!")
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("POST COUNT", posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        // Get particular row
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.userNameLbl.text = user.username
        
        cell.captionLbl.text = post["caption"] as? String
//        print("CELL PRINT")
//        print("Username: ", user.username)
        let imgFile = post["img"] as! PFFileObject
        let urlStirng = imgFile.url!
        let url = URL(string: urlStirng)!
        
        cell.photoView.af_setImage(withURL: url)
        return cell
        
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
