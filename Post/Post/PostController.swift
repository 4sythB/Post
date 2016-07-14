//
//  PostController.swift
//  Post
//
//  Created by Brad on 7/12/16.
//  Copyright © 2016 Brad. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts")
    static let endpoint = baseURL?.URLByAppendingPathExtension("json")
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    weak var delegate: PostControllerDelegate?
    
    init() {
        fetchPosts()
    }
    
    func addPost(username: String, text: String) {
        let post = Post(username: username, text: text)
        guard let requestURL = post.endpoint else { return }
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put, body: post.jsonData) { (data, error) in
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else if responseDataString.containsString("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Success! \n\(responseDataString)")
            }
        }
        fetchPosts()
    }
    
    func fetchPosts(reset: Bool = true, completion: ((newPosts: [Post]?) -> Void)? = nil) {
        let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : posts.last?.timeStamp ?? NSDate().timeIntervalSince1970
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        guard let url = PostController.endpoint else {
            fatalError("Post Endpoint url failed")
        }
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            guard let data = data,
                postDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String : [String : AnyObject]] else {
                    print("Error: NSJSONSerialization of postDictionaries failed. \n\(responseDataString)")
                    if let completion = completion {
                        completion(newPosts: [])
                    }
                    return
            }
            
            let keyValue = postDictionaries.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            let sortedPosts = keyValue.sort({$0.0.timeStamp > $0.1.timeStamp})
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let reset = reset
                if reset == true {
                    self.posts = sortedPosts
                } else {
                    self.posts.appendContentsOf(sortedPosts)
                }
                
                if let completion = completion {
                    completion(newPosts: sortedPosts)
                }
            })
        }
    }
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}
