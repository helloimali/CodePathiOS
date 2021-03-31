//
//  CameraViewController.swift
//  Pods
//
//  Created by Ali Malik on 3/30/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSubmitBtn(_ sender: Any) {
        
        // Parse will create it table on the fly
        let post = PFObject(className: "post")
        //Pet is a dictionary
        
        //Adding Key = Value pairs
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        //Support binary ojects like photos
        let imgData = imgView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imgData!)
        post["img"] = file
        
        post.saveInBackground { (succ, err) in
            if succ{
                self.dismiss(animated: true, completion: nil)
                print("Saved!!")
            }else{
                print("ERROR")
            }
        }
    }
    
    @IBAction func onCamBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.editedImage] as! UIImage
        
        let size = CGSize (width: 300, height: 300)
        let scaledImage = img.af_imageAspectScaled(toFill: size)
        imgView.image = scaledImage
        
        //dismiss camera view
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
