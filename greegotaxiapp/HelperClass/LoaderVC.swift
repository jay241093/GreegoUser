//
//  LoaderVC.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 5/17/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import ImageIO
class LoaderVC: UIViewController {

    @IBOutlet weak var imgview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
//WebServiceClass().showwithimage()
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "giphy", withExtension: "gif")!)
        
        
        imgview.image = UIImage(data: imageData!)
        // Do any additional setup after loading the view.
    }
    
    @objc func AcceptRequest(notification: NSNotification) {
       // WebServiceClass().dismissprogress()
       removeAnimate()
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
