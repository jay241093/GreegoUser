//
//  UpdateprofileViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class UpdateprofileViewController: UIViewController {

    @IBOutlet weak var firstsection: UIView!
    
    @IBOutlet weak var secondsection: UIView!

    @IBOutlet weak var thirdsection: UIView!
    
    @IBOutlet weak var forthsection: UIView!
    
    @IBOutlet weak var fifthsection: UIView!
    
    @IBOutlet weak var sixthsection: UIView!
    
    @IBOutlet weak var seventhsection: UIView!
    @IBOutlet weak var btnview: UIView!
    
    @IBOutlet weak var updateprofileimg: UIImageView!
    
    @IBOutlet weak var updatebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateprofileimg.layer.borderWidth=1.0
        updateprofileimg.layer.masksToBounds = false
        updateprofileimg.layer.borderColor = UIColor.white.cgColor
        updateprofileimg.layer.cornerRadius = updateprofileimg.frame.size.height/2
        updateprofileimg.clipsToBounds = true
        
        firstsection.layer.shadowColor = UIColor.lightGray.cgColor
        firstsection.layer.shadowOpacity = 0.5
        firstsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        firstsection.layer.shadowRadius = 2
        
        secondsection.layer.shadowColor = UIColor.lightGray.cgColor
        secondsection.layer.shadowOpacity = 0.5
        secondsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        secondsection.layer.shadowRadius = 2
        
        thirdsection.layer.shadowColor = UIColor.lightGray.cgColor
        thirdsection.layer.shadowOpacity = 0.5
        thirdsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        thirdsection.layer.shadowRadius = 2
        
        forthsection.layer.shadowColor = UIColor.lightGray.cgColor
        forthsection.layer.shadowOpacity = 0.5
        forthsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        forthsection.layer.shadowRadius = 2
        
        fifthsection.layer.shadowColor = UIColor.lightGray.cgColor
        fifthsection.layer.shadowOpacity = 0.5
        fifthsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        fifthsection.layer.shadowRadius = 2
        
        sixthsection.layer.shadowColor = UIColor.lightGray.cgColor
        sixthsection.layer.shadowOpacity = 0.5
        sixthsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        sixthsection.layer.shadowRadius = 2
        
        seventhsection.layer.shadowColor = UIColor.lightGray.cgColor
        seventhsection.layer.shadowOpacity = 0.5
        seventhsection.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        seventhsection.layer.shadowRadius = 2
        
        
        updatebtn.layer.shadowColor = UIColor.lightGray.cgColor
        updatebtn.layer.shadowOpacity = 0.5
        updatebtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        updatebtn.layer.shadowRadius = 2
        
        btnview.layer.shadowColor = UIColor.lightGray.cgColor
        btnview.layer.shadowOpacity = 0.5
        btnview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnview.layer.shadowRadius = 2
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
