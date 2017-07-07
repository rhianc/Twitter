//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UserTapDelegate {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame.size.width = view.frame.size.width
        tableView.estimatedRowHeight = 100
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        loadData(completion: {})
    }
    
    func loadData(completion: @escaping () -> Void){
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                completion()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
                completion()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.profilePic.tag = indexPath.row
        cell.delegate = self
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedUser(_:)))
        tapped.numberOfTapsRequired = 1
        cell.profilePic?.addGestureRecognizer(tapped)
        return cell
    }
    
    func tappedUser(_ sender: UITapGestureRecognizer){
        let user = tweets[(sender.view?.tag)!].user
        self.performSegue(withIdentifier: "toProfile", sender: user)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadData(completion: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func did(post: Tweet) {
        tweets.insert(post, at: 0)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compose"{
            let destination = segue.destination as! ComposeViewController
            destination.delegate = self
        }
        if segue.identifier == "toProfile"{
            let destination = segue.destination as! ProfileViewController
            destination.user = sender as! User
        }
    }
    
}
