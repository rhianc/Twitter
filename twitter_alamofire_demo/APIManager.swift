//
//  APIManager.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 4/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import KeychainAccess

class APIManager: SessionManager {
    
    // MARK: TODO: Add App Keys
    static let consumerKey = "8sKLEljNtCVQtALqnLZMeEx7Z"
    static let consumerSecret = "UWYQnWUMiAOdFPNfEBnk0Yu3NPl1FOD0KRAqGtcVt5CEhXvvWB"
    static let requestTokenURL = "https://api.twitter.com/oauth/request_token"
    static let authorizeURL = "https://api.twitter.com/oauth/authorize"
    static let accessTokenURL = "https://api.twitter.com/oauth/access_token"
    static let callbackURLString = "alamoTwitter://"
    
    // MARK: Twitter API methods
    func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        
        // Add callback url to open app when returning from Twitter login on web
        let callbackURL = URL(string: APIManager.callbackURLString)!
        oauthManager.authorize(withCallbackURL: callbackURL, success: { (credential, _response, parameters) in
            
            // Save Oauth tokens
            self.save(credential: credential)
            
            self.getCurrentAccount(completion: { (user, error) in
                if let error = error {
                    failure(error)
                } else if let user = user {
                    print("Welcome \(user.name)")
                    
                    // MARK: TODO: set User.current, so that it's persisted
                    User.current = user
                    success()
                }
            })
        }) { (error) in
            failure(error)
        }
    }
    
    func logout() {
        clearCredentials()
        // TODO: Clear current user by setting it to nil
        User.current = nil
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    
    func getCurrentAccount(completion: @escaping (User?, Error?) -> ()) {
        request(URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!)
            .validate()
            .responseJSON { response in
                
                // Check for errors
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                
                guard let userDictionary = response.result.value as? [String: Any] else {
                    completion(nil, JSONError.parsing("Unable to create user dictionary"))
                    return
                }
                completion(User(dictionary: userDictionary), nil)
        }
    }
        
    func getHomeTimeLine(completion: @escaping ([Tweet]?, Error?) -> ()) {
        /*This uses tweets from disk to avoid hitting rate limit. Comment out if you want fresh tweets*/
//        if let data = UserDefaults.standard.object(forKey: "hometimeline_tweets") as? Data {
//            let tweetDictionaries = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String: Any]]
//            let tweets = Tweet.tweets(with: tweetDictionaries)
//            completion(tweets, nil)
//            return
//        }
        
        request(URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!, method: .get)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                guard let tweetDictionaries = response.result.value as? [[String: Any]] else {
                    print("Failed to parse tweets")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to parse tweets"])
                    completion(nil, error)
                    return
                }
                let data = NSKeyedArchiver.archivedData(withRootObject: tweetDictionaries)
                UserDefaults.standard.set(data, forKey: "hometimeline_tweets")
                UserDefaults.standard.synchronize()
                
                let tweets = Tweet.tweets(with: tweetDictionaries)
                completion(tweets, nil)
        }
    }
    
    // MARK: TODO: Favorite a Tweet
    func favorite(tweet: Tweet){
        let id: String = String(tweet.id)
        let parameters = ["id": tweet.id]
        request(URL(string: "https://api.twitter.com/1.1/favorites/create.json?id=\(id)")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            if response.result.isSuccess{
                print("favorited")
                //completion(tweet, nil)
            } else {
                //completion(nil, response.result.error)
                print(response.error!.localizedDescription)
            }
        }
    }
    
    // MARK: TODO: Un-Favorite a Tweet
    func unfavorite(tweet: Tweet){
        let id: String = String(tweet.id)
        let parameters = ["id": tweet.id]
        request(URL(string: "https://api.twitter.com/1.1/favorites/destroy.json?id=\(id)")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
                if response.result.isSuccess{
                    print("unfavorited")
                    //completion(tweet, nil)
                } else {
                    //completion(nil, response.result.error)
                    print(response.error!.localizedDescription)
                }
            }
        
    }
    
    // MARK: TODO: Retweet
    func retweet(tweet: Tweet){
        let id: String = String(tweet.id)
        let parameters = ["id": tweet.id]
        request(URL(string: "https://api.twitter.com/1.1/statuses/retweet/\(id).json")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess{
                print("retweeted")
                //completion(tweet, nil)
            } else {
                //completion(nil, response.result.error)
                print(response.error!.localizedDescription)
            }
        }
    }

    // MARK: TODO: Un-Retweet
    func unretweet(tweet: Tweet){
        let id: String = String(tweet.id)
        let parameters = ["id": tweet.id]
        request(URL(string: "https://api.twitter.com/1.1/statuses/unretweet/\(id).json")!, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            if response.result.isSuccess{
                print("unretweeted")
                //completion(tweet, nil)
            } else {
                //completion(nil, response.result.error)
                print(response.error!.localizedDescription)
            }
        }
    }

    // MARK: TODO: Compose Tweet
    func composeTweet(with text: String, completion: @escaping (Tweet?, Error?) -> ()) {
        let urlString = "https://api.twitter.com/1.1/statuses/update.json"
        let parameters = ["status": text]
        oauthManager.client.post(urlString, parameters: parameters, headers: nil, body: nil, success: { (response: OAuthSwiftResponse) in
            let tweetDictionary = try! response.jsonObject() as! [String: Any]
            let tweet = Tweet(dictionary: tweetDictionary)
            completion(tweet, nil)
        }) { (error: OAuthSwiftError) in
            print(error)
            completion(nil, error.underlyingError)
        }
    }
    
    // MARK: TODO: Get User Timeline
    func getUserTimeLine(user: User, completion: @escaping ([Tweet]?, Error?) -> ()) {
        let Parameters = ["user_id": user.id]
        request(URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")!, method: .get, parameters: Parameters)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                guard let tweetDictionaries = response.result.value as? [[String: Any]] else {
                    print("Failed to parse tweets")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to parse tweets"])
                    completion(nil, error)
                    return
                }
                let data = NSKeyedArchiver.archivedData(withRootObject: tweetDictionaries)
                UserDefaults.standard.set(data, forKey: "hometimeline_tweets")
                UserDefaults.standard.synchronize()
                
                let tweets = Tweet.tweets(with: tweetDictionaries)
                completion(tweets, nil)
                //print("worked")
        }
    }
    
    //--------------------------------------------------------------------------------//
    
    
    //MARK: OAuth
    static var shared: APIManager = APIManager()
    
    var oauthManager: OAuth1Swift!
    
    // Private init for singleton only
    private init() {
        super.init()
        
        // Create an instance of OAuth1Swift with credentials and oauth endpoints
        oauthManager = OAuth1Swift(
            consumerKey: APIManager.consumerKey,
            consumerSecret: APIManager.consumerSecret,
            requestTokenUrl: APIManager.requestTokenURL,
            authorizeUrl: APIManager.authorizeURL,
            accessTokenUrl: APIManager.accessTokenURL
        )
        
        // Retrieve access token from keychain if it exists
        if let credential = retrieveCredentials() {
            oauthManager.client.credential.oauthToken = credential.oauthToken
            oauthManager.client.credential.oauthTokenSecret = credential.oauthTokenSecret
        }
        
        // Assign oauth request adapter to Alamofire SessionManager adapter to sign requests
        adapter = oauthManager.requestAdapter
    }
    
    // MARK: Handle url
    // OAuth Step 3
    // Finish oauth process by fetching access token
    func handle(url: URL) {
        OAuth1Swift.handle(url: url)
    }
    
    // MARK: Save Tokens in Keychain
    private func save(credential: OAuthSwiftCredential) {
        
        // Store access token in keychain
        let keychain = Keychain()
        let data = NSKeyedArchiver.archivedData(withRootObject: credential)
        keychain[data: "twitter_credentials"] = data
    }
    
    // MARK: Retrieve Credentials
    private func retrieveCredentials() -> OAuthSwiftCredential? {
        let keychain = Keychain()
        
        if let data = keychain[data: "twitter_credentials"] {
            let credential = NSKeyedUnarchiver.unarchiveObject(with: data) as! OAuthSwiftCredential
            return credential
        } else {
            return nil
        }
    }
    
    // MARK: Clear tokens in Keychain
    private func clearCredentials() {
        // Store access token in keychain
        let keychain = Keychain()
        do {
            try keychain.remove("twitter_credentials")
        } catch let error {
            print("error: \(error)")
        }
    }
}

enum JSONError: Error {
    case parsing(String)
}
