//
//  AddpaymentViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/14/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import CreditCardValidator



class AddpaymentViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtdate: UITextField!
    @IBOutlet weak var txtcvv: UITextField!
    @IBOutlet weak var txtzipcode: UITextField!
    
    var cust_id:String = ""
  //  var paymentTextField: STPPaymentCardTextField!

    @IBOutlet weak var pay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCardNumber.delegate = self
        txtdate.delegate = self
        txtdate.tag = 3
        txtcvv.delegate = self
        txtcvv.tag = 4
      
        txtCardNumber.delegate = self
        txtCardNumber.tag = 2
        txtzipcode.tag = 5
txtzipcode.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
     
    }

    
    @IBAction func backbtnaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        
        let str1 = textField.text as NSString?
        let newString = str1?.replacingCharacters(in: range, with: string)
        
        switch textField.tag {
        case 0:
            break
        case 1:
            break
        case 2:
            
            let v = CreditCardValidator()
            if let type = v.type(from: txtCardNumber.text!) {
                if(type.name == "")
                {
                    imgview.image = UIImage(named:"invalidcard")
                    imgview.isHidden = false
                    
                    
                }
                
            else if(type.name == "Visa")
             {
                imgview.image = UIImage(named:"NoVictor_(Visa)")
                imgview.isHidden = false

                
                }
               else if(type.name == "MasterCard")
                {
                    imgview.image = UIImage(named:"mastercard")
                    imgview.isHidden = false

                    
                }
             else if(type.name == "Amex")
             {
                imgview.image = UIImage(named:"American")
                imgview.isHidden = false

                
                }
             else if(type.name == "Discover")
             {
                imgview.image = UIImage(named:"Discovwe")
                imgview.isHidden = false

                }
             else if(type.name == "Diners Club")
             {
                imgview.image = UIImage(named:"Diners")
                imgview.isHidden = false
                
                
                }
                
                else if(type.name == "UnionPay")
                {
                    imgview.image = UIImage(named:"uninonPay")
                    imgview.isHidden = false
                    
                }
             else if(type.name == "JCB")
             {
                imgview.image = UIImage(named:"Jcbb")
                imgview.isHidden = false
                
                }
                
                
            } else {
                imgview.isHidden = false
                imgview.image = UIImage(named:"invalidcard")

                
            }
            
            
            if (isBackSpace == -92) {
                // print("Backspace was pressed")
            }
            else if newString?.characters.count == 5 || newString?.characters.count == 10 || newString?.characters.count == 15 {
                textField.text = textField.text! + " "
            }
            else if newString?.characters.count == 20 {
                return false
                
            }
            break
        case 3:
            if (isBackSpace == -92) {
                //  print("Backspace was pressed")
            }
            else if newString?.characters.count == 3 {
                textField.text = textField.text! + "/"
            }
            else if newString?.characters.count == 6 {
                return false
                
            }
            break
        case 4:
            if (isBackSpace == -92) {
                //  print("Backspace was pressed")
            }
            else if newString?.characters.count == 5 {
                return false
                
            }
            break
        case 5:
            if (isBackSpace == -92) {
                //  print("Backspace was pressed")
            }
            else if textField.text?.characters.count == 5 {
                return false
                
            }
            break
            
        default:
            break
        }
        
        
        return true
    }
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 14)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    var token1: STPToken?
    @IBAction func btnsavepayment(_ sender: Any) {
    
        var lastName = ""
        if(txtdate.text != "")
        {
            var card = self.txtCardNumber.text! as! String
            var str = card.replacingOccurrences(of: " ", with: "")
            var fullName: String = self.txtdate.text!
            let fullNameArr = fullName.components(separatedBy: "/")
            
            var firstName: String = fullNameArr[0]
             lastName = fullNameArr[1]
            
        }
        
        
        
        if(txtCardNumber.text == "")
        {
            let alert = UIAlertController(title: nil, message: "Please enter card number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(txtdate.text == "")
        {
            let alert = UIAlertController(title: nil, message: "Please enter expiry date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(txtcvv.text == "")
        {
            let alert = UIAlertController(title: nil, message: "Please enter cvv", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else if(txtzipcode.text == "")
        {
            let alert = UIAlertController(title: nil, message: "Please enter zipcode", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(Int(lastName)! < 18)
        {
            let alert = UIAlertController(title: nil, message: "Please enter valid year", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
       else{
            
            
            WebServiceClass().showprogress()

        var card = self.txtCardNumber.text! as! String
        var str = card.replacingOccurrences(of: " ", with: "")
        var fullName: String = self.txtdate.text!
            let fullNameArr = fullName.components(separatedBy: "/")
        
            var firstName: String = fullNameArr[0]
            var lastName: String = fullNameArr[1]
        
            let year = "20" + lastName
        
        let expdate = firstName + "/" + year
        let fname:UInt? = UInt(firstName)
        let yr:UInt? = UInt(year)
       
        let cardParams = STPCardParams()
        cardParams.number = str
        cardParams.expMonth = fname!
        cardParams.expYear = yr!
        cardParams.cvc = txtcvv.text
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard var token = token, error == nil else {
                WebServiceClass().dismissprogress()

                let alert = UIAlertController(title: nil, message:"Your card number is Invalid", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            if error != nil {
                // Present error to user...
            }
            else {
            
                self.token1 = token
                
                print(token.tokenId)
                //self.validpayment(token: token)
                
                self.CreateUser(token: token.tokenId)
                // Continue with payment...
            }
            
        }
       

            
        }
  
    }
    func CreateUser(token:String){
        if AppDelegate.hasConnectivity() == true
        {
            let token1 = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token1]
          
            print(token)
            let params = [
                "user_token":token,
                "email":UserDefaults.standard.value(forKey:"email") as! String
                ] as [String : Any]
            Alamofire.request(WebServiceClass().BaseURL+"user/add/customer", method: .post, parameters:params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    if let data = response.result.value{
                      print(response.result.value!)
                        var dic = response.result.value as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber == 0)
                        {
                            
                            self.cust_id = dic.value(forKey: "data") as! String
                        
                            self.validpayment(cusid: self.cust_id)
                        }
                        else{
                            let alert = UIAlertController(title: nil, message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
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
    
    func validpayment(cusid:String){
        if AppDelegate.hasConnectivity() == true
        {
            WebServiceClass().showprogress()
            let token = UserDefaults.standard.value(forKey: "devicetoken") as! String
            let headers = ["Accept": "application/json","Authorization": "Bearer "+token]
            
            var card = self.txtCardNumber.text! as! String
                      var str = card.replacingOccurrences(of: " ", with: "")
                      var fullName: String = self.txtdate.text!
                    let fullNameArr = fullName.components(separatedBy: "/")
            
                        var firstName: String = fullNameArr[0]
                        var lastName: String = fullNameArr[1]
            
                       let year = "20" + lastName
            
                       let expdate = firstName + "/" + year
                      let params = [
                        "card_number":str,
                    "exp_month_year":expdate,
                    "card_token": cusid,
                    "cvv_number":self.txtcvv.text!,
                    "zipcode":self.txtzipcode.text!] as [String : Any]
            Alamofire.request(WebServiceClass().BaseURL+"user/update/card", method: .post, parameters:params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    WebServiceClass().dismissprogress()
                    if let data = response.result.value{
                   // print(response.result.value!)
                        var dic = response.result.value as! NSDictionary
                        
                        if(dic.value(forKey: "error_code") as! NSNumber == 0)
                        {
                           
                            let alert = UIAlertController(title: nil, message:
                                "Payment method added successfully", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (Greego) in
                                
                               self.navigationController?.popViewController(animated: true)
                               
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                            let alert = UIAlertController(title: nil, message:dic.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
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
    
    
    
}




