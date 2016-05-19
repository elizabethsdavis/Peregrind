//
//  PeregrindTabBarController.swift
//  Netwerk
//
//  Created by Juliana Cook on 4/28/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class PeregrindTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        Flurry.logAllPageViewsForTarget(self)
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("tab bar controller did select view controller")
        print(viewController)
        
        if let cameraViewController = viewController as? kakCameraViewController {
            print("tab bar selected camera")
            cameraViewController.displayCamera()
        }
        
    }
    
}