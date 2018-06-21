//
//  TipViewController.swift
//  greegotaxiapp
//
//  Created by Ravi Dubey on 5/29/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import CTCheckbox
import Alamofire
class TipViewController: UIViewController,UITextFieldDelegate {
    var amount = ""
    
    var tripid : String = ""
    var Finalamount:Double = 0

var iffromclonejob = 0
    var drivername: String = ""
    
    @IBOutlet weak var lblamount: UILabel!
    
    
    @IBOutlet weak var btn10: UIButton!
    
    @IBOutlet weak var btn15: UIButton!
    
    @IBOutlet weak var btn20: UIButton!
    
    
    @IBOutlet weak var txttip: UITextField!
    
    @IBOutlet weak var cb: CTCheckbox!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myDouble = Double(amount)
        let doubleStr = String(format: "%.2f", myDouble!)
        
  lblamount.text = " Trip Amount $ " +  doubleStr
        
        
        setshadow(myBtn: btn10)
        setshadow(myBtn: btn15)
        setshadow(myBtn: btn20)

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.showAnimate()
        Finalamount = 0

        let amount1 = String(Double(amount)!*(10/100))
        let doubleStr3 = "$" + String(format: "%.1f", Double(amount)!*(10/100))

        
        let amount2 = String(Double(amount)!*(15/100))
        let doubleStr1 =  "$" + String(format: "%.1f",Double(amount)!*(15/100))

        let amount3 = String(Double(amount)!*(20/100))
        let doubleStr2 =  "$" + String(format: "%.1f",Double(amount)!*(20/100))


        btn10.setTitle(doubleStr3, for:.normal)
        btn15.setTitle(doubleStr1, for: .normal)
        btn20.setTitle(doubleStr2, for: .normal)


