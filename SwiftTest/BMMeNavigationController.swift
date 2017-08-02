//
//  BMMeNavigationController.swift
//  SwiftTest
//
//  Created by 张琳 on 2017/7/28.
//  Copyright © 2017年 张琳. All rights reserved.
//

import UIKit

class BMMeNavigationController: BMBaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        let vc:BMMyViewController = BMMyViewController(nibName: "BMMyViewController", bundle: nil)
        self.pushViewController(vc, animated: true)

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
