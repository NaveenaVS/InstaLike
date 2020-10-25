//
//  CameraViewController.swift
//  InstaLike
//
//  Created by Naveena vishnu on 10/25/20.
//  Copyright © 2020 vishnaveena. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //outlets:
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var commentField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//the submit button need to perform an action:
    @IBAction func onSubmitButton(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        //creating table schema -> seen in Parse DB
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        //below 2 lines saved in a seperate table for photos
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        //image col will have url -> via file -> Parse handles all of this
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success{
                //on save we wanna dismiss this view
                self.dismiss(animated: true, completion: nil)
                print("Saved :)") //if success displayed in the console for meee :)
            }else{
                print("Error :( ")
            }
        }
        
     
        
    }
//adding gesture recognizer so that when img is tapped we can open camera
    @IBAction func onCameraButton(_ sender: Any) {
        //create controller
        let picker = UIImagePickerController()
        picker.delegate = self //says call me back on a function that has the photo
        picker.allowsEditing = true //presents second screen to the user after they take the photo to allow them to tweak it
        
        //cus in simulator-> need to check to see if camera is available; using swift enum:
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera //when u user real phone, will yun on camera, but if on simulator -> camera not available so will use photolibrary
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    //want image to appear when selected from lib:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //picking an image
        let image = info[.editedImage] as! UIImage
        
        //resizing the image
        let size = CGSize(width: 300, height: 300)
        //using the alomofireimage extension to scale ot down:
        let scaledImage = image.af_imageScaled(to: size)
        //put that scaled image:
        imageView.image = scaledImage
        
        //dismiss the camera view after operation:
        dismiss(animated: true, completion: nil)
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