        // Do any additional setup after loading the view.
    }

    
    func setshadow(myBtn:UIButton)
    {
       
        myBtn.layer.shadowColor = UIColor.lightGray.cgColor
        myBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        myBtn.layer.masksToBounds = false
        myBtn.layer.shadowRadius = 1.0
        myBtn.layer.shadowOpacity = 0.5
        myBtn.layer.cornerRadius = myBtn.frame.width / 2
        myBtn.layer.borderWidth = 2.0
        myBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnnextaction(_ sender: Any) {
        
     if(cb.checked == false && txttip.text == "" && isselected15 == 0 && isselected10 == 0 && isselected20 == 0)
     {
        let alert = UIAlertController(title: nil, message: "Please choose tip option", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        }
        else
     {
        Tipuser()
        
        }
        
        
        
    }
  
    
 var isselected10 = 0
 var isselected15 = 0
 var isselected20 = 0


    @IBAction func btn10action(_ sender: Any) {
        
        btn15.backgroundColor = UIColor.lightGray
        btn15.titleLabel?.textColor = UIColor.black
        
        btn20.backgroundColor = UIColor.lightGray
        btn20.titleLabel?.textColor = UIColor.black
        isselected15 = 0
        isselected20 = 0
      
     if(isselected10 == 0)
     {
        txttip.text = ""
        txttip.isEnabled = false

        Finalamount =   Double(amount)! * (10/100)
        
        isselected10 = 1
        
        btn10.backgroundColor = UIColor(red:0.00, green:0.82, blue:0.69, alpha:1.0)

        btn10.titleLabel?.textColor = UIColor.white
        }
        else
     {
        txttip.isEnabled = true

        
        Finalamount =  0
        isselected10 = 0
        
        btn10.backgroundColor = UIColor.lightGray
         btn10.titleLabel?.textColor = UIColor.black
        
        }
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let str = txttip.text! as! NSString
        Finalamount = str.doubleValue
        
        
    }
    
    
    @IBAction func btn15action(_ sender: Any) {
        isselected20 = 0
        isselected10 = 0
        btn10.backgroundColor = UIColor.lightGray
        btn10.titleLabel?.textColor = UIColor.black
        
        btn20.backgroundColor = UIColor.lightGray
        btn20.titleLabel?.textColor = UIColor.black
        
        
        if(isselected15 == 0)
        {
            txttip.text = ""
            txttip.isEnabled = false

            Finalamount = Double(amount)!  * (15/100)
            isselected15 = 1
            
            btn15.backgroundColor = UIColor(red:0.00, green:0.82, blue:0.69, alpha:1.0)
            
            btn15.titleLabel?.textColor = UIColor.white
        }
        else
        {
            txttip.isEnabled = true

            Finalamount =  0
            isselected15 = 0
            
            btn15.backgroundColor = UIColor.lightGray
            btn15.titleLabel?.textColor = UIColor.black
            
        }
        
        
    }
    
    @IBAction func btn20action(_ sender: Any) {
        
        isselected15 = 0
        isselected10 = 0

        btn10.backgroundColor = UIColor.lightGray
        btn10.titleLabel?.textColor = UIColor.black
        
        btn15.backgroundColor = UIColor.lightGray
        btn15.titleLabel?.textColor = UIColor.black
        
        
        if(isselected20 == 0)
        {
            txttip.text = ""
            txttip.isEnabled = false
            Finalamount = Double(amount)!  * (20/100)
            isselected20 = 1
            
            btn20.backgroundColor = UIColor(red:0.00, green:0.82, blue:0.69, alpha:1.0)
            
            btn20.titleLabel?.textColor = UIColor.white
        }
        else
        {
           
            txttip.isEnabled = true
             Finalamount = 0
            isselected20 = 0
            
            btn20.backgroundColor = UIColor.lightGray
            btn20.titleLabel?.textColor = UIColor.black
            
        }
        
        
        
        
        
    }
    
    @IBAction func checkaction(_ sender: Any) {
    if(cb.checked)
    {
       
       Finalamount =  0.0
        btn10.backgroundColor = UIColor.lightGray
        btn10.titleLabel?.textColor = UIColor.black
        
        btn15.backgroundColor = UIColor.lightGray
        btn15.titleLabel?.textColor = UIColor.black
        
        btn20.backgroundColor = UIColor.lightGray
        btn20.titleLabel?.textColor = UIColor.black
        
        
        txttip.isEnabled = false
        btn10.isEnabled = false
        btn15.isEnabled = false
        btn20.isEnabled = false


        }
        else
    {
        
        btn10.isEnabled = true
        btn15.isEnabled = true
        btn20.isEnabled = true
        txttip.isEnabled = true

        }
        
        
    }
    
    
    
    func Tipuser()
    {
       if(iffromclonejob == 1)
       {
        removeAnimate()
        }
       else{
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()
            
            let ID:Int? = Int(tripid) // firstText is UITextField
            
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            let parameters = [
                "trip_id" : ID!,
                "tip_amount" : Finalamount
                ] as [String : Any]
            
            Alamofire.request(WebServiceClass().BaseURL+"user/get/tipupdate", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    WebServiceClass().dismissprogress()
                    
                   // print(response.result.value! )
                    let dic: NSDictionary =  response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey: "error_code") as! NSNumber  == 0)
                    {
                       
                        self.removeAnimate()
                        
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverRatingVC") as! DriverRatingVC
                        
                        let amount1 = Double(self.amount)! + Double(self.Finalamount)
                        
                        
                        vc.amount = String(format: "%.2f", Double(amount1))
                        vc.tripid =  self.tripid
                        self.navigationController?.pushViewController(vc, animated: true)
                        print(self.amount + String(self.Finalamount))
                        
//                        let alert = UIAlertController(title: nil, message:"Tip added successfully", preferredStyle: UIAlertControllerStyle.alert)
//
//                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Greego) in
//
//
//
//                        }))
//                        self.present(alert, animated: true, completion: nil)

                        
                        
                   
                        
                    }else{
                        
                        
                    }
                    
                    break
                case .failure(_):
                    WebServiceClass().dismissprogress()
                    
                    print(response.result.error ?? "")
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
