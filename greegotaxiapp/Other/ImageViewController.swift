//
//  ImageViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/6/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{
    
//MARK: - Delegate Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - IBAction Methods
    
    @IBAction func cameraaction(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func gallaryaction(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}
