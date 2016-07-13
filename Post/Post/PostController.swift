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
    static let jsonEndpoint = baseURL?.URLByAppendingPathExtension("json")
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    weak var delegate: PostControllerDelegate?
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts(completion: ((newPosts: [Post]) -> Void)? = nil) {
        guard let url = PostController.jsonEndpoint else {
            fatalError("Post Endpoint url failed")
        }
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
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
                
                self.posts = sortedPosts
                
                if let completion = completion {
                    completion(newPosts: sortedPosts)
                    print(sortedPosts)
                }
            })
        }
    }
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}
