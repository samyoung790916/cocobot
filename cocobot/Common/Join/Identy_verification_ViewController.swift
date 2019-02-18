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
    
    
    var bSnsCondition = false
    
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:  UIFont(name:"NotoSansCJKkr-Regular" , size: 18)!]

        phoneTextField.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 18)
        phoneTextField.placeHolderText = "핸드폰 번호"
        phoneTextField.type = .numeric
        phoneTextField.style = CustomTextInputStyle()
        phoneTextField.delegate = self
        phoneTextField.tag = 0
        
        certiTextField.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 18)
        certiTextField.placeHolderText = "인증번호"
        certiTextField.type = .numeric
        certiTextField.style = CustomTextInputStyle()
        certiTextField.delegate = self
        certiTextField.tag = 1
        
        doneBtn.backgroundColor = UIColor(hex: "#D8F900")
        certBtn.setImage(UIImage(named: "auth_btn"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
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
                //self.requestCertiPhonNumber()
                if bSnsCondition == false{
                    self.requestCertiPhonNumber()   // 조인
                }else{
                    self.requestSnSCertiPhonNumber()   // sns 계정 통합

                }
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
    
    private func requestSnSCertiPhonNumber(){ // 문자인증
        let array = ["USER_TEL" : self.phoneTextField.text?.replace(of: "-", with: "")]
        APIService.shared.post(url: "/send_cellphone_confirm/sns_confirm", string: array.json()) { (result, resultDict) in
            
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
        
        if bSnsCondition == true{
            let array = [
                "USER_TEL": self.phoneTextField.text?.replace(of: "-", with: "") as Any,
                "CONFIRM_NO": self.certiTextField.text as Any,
                ] as [String : Any]
            
            APIService.shared.post(url: "/cellphone_confirm/sns_confirm", string: array.json()) { (result, resultDict) in
                
                if resultDict["status_code"] as! NSNumber == 0{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "신규회원 인증 완료.") { (index, title) in
                        self.performSegue(withIdentifier: "RegiShow", sender: self)
                    }
                }
                else if resultDict["status_code"] as! NSNumber == 1005{
                    AJAlertController.initialization().showAlert(aStrMessage: "기존 가입이 존재합니다. 아이디를 통합 하시겠습니까?", aCancelBtnTitle: "네", aOtherBtnTitle: "아니요") { (index, string) in
                        if index == 0{
                            //self.performSegue(withIdentifier: "RegiShow", sender: self)
                            
                            // 인증 번호 인증후 1005 통합하겠다는 확인 누를시
                            // 2-1. 호출 URL - /integration_user
                            /*
                             2-2. 요청 파라미터 – USER_TEL : 입력 전화번호 (BASE64 인코딩)
                             USER_ROLE : 현재 로그인 중인 SNS회원 ROLE - 5 또는 6
                             USER_SNS : SNS 고유 ID 값
                             SNS_SORT : 가입 된 SNS 종류 - kakao 또는 facebook 으로 전달 // 소문자 kakao , facebook
                            */
                            /*
                             2-3. response – status_code : 0 Success – 통합완료
                             status_code : 1006 No Pw User – 통합완료 But 비밀번호 입력 필요 -> API문서 /change_pw 사용하여 비밀번호 입력
                             status_code : -1 Error – 에러
                            */
                        }
                    }
                }
                else if resultDict["status_code"] as! NSNumber == 1000{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "인증번호가 일치하지 않습니다.") { (index, title) in
                    }
                }
            }
            
            
        }
        else{
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegiShow"{
            if #available(iOS 10.0, *) {
                if let destinationVC = segue.destination as? RegisterViewController {
                    destinationVC.phoneNumber = self.phoneTextField.text
                    destinationVC.bSnsJoin = self.bSnsCondition
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }

}
