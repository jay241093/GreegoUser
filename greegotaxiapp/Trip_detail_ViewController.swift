//
//  Trip_detail_ViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/4/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class Trip_detail_ViewController: UIViewController {

    @IBOutlet weak var firstimg: UIImageView!
    @IBOutlet weak var mainview: UIView!
    
    @IBOutlet weak var secondview: UIView!
    
    @IBOutlet weak var thirdview: UIView!
    
    @IBOutlet weak var btnshadow: UIButton!
    
    @IBOutlet weak var mapshadowview: UIView!
    
    @IBOutlet weak var firstlbl: UILabel!
    
    @IBOutlet weak var endlbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor(red:0.00, green:0.58, blue:0.59, alpha:1.0)]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"S", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:"tart", attributes:attrs2)
        
        let attributedString3 = NSMutableAttributedString(string:"E", attributes:attrs1)
        
        let attributedString4 = NSMutableAttributedString(string:"nd", attributes:attrs2)
        attributedString1.append(attributedString2)
        attributedString3.append(attributedString4)
        self.firstlbl.attributedText = attributedString1
        self.endlbl.attributedText = attributedString3
        
        
        
        firstimg.layer.borderWidth=1.0
        firstimg.layer.masksToBounds = false
        firstimg.layer.borderColor = UIColor.white.cgColor
        firstimg.layer.cornerRadius = firstimg.frame.size.height/2
        firstimg.clipsToBounds = true
       
        
        
        mainview.layer.shadowColor = UIColor.lightGray.cgColor
        mainview.layer.shadowOpacity = 0.5
       mainview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mainview.layer.shadowRadius = 2
       
        
        
        secondview.layer.shadowColor = UIColor.lightGray.cgColor
        secondview.layer.shadowOpacity = 0.5
        secondview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        secondview.layer.shadowRadius = 2
        
        thirdview.layer.shadowColor = UIColor.lightGray.cgColor
        thirdview.layer.shadowOpacity = 0.5
        thirdview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        thirdview.layer.shadowRadius = 2
        
        mapshadowview.layer.shadowColor = UIColor.lightGray.cgColor
        mapshadowview.layer.shadowOpacity = 0.5
        mapshadowview.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mapshadowview.layer.shadowRadius = 2
       
        
        btnshadow.layer.shadowColor = UIColor.lightGray.cgColor
        btnshadow.layer.shadowOpacity = 0.5
        btnshadow.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        btnshadow.layer.shadowRadius = 2
        
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
