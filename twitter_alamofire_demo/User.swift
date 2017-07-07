//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var screenName: String?
    var profilePicURL: URL?
    var profileBackgroundURL: URL?
    var description: String?
    var followersCount: String?
    var followingCount: String?
    var id: Int64?
    // For user persistance
    var dictionary: [String: Any]?
    private static var _current: User?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        //print(dictionary)
        id = (dictionary["id"] as! Int64)
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as? String
        var profileString = dictionary["profile_image_url_https"] as! String
        profileString = profileString.replacingOccurrences(of: "normal", with: "bigger")
        let profileBackString = dictionary["profile_banner_url"] as! String
        profilePicURL = URL(string: profileString)
        profileBackgroundURL = URL(string: profileBackString)
        description = dictionary["description"] as? String
        let followersInt = dictionary["followers_count"] as! Int
        let followingInt = dictionary["friends_count"] as! Int
        followersCount = String(followersInt)
        followingCount = String(followingInt)
    }
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
