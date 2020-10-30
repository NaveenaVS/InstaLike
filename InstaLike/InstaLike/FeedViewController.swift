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
        query.includeKey("author") //fethcing key cus we wanna fetch the onj
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
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell //cus wanna access outlets I created
        
        //grabbing post:
        let post = posts[indexPath.row] //indexPath.row to grab particular row
        
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
