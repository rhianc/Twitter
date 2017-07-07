//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Rhian Chavez on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var user: User = User.current!
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.top = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame.size.width = view.frame.size.width
        tableView.estimatedRowHeight = 100
        APIManager.shared.getUserTimeLine(user: user) { (tweetsdic: [Tweet]?, error: Error?) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                self.tweets = tweetsdic!
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTopTableViewCell", for: indexPath) as! ProfileTopTableViewCell
            cell.user = user
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return tweets.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
