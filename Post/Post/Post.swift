//
//  Post.swift
//  Post
//
//  Created by Brad on 7/12/16.
//  Copyright © 2016 Brad. All rights reserved.
//

import Foundation

class Post {
    
    private let usernameKey: String = "username"
    private let textKey: String = "text"
    private let timeStampKey: String = "timestamp"
    
    let username: String
    let text: String
    var timeStamp: NSTimeInterval
    var identifier: NSUUID
    
    var endpoint: NSURL? {
        return PostController.baseURL?.URLByAppendingPathComponent(self.identifier.UUIDString).URLByAppendingPathExtension("json")
    }
    
    var jsonValue: [String : AnyObject] {
        return [usernameKey : username, textKey : text, timeStampKey : timeStamp]
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
        self.identifier = NSUUID(UUIDString: identifier) ?? NSUUID()
    }
}
