//
//  FreetripsViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/9/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
class FreetripsViewController: UIViewController {

    var invitecode : String = ""
    
    @IBAction func backaction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    @IBOutlet weak var txtinvitecode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "rateimg")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sharebtnaction(_ sender: Any) {
      
            let text = "Please join Greego by this code" + invitecode
            
            let shareAll = [text]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
     
    }
    
    func getData()
    {
      
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            
            
            Alamofire.request(WebServiceClass().BaseURL+"user/me", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value!)
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let dataDic: NSDictionary = dic.value(forKey: "data") as! NSDictionary
                            
                            self.invitecode =  dataDic.value(forKey: "invitecode") as! String
                            
                            self.txtinvitecode.text = dataDic.value(forKey: "invitecode") as! String
                        }
                        WebServiceClass().dismissprogress()
                        
                    }
                    break
                    
                case .failure(_):
                    WebServiceClass().dismissprogress()
                    
                    print(response.result.error)
                    break
                    
                }
            }
        }
        else
        {
            WebServiceClass().nointernetconnection()
            
            NSLog("No Internet Connection")
        }
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
