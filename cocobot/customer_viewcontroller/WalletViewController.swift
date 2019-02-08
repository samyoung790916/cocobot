//
//  WalletViewController.swift
//  cocobot
//
//  Created by samyoung79 on 17/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    var strbalance:String = ""
    
    @IBOutlet weak var coinLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "내 지갑"
        
        
        let imageAttatchment = NSTextAttachment()
        imageAttatchment.image = UIImage(named: "c_icon")

        let imageOffsetY:CGFloat = -5.0
        imageAttatchment.bounds = CGRect(x: 0, y: imageOffsetY, width: ((imageAttatchment.image?.size.width)! / 2), height: ((imageAttatchment.image?.size.height)! / 2))

        let attachmentString = NSAttributedString(attachment: imageAttatchment)
        let completeText = NSMutableAttributedString(string: "")

        completeText.append(attachmentString)
        let textAfterIcon =  NSMutableAttributedString(string: "  " + strbalance)
        completeText.append(textAfterIcon)

        coinLabel.attributedText = completeText
       

        // Do any additional setup after loading the view.
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
