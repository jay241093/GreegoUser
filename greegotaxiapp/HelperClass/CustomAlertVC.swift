//
//  CustomAlertVC.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 6/11/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
protocol Confrimrequest {
    func yesAction()
}
class CustomAlertVC: UIViewController {

    var StrSource : String?
    var StrDestination : String?

    var delegate: Confrimrequest?
    
    @IBOutlet weak var lblsource: UILabel!
    
    @IBOutlet weak var lbldestination: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblsource.text = StrSource
        
        lbldestination.text = StrDestination

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
                
            }
        });
    }

    
    @IBAction func Okaction(_ sender: Any) {
         removeAnimate()
        delegate?.yesAction()
    }
    
    @IBAction func canelaction(_ sender: Any) {
        removeAnimate()
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
