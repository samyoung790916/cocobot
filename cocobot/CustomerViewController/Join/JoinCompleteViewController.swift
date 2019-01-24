//
//  JoinCompleteViewController.swift
//  cocobot
//
//  Created by samyoung79 on 24/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class JoinCompleteViewController: UIViewController {
    
    var phoneNumber:String?
    var privatekey:String?
    
    @IBOutlet weak var join_complete_label: UILabel!
    @IBOutlet weak var join_info_label: UILabel!
    
    @IBOutlet weak var join_please_label: UILabel!
    
    @IBOutlet weak var join_sub_label1: UILabel!
    @IBOutlet weak var join_sub_label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let main_string = "가입이 완료되었습니다."
        let range = (main_string as NSString).range(of: "완료")
        let font = UIFont(name:"Apple Color Emoji" , size: 25)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: font as Any, range: range)
        
        join_complete_label.attributedText = attribute
        

        let info_string = "주의!\n\n블록체인 PrivateKey가 생성되었습니다.\n암호화폐 특성상 Private Key는 서버에 저장되지\n않습니다. 따라서 핸드폰 기기변경, 앱 제거등의 사유로\nPrivate Key를 분실하시는 경우, 모든 암호화폐를 사용하실 수 없습니다."
        
        let range1 = (info_string as NSString).range(of: "주의!")
     
        let font1 = UIFont(name:"NotoSansCJKkr-Regular" , size: 20)

        let attribute1 = NSMutableAttributedString.init(string: info_string)
        attribute1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
        attribute1.addAttribute(NSAttributedString.Key.font, value: font1 as Any, range: range1)
        
        
        join_please_label.text = "꼭 다른 곳에 백업해 주세요"
        
        join_info_label.numberOfLines = 0
        join_info_label.attributedText = attribute1
        
        
        let sub_string_1 = "* 개인이 관리하기 어려운 경우 코코 서버에\n보관하실 수 있습니다."
        let sub_range1 = (sub_string_1 as NSString).range(of:"*")
        let sub_font1 = UIFont(name:"NotoSansCJKkr-Regular" , size: 15)
        let sub_attribute1 = NSMutableAttributedString.init(string: sub_string_1)
        sub_attribute1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: sub_range1)
        sub_attribute1.addAttribute(NSAttributedString.Key.font, value: sub_font1 as Any, range: sub_range1)
        
        join_sub_label1.numberOfLines = 0
        join_sub_label1.attributedText = sub_attribute1

        let sub_string_2 = "* 마이페이지에서 언제든지 코코서버에\n저장하실 수 있습니다."
        let sub_range2 = (sub_string_2 as NSString).range(of:"*")
        let sub_font2 = UIFont(name:"NotoSansCJKkr-Regular" , size: 15)
        let sub_attribute2 = NSMutableAttributedString.init(string: sub_string_2)
        sub_attribute2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: sub_range2)
        sub_attribute2.addAttribute(NSAttributedString.Key.font, value: sub_font2 as Any, range: sub_range2)
        
        join_sub_label2.numberOfLines = 0
        join_sub_label2.attributedText = sub_attribute2

    }
    
    @IBAction func SendKeyAction(_ sender: UIButton) {
        let array = [
            "USER_TEL" : self.phoneNumber as Any,
            "USER_COINID": self.privatekey as Any
            ] as [String : Any]
        
        APIService.shared.post(url: "/save_privatekey", string: array.json()) { (result, resultDict) in
            
            let status_code = resultDict["status_code"] as! Int
            
            if status_code == 0 || status_code == 1{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "서버에 저장되었습니다.") { (index, title) in
                    
                    RegisterViewController.bHome = true
                    self.dismiss(animated: false, completion:nil)
                    
                    

                    
                    //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

//
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
                    
                }
            }
        }
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
