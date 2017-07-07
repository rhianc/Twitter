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
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(user.dictionary)
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
                //print(self.tweets)
                //print("got here")
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
            //print("hlo")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
