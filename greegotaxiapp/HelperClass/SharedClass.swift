//
//  SharedClass.swift
//  greegotaxiapp
//
//  Created by mac on 07/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit

class SharedClass: NSObject
{
    
    
    static let instance = SharedClass()
    
    func testClass()
    {
        NSLog("Shared Class is Working fine")
    }
    

}
