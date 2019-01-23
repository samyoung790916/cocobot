//
//  Identy_verification_ViewController.swift
//  cocobot
//
//  Created by samyoung79 on 23/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import AnimatedTextInput

class Identy_verification_ViewController: UIViewController,AnimatedTextInputDelegate {

    @IBOutlet weak var certiTextField: AnimatedTextInput!
    @IBOutlet weak var phoneTextField: AnimatedTextInput!
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var certBtn: UIButton!
    
    var isCertiPhone:Bool = false{
        didSet{
            if isCertiPhone{
                self.phoneTextField.isEnabled = false
                self.certiTextField.isEnabled = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "본인 인증"
        
        phoneTextField.placeHolderText = "핸드폰 번호"
        phoneTextField.type = .numeric
        phoneTextField.style = CustomTextInputStyle()
        phoneTextField.delegate = self
        phoneTextField.tag = 0
        
        certiTextField.placeHolderText = "인증번호"
        certiTextField.type = .numeric
        certiTextField.style = CustomTextInputStyle()
        certiTextField.delegate = self
        certiTextField.tag = 1
        
        doneBtn.backgroundColor = UIColor(hex: "#D8F900")
        certBtn.setImage(UIImage(named: "auth_btn"), for: .normal)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func CertiRequest(_ sender: UIButton) {
        guard isCertiPhone == false else{ // 이미 인증 완료
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "이미 핸드폰 번호 인증을 완료했습니다.") { (index, title) in
                print(index,title)
            }
            return
        }
        
        ValidationMgr.shared.validate(.phone(number: self.phoneTextField.text!)) { (result) in
            switch result{
            case .success(let phoneNumber):
                self.phoneTextField.text = phoneNumber?.withHypen
                self.requestCertiPhonNumber()
            case .failure(_):
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "올바른 핸드폰 번호를 입력해주세요") { (index, title) in
                    print(index,title)
                }
                return
            }
        }
    }
    
    private func requestCertiPhonNumber(){ // 문자인증
        let array = ["USER_TEL" : self.phoneTextField.text?.replace(of: "-", with: "")]
        APIService.shared.post(url: "send_cellphone_confirm/join", string: array.json()) { (result, resultDict) in
            
            if result == .success{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "인증번호를 전송하였습니다.") { (index, title) in
                }
            }else{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "인증번호를 전송이 실패하였습니다. 잠시후 다시 시도해 주세요") { (index, title) in
                }
            }
        }
    }
    
    
    @IBAction func CertiPhoneRequest(_ sender: UIButton) {

        if isCertiPhone == false{
            let array = [
                "USER_TEL": self.phoneTextField.text?.replace(of: "-", with: "") as Any,
                "CONFIRM_NO": self.certiTextField.text as Any,
                "USER_ROLE" : "1"
                ] as [String : Any]
            
            APIService.shared.post(url: "cellphone_confirm/join", string: array.json()) { (result, resultDict) in
                
                
                if resultDict["status_code"] as! NSNumber == 1  || resultDict["status_code"] as! NSNumber == 0{ //신규회원 가입
                    self.isCertiPhone = true
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "인증 성공하였습니다.") { (index, title) in
                        self.performSegue(withIdentifier: "RegiShow", sender: self)
                    }
                }else{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: resultDict["message"] as! String) { (index, title) in}
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegiShow"{
            if let destinationVC = segue.destination as? RegisterViewController {
                destinationVC.phoneNumber = self.phoneTextField.text
            }
        }
        
    }

}
