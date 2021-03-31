//
//  FeedViewController.swift
//  instagram
//
//  Created by Ali Malik on 3/30/21.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate{
    @IBOutlet weak var tblView: UITableView!
    let commentBar = MessageInputBar()
    var showCommentBar = false
    var posts = [PFObject]()
    var selectedPost: PFObject! //is of type PFobject
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment... "
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self

        tblView.delegate = self
        tblView.dataSource = self
        
        // Keyboard dismiss via swime down
        tblView.keyboardDismissMode = .interactive
        
        //Grab the notification --> I want to observe event
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(node:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        print("CELL PRINT2")
        // Do any additional setup after loading the view.
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (suc, err) in
            if suc{
                print("Comment Saved")
            }else{
                print("Error saving comment")
            }
        }
        tblView.reloadData()
        
        // Clear and dismiss the input
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillBeHidden(node: Notification){
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        // Raise keyboard
        commentBar.inputTextView.becomeFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("CELL PRINT3")
        let query = PFQuery(className: "post")
        // Fetch the actual object, need to do it for author, but not file
        query.includeKeys(["author","comments","comments.author"])
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
        // Number of comments + 1 (for the actual post)
        
        let post = posts[section]
        // ?? is the nill coaleassing operator
        // Meaning, if it's nill, set it to []
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count+2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get particular row
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            
            
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
        }else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
            let comment = comments[indexPath.row - 1]
            cell.commentLbl.text = comment["text"] as! String
            
            let user = comment["author"] as!PFUser
            cell.name.text = user.username
            
            return cell
        }else{
            // No custom cell because not dynamically modifying it
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count+1{
            //show comment bar
            showCommentBar = true
            becomeFirstResponder()
            // Raise keyboard
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
            // First responder is like focus
        }
        
    }
    
    
    @IBAction func onLogoutBrn(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "loginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
    
    
    //MESSAGE BAR
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showCommentBar
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
