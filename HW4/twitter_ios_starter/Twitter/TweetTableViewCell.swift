//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Ali Malik on 3/6/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var tweetID:Int = -1
    
    func setFavorited(_ isFav:Bool){
        favorited = isFav
        if (isFav){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favTweet(_ sender: Any) {
        let tobeFav = !favorited
        if(tobeFav){
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Fav did not work\(error)")
            })
        } else{
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorited(false)
            }, failure: { (error) in
                print("unFav did not work\(error)")
            })
        }
        
    }
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: tweetID, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error in retwet \(error)")
        })
        
    }
    
    func setRetweeted(_ isRet:Bool){
        if(isRet){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
