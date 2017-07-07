//
//  ProfileTopTableViewCell.swift
//  twitter_alamofire_demo
//
//  Created by Rhian Chavez on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileTopTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    
    var user: User!{
        didSet{
            profileImage.layer.cornerRadius = 0.5*profileImage
                .frame.width
            profileImage.layer.masksToBounds = true
            backgroundImage.af_setImage(withURL: user.profileBackgroundURL!)
            profileImage.af_setImage(withURL: user.profilePicURL!)
            name.text = user.name
            username.text = "@"+user.screenName!
            bio.text = user.description
            followingNum.text = user.followingCount
            followersNum.text = user.followersCount
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
