//
//  LoginViewController.swift
//  InstaLike
//
//  Created by Naveena vishnu on 10/25/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    //setting up outlets from the login screen:
    
    @IBOutlet weak var usernameField: UITextField! //for the username text field
    @IBOutlet weak var passwordField: UITextField! //for the passwors text field
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//creating action: cus we wanna perform tasks if user signs in and signs up
    
    @IBAction func onSignIn(_ sender: Any) {
        //allow user to login
        let username = usernameField.text! //to make it a string
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            //here u only have two options: either i have a user or it is nil
            if user != nil{
                //i successfully logged on then perform segue as the sign up other wise display error message
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else{
                print("Error in sign in:\(error?.localizedDescription)")
                           
            }
        }
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let user = PFUser() //changed to let cus we don't chnage the user so making it const
        user.username = usernameField.text
        user.password = passwordField.text
       
        user.signUpInBackground { (success, error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                //if sign up failed:
                print("Error in sign up:\(error?.localizedDescription)")
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

}
