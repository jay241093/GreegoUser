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
    var count = 60
    var timer : Timer?

    @IBOutlet weak var imgview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
//WebServiceClass().showwithimage()
        NotificationCenter.default.addObserver(self, selector:  #selector(AcceptRequest), name: NSNotification.Name(rawValue: "Acceptnotification"), object: nil)
      let jeremyGif = UIImage.gifImageWithName("loader")
        imgview.image = jeremyGif
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    @objc func update() {
        if(count > 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            count -= 1
            if count == 0 {
                timer?.invalidate()
                let alert = UIAlertController(title: "Greego", message: "Non of drivers accepted your request", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: { (Alert) in
                    
                    self.removeAnimate()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }else{
            timer?.invalidate()
        }
    }
    
    @objc func AcceptRequest(notification: NSNotification) {
        timer?.invalidate()

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
