//
//  UpdateEmailVC.swift
//  Greegodriverapp
//
//  Created by Harshal Shah on 12/05/18.
//  Copyright © 2018 Harshal Shah. All rights reserved.
//

import UIKit
import Alamofire
class UpdateEmailVC: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var txtFEmail: UITextField!
    @IBOutlet weak var btnSendConfirmationlink: UIButton!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.txtFEmail.text = email
        setShadow(view: header)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SendConfirmaion(_ sender: UIButton) {
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "device_id": UserDefaults.standard.value(forKey: "Token") as! String
                
            ]
            
            
            Alamofire.request(WebServiceClass().BaseURL+"user/verify/email", method: .post, parameters:[:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    
                    if let data = response.result.value{
                        //    print(response.result.value!)
                        
                        let dic: NSDictionary =  response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                        {
                            
                            
                            let dialogMessage = UIAlertController(title: nil, message:"Email Sent Successfully", preferredStyle: .alert)
                            
                            
                            // Create Cancel button with action handlder
                            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            }
                            
                            //Add OK and Cancel button to dialog message
                            dialogMessage.addAction(cancel)
                            
                            // Present dialog message to user
                            self.present(dialogMessage, animated: true, completion: nil)
                            
                        }
                    }
                    break
                    
                case .failure(_):
                    WebServiceClass().dismissprogress()
                    
                    // print(response.result.error)
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
    
    @IBAction func backBtnAcion(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

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
func setShadow(view: UIView)
{
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    view.layer.shadowRadius = 2
}
