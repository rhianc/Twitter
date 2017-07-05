//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
//import Alamofire

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userFull: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweet: UIButton!
    @IBOutlet weak var favorite: UIButton!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            profilePic.layer.cornerRadius = 0.5*profilePic.frame.width
            profilePic.layer.masksToBounds = true
            profilePic.af_setImage(withURL: tweet.user.profilePicURL!)
            userFull.text = tweet.user.name
            username.text = "\(tweet.user.screenName!)  \(tweet.createdAtString)"
            retweetCount.text = String(tweet.retweetCount)
            likeCount.text = String(tweet.favoriteCount!)
            if tweet.favorited{
                favorite.isSelected = true
            }
            if tweet.retweeted{
                retweet.isSelected = true
            }
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
    
    @IBAction func reply(_ sender: UIButton) {
    }
    
    @IBAction func retweet(_ sender: UIButton) {
        if sender.isSelected != true{
            sender.isSelected = true
            APIManager.shared.retweet(tweet: tweet)
            retweetCount.text = String(Int(retweetCount.text!)!+1)
        }
        else{
            sender.isSelected = false
            APIManager.shared.unretweet(tweet: tweet)
            retweetCount.text = String(Int(retweetCount.text!)!-1)
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        if sender.isSelected != true{
            sender.isSelected = true
            APIManager.shared.favorite(tweet: tweet)
            likeCount.text = String(Int(likeCount.text!)!+1)
        }
        else{
            sender.isSelected = false
            APIManager.shared.unfavorite(tweet: tweet)
            likeCount.text = String(Int(likeCount.text!)!-1)
        }
    }
    
    @IBAction func dm(_ sender: UIButton) {
    }
    
}
