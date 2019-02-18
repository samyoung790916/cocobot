//
//  RegisterViewController.swift
//  cocobot
//
//  Created by samyoung79 on 21/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//
//
import UIKit
import AnimatedTextInput
import WebKit

@available(iOS 10.0, *)
@available(iOS 10.0, *)
class RegisterViewController: UIViewController,AnimatedTextInputDelegate{

    var wkWebView = WKWebView()
    var walletInfoDict = [String:String]()
    lazy var bridgeManager = BridgeMgr(webView: wkWebView)

    var keyboardShown:Bool = false  // 키보드 상태 확인
    var originY:CGFloat?            // 오브젝트의 기본 위치
    var textFieldtag = 0
    var phoneNumber:String?
    
    static var bHome = false
    var bSnsJoin = false

    @IBOutlet weak var nameTextField:   AnimatedTextInput!
    @IBOutlet weak var pwCheckField:    AnimatedTextInput!
    @IBOutlet weak var pwTextField:     AnimatedTextInput!
    @IBOutlet weak var recTextField:    AnimatedTextInput!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if RegisterViewController.bHome == true{
            RegisterViewController.bHome = false
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.placeHolderText = "이름"
        nameTextField.style = CustomTextInputStyle()
        nameTextField.delegate = self
        nameTextField.tag = 0

        pwTextField.placeHolderText = "비밀번호"
        pwTextField.type = .password(toggleable: true)
        pwTextField.style = CustomTextInputStyle()
        pwTextField.delegate = self
        pwTextField.tag = 1

        pwCheckField.placeHolderText = "비밀번호 확인"
        pwCheckField.type = .password(toggleable: true)
        pwCheckField.style = CustomTextInputStyle()
        pwCheckField.delegate = self
        pwTextField.tag = 2

        recTextField.placeHolderText = "추천인 핸드폰 번호"
        recTextField.type = .numeric
        recTextField.style = CustomTextInputStyle()
        recTextField.delegate = self
        recTextField.tag = 3

        doneBtn.backgroundColor = UIColor(hex: "#D8F900")


        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false

        addBrideges()
        self.view.addSubview(wkWebView)

        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        wkWebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
    }

    func addBrideges(){
        bridgeManager.addBridge("coinid") {(info) in
           self.walletInfoDict = info as! [String : String]
        }
        bridgeManager.addBridge("finish") { (info) in
            print("call_register()")
            self.wkWebView.evaluateJavaScript("call_register()", completionHandler: nil)
        }
    }

    @objc func screenTapped(sender: UITapGestureRecognizer) {
         self.view.endEditing(true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

//    func registerForKeyboardNotifications(){
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasDismissed(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }

//    @objc func keyboardNotification(notification: NSNotification){
//
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if keyboardSize.height == 0.0 || keyboardShown == true || self.textFieldtag < 3{
//                return
//            }
//            UIView.animate(withDuration: 0.33, animations: {
//                if self.originY == nil {
//                    self.originY = self.view.frame.origin.y
//                }
//                self.view.frame.origin.y = self.originY! - keyboardSize.height
//            }) { (Bool) in
//                self.keyboardShown = true
//            }
//        }
//    }

//    @objc func keyboardWasDismissed(notification: NSNotification){
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if keyboardShown == false {
//                return
//            }
//
//            UIView.animate(withDuration: 0.33, animations: {
//                guard let originY = self.originY else {return}
//                self.view.frame.origin.y = originY
//            }) { (Bool) in
//                self.keyboardShown = false
//            }
//        }
//    }


//    func animatedTextInputShouldReturn(animatedTextInput: AnimatedTextInput) -> Bool {
//        return true
//    }
//
//    func animatedTextInputShouldBeginEditing(animatedTextInput: AnimatedTextInput) -> Bool {
//        textFieldtag = animatedTextInput.tag
//        return true
//    }



    @IBAction func JoinRequest(_ sender: Any) {

        if nameTextField.text == ""{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "이름을 입력해 주세요") { (index, title) in}
            return
        }else if pwTextField.text == ""{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "비밀번호를 입력해 주세요") { (index, title) in}
            return
        }else if pwCheckField.text == ""{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "비밀번호 확인을 입력해 주세요") { (index, title) in}
            return
        }
        
        self.reuquestUserJoin()
    }

    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func reuquestUserJoin(){
        var array = [
            "USER_ROLE" : "1",
            "USER_PW" : self.pwCheckField.text?.base64() as Any,
            "USER_NAME" : self.nameTextField.text as Any,
            "USER_TEL" : self.phoneNumber?.replace(of: "-", with: "").base64() as Any,
            "USER_COINID": self.walletInfoDict["key"] as Any
        ] as [String : Any]
        
        if recTextField.text != ""{
            array["RECOMMENDER"] = self.recTextField.text?.base64()
        }
        
        if bSnsJoin == false{
            APIService.shared.post(url: "join", string: array.json()) { (result, resultDict) in
                
                let status_code = resultDict["status_code"] as! Int
                
                if status_code == 0 || status_code == 1{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "가입에 성공하였습니다.") { (index, title) in
                         self.performSegue(withIdentifier: "ModalSegue", sender: self)
                    }
                }else if status_code == 1000{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: resultDict["message"] as! String) { (index, title) in}
                }
            }
        }else{
            
            var sns_kind = ""
            var sns_id = ""
            let app_delegate = UIApplication.shared.delegate as! AppDelegate
            
            if app_delegate.MainViewController?.user_login_info.kakaoLogin == true{
                sns_kind = "kakao"
            }else if app_delegate.MainViewController?.user_login_info.facebookLogin == true{
                sns_kind = "facebook"
            }
            
            sns_id = (app_delegate.MainViewController?.user_login_info.sns_id)!
            
            
            
            
            array.updateValue(sns_id, forKey: "USER_SNS")
            array.updateValue(sns_kind, forKey: "SNS_SORT")
            array.updateValue("5", forKey: "USER_ROLE")
            
            
            
            // sns join할때
            APIService.shared.post(url: "/update_snsUsers", string: array.json()) { (result, resultDict) in
                let status_code = resultDict["status_code"] as! Int
                
                if status_code == 0 || status_code == 1{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "가입에 성공하였습니다.") { (index, title) in
                        self.performSegue(withIdentifier: "ModalSegue", sender: self)
                    }
                }else{
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: resultDict["message"] as! String) { (index, title) in}
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalSegue"{
            if let destinationVC = segue.destination as? JoinCompleteViewController {
                destinationVC.phoneNumber = self.phoneNumber?.replace(of: "-", with: "").base64()
                destinationVC.privatekey = self.walletInfoDict["key"]
                
            }
        }
        
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
