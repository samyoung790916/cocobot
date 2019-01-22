//
//  ViewController.swift
//  cocobot
//
//  Created by samyoung79 on 08/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func press(_ sender: UIButton) {
        
        performSegue(withIdentifier: "SegueId", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
