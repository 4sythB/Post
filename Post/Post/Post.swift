//
//  Post.swift
//  Post
//
//  Created by Brad on 7/12/16.
//  Copyright © 2016 Brad. All rights reserved.
//

import Foundation

class Post {
    
    let usernameKey: String = "usernameKey"
    let textKey: String = "textKey"
    let timeStampKey: String = "timeStampKey"
    let identifierKey: String = "identifierKey"
    
    let username: String
    let text: String
    var timeStamp: NSTimeInterval
    var identifier: NSUUID
    
    var endpoint: NSURL? {
        let url = PostController.baseURL?.URLByAppendingPathComponent("\(identifier).json")
        return url
    }
    
    var jsonValue: [String : AnyObject] {
        return [usernameKey : username, textKey : text, timeStampKey : timeStamp, identifierKey : identifier]
    }
    
    var jsonData: NSData? {
        return  try? NSJSONSerialization.dataWithJSONObject(jsonValue, options: .PrettyPrinted)
    }
    
    init(username: String, text: String, timeStamp: NSTimeInterval = NSDate().timeIntervalSince1970, identifier: NSUUID = NSUUID()) {
        self.username = username
        self.text = text
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        
        guard let username = dictionary["username"] as? String,
            text = dictionary["text"] as? String,
            timeStamp = dictionary["timestamp"] as? NSTimeInterval else {
                return nil
        }
        
        self.username = username
        self.text = text
        self.timeStamp = timeStamp
        guard let identifier = NSUUID(UUIDString: identifier) else { return nil }
        self.identifier = identifier
    }
}
