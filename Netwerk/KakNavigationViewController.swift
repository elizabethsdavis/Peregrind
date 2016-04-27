//
//  KakNavigationViewController.swift
//  Netwerk
//
//  Created by Elizabeth Davis on 4/27/16.
//  Copyright © 2016 Elizabeth Davis. All rights reserved.
//

import UIKit

class KakNavigationViewController: UINavigationController {

    @IBOutlet weak var kakNavigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "Perigrind Logo")
        
        kakNavigationBar.backItem?.titleView = UIImageView(image: image)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
