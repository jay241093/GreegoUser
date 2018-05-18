//
//  SettingViewController.swift
//  Pods-greegotaxiapp
//
//  Created by Harshal Shah on 4/5/18.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settinglbl1: UILabel!
    
    @IBOutlet weak var firstview: UIView!
    
    @IBOutlet weak var secondview: UIView!
    
    @IBOutlet weak var thirdview: UIView!
    
    @IBOutlet weak var forthview: UIView!

    @IBOutlet weak var fifthview: UIView!
    
    @IBOutlet weak var profileimg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileimg.layer.borderWidth=1.0
        profileimg.layer.masksToBounds = false
        profileimg.layer.borderColor = UIColor.white.cgColor
        profileimg.layer.cornerRadius = profileimg.frame.size.height/2
        profileimg.clipsToBounds = true
        
        firstview.layer.shadowColor = UIColor.lightGray.cgColor
        firstview.layer.shadowOpacity = 0.5
        firstview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        firstview.layer.shadowRadius = 2
        
        
        secondview.layer.shadowColor = UIColor.lightGray.cgColor
        secondview.layer.shadowOpacity = 0.5
        secondview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        secondview.layer.shadowRadius = 2
        
        thirdview.layer.shadowColor = UIColor.lightGray.cgColor
        thirdview.layer.shadowOpacity = 0.5
        thirdview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        thirdview.layer.shadowRadius = 2
        
        forthview.layer.shadowColor = UIColor.lightGray.cgColor
        forthview.layer.shadowOpacity = 0.5
        forthview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        forthview.layer.shadowRadius = 2
        
        fifthview.layer.shadowColor = UIColor.lightGray.cgColor
        fifthview.layer.shadowOpacity = 0.5
        fifthview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        fifthview.layer.shadowRadius = 2
        
        
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
