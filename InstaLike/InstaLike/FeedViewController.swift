//
//  FeedViewController.swift
//  InstaLike
//
//  Created by Naveena vishnu on 10/25/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //creating outlet for table view:
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]() //Just like array of movies i create an array of posts

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //adding view did appear -> cus u want to refresh and pull in latest post
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //making queries: look at doc
        let query = PFQuery(className:"Posts")
        //need inclode key:
        //changed for part2 cus we wanna bring in comments also
        query.includeKeys(["author", "comments", "comments.author"]) //fethcing key cus we wanna fetch the onj
        query.limit = 20
        
        //actually performing the configured query:
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    //need to impl functions cus we added UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        
         //what type of cell to return? a;ways gonna be the zeroth path
        if indexPath.row == 0{
            //if true then its def gonna be a post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell //cus     wanna access outlets I created
        
//            //grabbing post: moved to top during part 2
//            let post = posts[indexPath.row] //indexPath.row to grab particular row
        
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
        
            //setting caption label:
            cell.captionLabel.text = post["caption"] as! String
        
            //need to grab the image url:
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
        
            cell.photoView.af_setImage(withURL: url)
        
            return cell
        } else{
            //want another cell type:
            let cell = tableView.dequeueReusableCell(withIdentifier: "abcd") as! CommentCell
            
            //configuring the comments:
            let comment = comments[indexPath.row - 1] // cus =0; that will be the post; 0th comment is when indexpath.row = 1
            cell.commentLabel.text =  comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
    }
    
//creating comments: fake
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get call back every time user taps on the img
        //task: choose post and add comment:
        //select row
        let post = posts[indexPath.row]
        //create comment object
        let comment =  PFObject(className: "Comments")
        comment["text"] = "Rondome comment for testing"
        //want comment to know which post its realted to
        comment["post"] = post
        //who created the comment
        comment["author"] = PFUser.current()!
        
        //relationship magic:
        
        post.add(comment, forKey: "comments") //i think every post should have an array of comments -> add this comment to the array
        
        //smart abt what it saves: Parse
        post.saveInBackground { (success, error) in
            if success {
                print("comment saved")
            }else{
                print("Error saving comment")
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //logout!
     
  
    @IBAction func onLogoutButton(_ sender: Any) {
        //once the logout buttin is tapped we wanna perform the logout action!
        
        //clear the parse cache:
        PFUser.logOut()
        
        //just like the staying logged in func -> switch user back to the sign-in page so need to give the viewcontroller a name
        let main = UIStoryboard(name: "Main", bundle: nil) //parsing the xml; also case sensitive
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        //access the window?
        //the one object that exists for each application
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    
}
