//
//  PostListTableViewController.swift
//  Post
//
//  Created by Brad on 7/12/16.
//  Copyright © 2016 Brad. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postController.delegate = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl?.addTarget(self, action: #selector(PostListTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(post.username) \(post.timeStamp)"
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    func postsUpdated(posts: [Post]) {
        postController.fetchPosts()
        tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        refreshControl.beginRefreshing()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Helper Functions
    
    func presentNewPostAlert() {
        let alert = UIAlertController(title: "New post", message: "Share your thoughts, ideas, and whatever", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { userNameTextField in
            userNameTextField.placeholder = "Enter username"
        }
        alert.addTextFieldWithConfigurationHandler { messageTextField in
            messageTextField.placeholder = "Begin typing your message"
        }
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { (UIAlertAction) in
            guard let userNameTextField = alert.textFields?[0],
                username = userNameTextField.text,
                messageTextField = alert.textFields?[1],
                message = messageTextField.text else { return }
            
            if username.characters.count > 0 && message.characters.count > 0 {
                self.postController.addPost(username, text: message)
                self.tableView.reloadData()
            } else {
                self.presentErrorAlert()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alert.addAction(postAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Try Again", message: "You may be missing information. Please try again.", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.presentNewPostAlert()
        })
        
        errorAlert.addAction(okAction)
        
        presentViewController(errorAlert, animated: true, completion: nil)
    }
    
    // MARK: - Action Buttons
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        presentNewPostAlert()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
