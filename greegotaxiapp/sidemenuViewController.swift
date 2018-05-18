//
//  sidemenuViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 03/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class sidemenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imguser: UIImageView!
    
    var reuseid = NSMutableArray()
    
    override func viewDidLoad() {
        
        
    
        reuseid = ["cell","cell1","cell2","cell3","cell4"]
        super.viewDidLoad()
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reuseid.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       var str = reuseid.object(at: indexPath.row) as! String
        
        var dvc:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:str, for: indexPath)
        
        var nameary = ["Payment","Your Trip","Free Rides","Help","Setting"]
        
        dvc.textLabel?.text = nameary[indexPath.row] as! String
        
        dvc.imageView?.image = UIImage(named:"taxi-app-background_23-2147561164")
        
        dvc.imageView?.layer.borderWidth=1.0
         dvc.imageView?.layer.masksToBounds = false
         dvc.imageView?.layer.borderColor = UIColor.white.cgColor
        dvc.imageView?.layer.cornerRadius =  (dvc.imageView?.frame.size.height)!/2
         dvc.imageView?.clipsToBounds = true
        
        return dvc
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
