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
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            profilePic.af_setImage(withURL: tweet.user.profilePicURL!)
            userFull.text = tweet.user.name
            username.text = "\(tweet.user.screenName!)  \(tweet.createdAtString)"
            retweetCount.text = String(tweet.retweetCount)
            likeCount.text = String(tweet.favoriteCount!)
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
    }
    
    @IBAction func like(_ sender: UIButton) {
    }
    
    @IBAction func dm(_ sender: UIButton) {
    }
    
}
