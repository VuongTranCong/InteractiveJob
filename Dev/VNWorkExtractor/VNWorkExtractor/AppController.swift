//
//  AppController.swift
//  JobOnDemand
//
//  Created by VuongTC on 5/19/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class AppController: NSObject {
    static var instance: AppController?
    
     static func sharedInstance() -> AppController {
        if (instance == nil) {
            instance = AppController();
        }
        return instance!;
    }
    
    var companys = [Company]()
    
    
}