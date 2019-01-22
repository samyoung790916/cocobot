//
//  RegisterViewController.swift
//  cocobot
//
//  Created by samyoung79 on 21/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import AnimatedTextInput
import WebKit

class RegisterViewController: UIViewController,AnimatedTextInputDelegate{
    
    var wkWebView = WKWebView()
    lazy var bridgeManager = BridgeMgr(webView: wkWebView)
    
    var keyboardShown:Bool = false  // 키보드 상태 확인
    var originY:CGFloat?            // 오브젝트의 기본 위치
    var textFieldtag = 0
    
    var isCertiPhone:Bool = false{
        didSet{
            if isCertiPhone{
                self.phoneTextField.isEnabled = false
                self.certTextField.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var nameTextField:   AnimatedTextInput!
    @IBOutlet weak var phoneTextField:  AnimatedTextInput!
    @IBOutlet weak var certTextField:   AnimatedTextInput!
    @IBOutlet weak var pwCheckField:    AnimatedTextInput!
    @IBOutlet weak var pwTextField:     AnimatedTextInput!
    @IBOutlet weak var recTextField:    AnimatedTextInput!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var certBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.placeHolderText = "이름"
        nameTextField.style = CustomTextInputStyle()
        nameTextField.delegate = self
        nameTextField.tag = 0
        
        phoneTextField.placeHolderText = "핸드폰 번호"
        phoneTextField.type = .numeric
        phoneTextField.style = CustomTextInputStyle()
        phoneTextField.delegate = self
        phoneTextField.tag = 1
        
        certTextField.placeHolderText = "인증번호"
        certTextField.type = .numeric
        certTextField.style = CustomTextInputStyle()
        certTextField.delegate = self
        certTextField.tag = 2
        
        pwTextField.placeHolderText = "비밀번호"
        pwTextField.type = .password(toggleable: true)
        pwTextField.style = CustomTextInputStyle()
        pwTextField.delegate = self
        pwTextField.tag = 3
        
        pwCheckField.placeHolderText = "비밀번호 확인"
        pwCheckField.type = .password(toggleable: true)
        pwCheckField.style = CustomTextInputStyle()
        pwCheckField.delegate = self
        pwTextField.tag = 4
        
        recTextField.placeHolderText = "추천인 핸드폰 번호"
        recTextField.type = .numeric
        recTextField.style = CustomTextInputStyle()
        recTextField.delegate = self
        recTextField.tag = 5
        
        doneBtn.backgroundColor = UIColor(hex: "#D8F900")
        certBtn.setImage(UIImage(named: "auth_btn"), for: .normal)
        
        
        self.registerForKeyboardNotifications()
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        self.scrollview.addGestureRecognizer(singleTapGestureRecognizer)
        
        addBrideges()
        self.view.addSubview(wkWebView)
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        wkWebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
    
    }
    
    
    func addBrideges(){
        bridgeManager.addBridge("coinid") {(info) in
            
            let privateKey = info["id"]
        }
        
        bridgeManager.addBridge("finish") { (info) in
            self.wkWebView.evaluateJavaScript("call_register()", completionHandler: nil)
        }
        
    }
    
    @objc func screenTapped(sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
        
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasDismissed(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height == 0.0 || keyboardShown == true || self.textFieldtag < 3{
                return
            }
            UIView.animate(withDuration: 0.33, animations: {
                if self.originY == nil {
                    self.originY = self.view.frame.origin.y
                }
                self.view.frame.origin.y = self.originY! - keyboardSize.height
            }) { (Bool) in
                self.keyboardShown = true
            }
        }
    }
    
    @objc func keyboardWasDismissed(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardShown == false {
                return
            }
            
            UIView.animate(withDuration: 0.33, animations: {
                guard let originY = self.originY else {return}
                self.view.frame.origin.y = originY
            }) { (Bool) in
                self.keyboardShown = false
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
    
    func animatedTextInputShouldReturn(animatedTextInput: AnimatedTextInput) -> Bool {
        return true
    }
    
    func animatedTextInputShouldBeginEditing(animatedTextInput: AnimatedTextInput) -> Bool {
        textFieldtag = animatedTextInput.tag
        return true
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
    
    @IBAction func JoinRequest(_ sender: Any) {
        
        
        wkWebView.evaluateJavaScript("call_register()") { (result, error) in
            if result != nil{
                
            }else{
                
            }
        }
        
//        var arry = [
//            "USER_ROLE" : "1",
//            "USER_PW" : "1",
//            "USER_NAME" : "1",
//            "USER_TEL" : "1",
//            "USER_ROLE" : "1",
//        ]
        
        
        
    }
}


struct CustomTextInputStyle: AnimatedTextInputStyle {
    
    let placeholderInactiveColor = UIColor.gray
    let activeColor = UIColor.gray
    let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineActiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineHeight: CGFloat = 1
    let errorColor = UIColor.red
    let textInputFont = UIFont.systemFont(ofSize: 20)
    let textInputFontColor = UIColor.black
    let placeholderMinFontSize: CGFloat = 16
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 12)
    let leftMargin: CGFloat = 20
    let topMargin: CGFloat = 40
    let rightMargin: CGFloat = 20
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
    let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String: Any]? = nil
}




