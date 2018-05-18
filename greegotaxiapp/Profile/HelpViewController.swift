//
//  HelpViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 4/9/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    
    @IBOutlet weak var Helpwebview: WKWebView!
    
    @IBOutlet weak var sidemenubtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
sidemenubtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        let url = NSURL (string: "https://www.google.co.in")
        let requestObj = URLRequest(url: url! as URL)
        Helpwebview.load(requestObj)
        
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
