//
//  FeedTableViewController.swift
//  Instagram
//
//  Created by 加加林 on 2019/4/14.
//  Copyright © 2019 mumu2plus. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var users = [String: String]()
    var comments = [String]()
    var usernames = [String]()
    var imageFiles = [PFFileObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username
                    }
                }
            }
            let getFollowedUserQuery = PFQuery(className: "Following")
            getFollowedUserQuery.whereKey("follower", equalTo: PFUser.current()?.objectId)
            getFollowedUserQuery.findObjectsInBackground(block: { (objects, error) in
                if let followers = objects {
                    for follower in followers {
                        if let followerUser = follower["following"] {
                            let query = PFQuery(className: "Post")
                            query.whereKey("userid", equalTo: followerUser)
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let posts = objects {
                                    for post in posts {
                                        self.comments.append(post["message"] as! String)
                                        self.usernames.append(post["userid"] as! String)
                                        self.imageFiles.append(post["imageFile"] as! PFFileObject)
                                        self.tableView.reloadData()
                                    }
                                }
                            })
                        }
                    }
                }
            })
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let imageToDisplay = UIImage(data: imageData) {
                    cell.postedImage.image = imageToDisplay
                }
            }
        }
        
        //cell.postedImage.image = UIImage(named: "example1.png")
        cell.comment.text = comments[indexPath.row]
        cell.userInfo.text = usernames[indexPath.row]
        
        return cell
    }

}
