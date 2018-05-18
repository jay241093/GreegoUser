//
//  PromocodeViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/10/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class PromocodeViewController: UIViewController {

    @IBOutlet weak var applybtn: UIButton!
    @IBOutlet weak var offbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "paymentbackimg")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
         self.setShadow(view: applybtn)
        self.setShadow(view: offbtn)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 2
    }
    
    @IBAction func applybtnaction(_ sender: Any) {
        
        
        applybtn.setTitle("Applied", for: .normal)
        applybtn.backgroundColor = UIColor(red:0.82, green:0.84, blue:0.84, alpha:1.0)
        
        
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
