//
//  JoinAssocicateViewController.swift
//  cocobot
//
//  Created by samyoung79 on 28/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class JoinAssocicateViewController: UIViewController {

    @IBOutlet weak var JoinCompleteLabel: UILabel!
    @IBOutlet weak var Ment1Label: UILabel!
    @IBOutlet weak var HomeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let complete_message_string = "가입이 완료되었습니다."
        let complete_range = (complete_message_string as NSString).range(of: "완료")
        let font = UIFont(name:"NotoSansCJKkr-Regular" , size: 22)
        let attributeText = NSMutableAttributedString.init(string: complete_message_string)
        attributeText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: complete_range)
        attributeText.addAttribute(NSAttributedString.Key.font, value: font as Any, range: complete_range)
        
        JoinCompleteLabel.attributedText = attributeText
        
        
        let info_string = "주의!\n\n* 회원가입 완료 되었습니다.\n* 좀 더 다양한 기능의 사용을 원하시면 본인확인\n 을 진행해 주세요."
        
        let range = (info_string as NSString).range(of: "주의!")
        
        let attribute = NSMutableAttributedString.init(string: info_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: font as Any, range: range)
        
        Ment1Label.attributedText = attribute
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func HomeMoveAction(_ sender: UIButton) {
        JoinViewController.bHome = true
         self.dismiss(animated: false, completion:nil)
    }

}
