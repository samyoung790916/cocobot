//
//  LoginViewController.swift
//  cocobot
//
//  Created by samyoung79 on 08/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import SnapKit
import AnimatedTextInput
import FullMaterialLoader


import FacebookLogin
import FacebookCore
import KakaoOpenSDK

import WebKit





class LoginViewController: UIViewController {
    
    //MARK: Data member variable
    var coin_id = ""
    static var isLogin = false
    
    var wkWebView = WKWebView()
    lazy var bridgeManager = BridgeMgr(webView: wkWebView)
    var walletInfoDict =  [String:String]()
  
    
    
    //MARK: UI member variable
    let logoImage: UIImageView = UIImageView()
    
    let phoneLabel: CustomLabel = CustomLabel()
    let phoneTextField: CustomTextField = CustomTextField()
    
    let passwordLabel: CustomLabel = CustomLabel()
    let passwordTextField: CustomTextField = CustomTextField()
    
    let loginButton: UIButton = UIButton()
    let findPwButton: UIButton = UIButton()
    let facebookButton: UIButton = UIButton()
    let kakaoButton: UIButton = UIButton()
    let joinButton: UIButton = UIButton()
    let autoLoginBtn: UIButton = UIButton()
    
    let snsLoginLabel: UILabel = UILabel()
    let autoLoginLabel: UILabel = UILabel()
    
    
    var indicator: MaterialLoadingIndicator!
    
    
    var isCompletePassword : Bool{
        return (self.passwordTextField.text!.count >= 6 && self.passwordTextField.text!.count < 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicator = MaterialLoadingIndicator(frame: CGRect(x:0, y:0, width: 30, height: 30))
        indicator.indicatorColor = [UIColor.red.cgColor, UIColor.blue.cgColor]
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        setupUI()
        setupLayOut()
        setupEventSelector()
        hideKeyboardWhenTappedAround()
        
        
        
        

    }

    @objc func loginBtnEvent(_ sender : UIButton) {
        
        guard self.phoneTextField.hasText else{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "핸드폰 번호를 입력하세요") { (index, title) in
                print(index,title)
            }
            return
        }
        
        guard isCompletePassword else {
            
            if self.passwordTextField.text!.count == 0{
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "비밀번호를 입력하세요") { (index, title) in
                    print(index,title)
                }
            }
            
            if self.passwordTextField.text!.count < 6 {
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "비밀번호가 6자리 이상이거나 16자리 이하이어야 합니다.") { (index, title) in
                    print(index,title)
                }
                
            }
            return
        }
        
        let array = [
            "USER_TEL" : self.phoneTextField.text?.base64(),
            "USER_PW" : self.passwordTextField.text?.base64()
        ]
        
        APIService.shared.post(url: "login", string: array.json()) { (result, resultDict) in
    
            if result == .success{
                UserDefaults.standard.set(resultDict["userRole"], forKey: "userRole")
                
                LoginViewController.isLogin = true
                let app_delegate = UIApplication.shared.delegate as! AppDelegate
                app_delegate.MainViewController?.user_login_info.coinid       = resultDict["coinid"] as? String
                app_delegate.MainViewController?.user_login_info.accessToken  = resultDict["accessToken"] as? String
                app_delegate.MainViewController?.user_login_info.coin_pw     = resultDict["coinpw"] as? String
                app_delegate.MainViewController?.user_login_info.user_tel     = resultDict["userTel"] as? String
                app_delegate.MainViewController?.user_login_info.user_name    = resultDict["username"] as? String
                app_delegate.MainViewController?.user_login_info.cvid         = resultDict["cvid"] as? String
                app_delegate.MainViewController?.user_login_info.status_code  = resultDict["status_code"] as? String
                app_delegate.MainViewController?.user_login_info.status       = resultDict["status"] as? String

                app_delegate.MainViewController?.user_login_info.firstLogin   = (resultDict["firstLogin"] as! NSString).integerValue
                app_delegate.MainViewController?.user_login_info.user_role    = (resultDict["userRole"] as! NSString).integerValue

                app_delegate.MainViewController?.user_login_info.recommender_cnt  = resultDict["recommenderCnt"] as! Int
                app_delegate.MainViewController?.user_login_info.marketInfos      = resultDict["marketInfos"] as! Int

                if (app_delegate.MainViewController?.user_login_info.recommender_cnt)! >= 1{

                    if let jsonArr = resultDict["recommenderInfo"] as? [[String:Any]]{
                        for index in 0 ..< jsonArr.count{
                            let dict = jsonArr[index]
                            app_delegate.MainViewController?.user_login_info.recommenderInfo.append(dict)
                        }
                    }
                }
                
                if app_delegate.MainViewController?.user_login_info.user_role == 2 ||
                   app_delegate.MainViewController?.user_login_info.user_role == 1{
                    
                    self.addBrideges()

                    self.view.addSubview(self.wkWebView)
                    let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
                    let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
                    self.wkWebView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
    
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
            else{
                LoginViewController.isLogin = false
                
                let status = resultDict["status_code"] as! Int
                if status == 1000{
                    let message = resultDict["message"] as! String
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, completion: { (index, title) in
                    })
                }
            }
        }
        
    }
    
    func addBrideges(){
        let app_delegate = UIApplication.shared.delegate as! AppDelegate
        
        bridgeManager.addBridge("currency") {(info) in
            self.walletInfoDict = info as! [String : String]
            app_delegate.MainViewController?.user_login_info.coin_total = info["total"] as! String
            self.navigationController?.popViewController(animated: true)
        }
        bridgeManager.addBridge("finish") { (info) in
            let coin_id = app_delegate.MainViewController?.user_login_info.coinid
            self.wkWebView.evaluateJavaScript("call_log('\(coin_id!)')", completionHandler: nil)
        }
    }
    
    
    @objc func autoLoginEvent(_ sender : UIButton) {
        print("autoLoginEvent")
    }
    @objc func facebookEvent(_ sender : UIButton) {
        print("facebookEvent")
        
        let loginMgr = LoginManager()
        loginMgr.logIn(readPermissions:[.publicProfile], viewController: self) { (result) in
            
            switch result{
            case .failed(let error):
                AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "페이스북 서버에서 로그인이 실패했습니다.\n에러메세지:\(error.localizedDescription)") { (index, title) in}
                
            case .cancelled:
                print("User canceled login.")
            case .success(grantedPermissions: let grantedPermission, declinedPermissions: let declinedPermissions, token: let accessToken):
                print("페이스북 조인 옵션 뷰")
                print("grantedPermission:", grantedPermission)
                print("declinedPermissions:", declinedPermissions)
                
                
                if let id = accessToken.userId{
                    
                     let array = ["USER_FACEBOOK" : id]
                    APIService.shared.post(url: "sns_login/facebook", string: array.json(), resultCompletion: { (result, resultDict) in
                        
                        if result == .success{
                            LoginViewController.isLogin = true
                            let app_delegate = UIApplication.shared.delegate as! AppDelegate
                            app_delegate.MainViewController?.user_login_info.accessToken = resultDict["accessToken"] as? String
                            app_delegate.MainViewController?.user_login_info.firstLogin = (resultDict["firstLogin"] as! NSString).integerValue
                            app_delegate.MainViewController?.user_login_info.user_role = (resultDict["userRole"] as! NSString).integerValue
                            app_delegate.MainViewController?.user_login_info.recommender_cnt = resultDict["recommenderCnt"] as! Int
                            app_delegate.MainViewController?.user_login_info.facebookLogin = true  // 페이스북 로그인시 "페이스북 준회원"이라고 표기하기 위한 플래그
                            
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: resultDict["message"] as! String) { (index, title) in}
                        }
                    })
                }
                
            }
        }
    }
    @objc func kakaoEvent(_ sender : UIButton) {
        print("kakaoEvent")
        
        let session :KOSession = KOSession.shared()
        
        if session.isOpen() {
            session.close()
            
        }
        session.presentingViewController = self
        session.open { (error) in
            if error == nil
            {
                if session.isOpen()
                {
                    KOSessionTask.userMeTask(completion: { (error, me) in
                        if let me = me as KOUserMe?
                        {
                            let array = ["USER_KAKAO" : me.id]
                            APIService.shared.post(url: "sns_login/kakao", string: array.json()){[weak self] (result, resultDict) in
                                if result == .success {
                                    LoginViewController.isLogin = true
                                    
                                    let app_delegate = UIApplication.shared.delegate as! AppDelegate
                                    app_delegate.MainViewController?.user_login_info.accessToken = resultDict["accessToken"] as? String
                                    app_delegate.MainViewController?.user_login_info.firstLogin = (resultDict["firstLogin"] as! NSString).integerValue
                                    app_delegate.MainViewController?.user_login_info.user_role = (resultDict["userRole"] as! NSString).integerValue
                                    app_delegate.MainViewController?.user_login_info.recommender_cnt = resultDict["recommenderCnt"] as! Int
                                    app_delegate.MainViewController?.user_login_info.kakaoLogin = true  // 카카오 로그인시 "카카오 준회원"이라고 표기하기 위한 플래그
                                    
                                    
                                    self!.navigationController?.popViewController(animated: true)
                                    
                                    print("카카오톡 로그인")
                                }
                                else {
                                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: resultDict["message"] as! String) { (index, title) in}
                                }
                            }
                        }
                    })
                }else{
                    print("카카오톡 열기 실패")
                }
            }
        }
    }
    @objc func findPwEvent(_ sender : UIButton) {
        print("findPwEvnet")
    }
    @objc func joinEvent(_ sender : UIButton) {
        print("joinEvnet")
        performSegue(withIdentifier: "JoinSegue", sender: self)
    }
    
}

extension LoginViewController{
    
    func setupUI(){
        
        logoImage.image = UIImage(named: "logo")
        
        phoneLabel.text = "핸드폰 번호"
        phoneLabel.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        
        phoneTextField.keyboardType = .phonePad
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "PHONE NUMBER",
                                                                  attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                               NSAttributedString.Key.foregroundColor : UIColor(hex : "#555555")])
        
        passwordLabel.text = "비밀 번호"
        passwordLabel.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                                     attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                                  NSAttributedString.Key.foregroundColor : UIColor(hex : "#555555")])
        
        loginButton.setImage(UIImage(named: "login_btn"), for: .normal)
        
        findPwButton.setTitle("비밀번호 찾기", for: .normal)
        findPwButton.setTitleColor(UIColor(hex: "#e4e4e4"), for: .normal)
        findPwButton.titleLabel?.font =  UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        
        facebookButton.setImage(UIImage(named: "facebook"), for: .normal)
        kakaoButton.setImage(UIImage(named: "kakao"), for: .normal)
        
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.setTitleColor(UIColor(hex: "#d8f900"), for: .normal)
        joinButton.titleLabel?.font =  UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        
        snsLoginLabel.font =  UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        snsLoginLabel.textColor = UIColor(hex : "#ffffff")
        snsLoginLabel.text = "SNS로 로그인"
        
        autoLoginLabel.font =  UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        autoLoginLabel.textColor = UIColor(hex: "#ffffff")
        autoLoginLabel.text = "자동 로그인"
        
        autoLoginBtn.setImage(UIImage(named: "auto_off_btn"), for: .normal)
    }
    
    func setupLayOut(){
        
        let screenRect : CGRect = UIScreen.main.bounds
        var nNavigationHeight = 0
        
        if screenRect.size.height >= 812{
            nNavigationHeight = 88
        }else{
            nNavigationHeight = 64
        }
        
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 10
        contentStackView.addBackground(color: UIColor(hex: "#1a1a1a"))
        
        let phoneStackView = UIStackView(arrangedSubviews: [phoneLabel,phoneTextField])
        phoneStackView.axis = .vertical
        phoneStackView.alignment = .fill
        phoneStackView.distribution = .fillEqually
        phoneStackView.spacing = 9
        
        let pwStackView = UIStackView(arrangedSubviews: [passwordLabel,passwordTextField])
        pwStackView.axis = .vertical
        pwStackView.alignment = .fill
        pwStackView.distribution = .fillEqually
        pwStackView.spacing = 9
        
        
        contentStackView.addSubview(logoImage)          // 이미지 로고
        contentStackView.addSubview(phoneStackView)     // 폰 번호, 텍스트 필드
        contentStackView.addSubview(pwStackView)        // 비번, 텍스트 필드
        contentStackView.addSubview(loginButton)        // 로그인 버튼
        contentStackView.addSubview(findPwButton)       // 비밀번호 찾기
        contentStackView.addSubview(facebookButton)     // facebook
        contentStackView.addSubview(kakaoButton)        // 카카오
        contentStackView.addSubview(joinButton)         // 회원가입
        contentStackView.addSubview(snsLoginLabel)      // SNS로 로그인
        contentStackView.addSubview(autoLoginLabel)     // 자동 로그인 라벨
        contentStackView.addSubview(autoLoginBtn)       // 자동 로그인 버튼
        
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.addArrangedSubview(phoneTextField)
        pwStackView.addArrangedSubview(passwordLabel)
        pwStackView.addArrangedSubview(passwordTextField)
        
        
        self.view.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { (make) in
            
            make.top.equalTo(view).offset(nNavigationHeight)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
        }
        
        logoImage.snp.makeConstraints { (make) in
            
            make.top.equalTo(contentStackView).offset(30)
            make.centerX.equalTo(contentStackView)
            make.width.equalTo(88)
            make.height.equalTo(85)
        }
        
        phoneStackView.snp.makeConstraints { (make) in
            make.top.equalTo(contentStackView).offset(120)
            make.bottom.equalTo(phoneTextField).offset(17)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneStackView).offset(10)
            make.leading.equalTo(phoneTextField)
            make.width.equalToSuperview().multipliedBy(0.93)
            make.height.equalTo(15)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLabel.snp.bottom).offset(7)
            make.leading.equalTo(phoneLabel)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        pwStackView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneStackView.snp.bottom).offset(10)
            make.bottom.equalTo(passwordTextField).offset(17)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pwStackView).offset(10)
            make.leading.equalTo(passwordTextField)
            make.width.equalToSuperview().multipliedBy(0.93)
            make.height.equalTo(15)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom).offset(7)
            make.leading.equalTo(passwordLabel)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(pwStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        findPwButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.top.equalTo(findPwButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-68)
            make.height.equalTo(41)
            make.width.equalTo(41)
        }
        
        kakaoButton.snp.makeConstraints { (make) in
            make.top.equalTo(findPwButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(41)
            make.width.equalTo(41)
        }
        
        joinButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        snsLoginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(55)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(120)
        }
        
        autoLoginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentStackView).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(autoLoginBtn)
            make.height.equalTo(20)
        }
        
        autoLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(autoLoginLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(autoLoginLabel)
            make.height.equalTo(23)
        }
    }
    
    func setupEventSelector(){
        loginButton.addTarget(self, action: #selector(loginBtnEvent(_:)), for: .touchUpInside)
        autoLoginBtn.addTarget(self, action: #selector(autoLoginEvent(_:)), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookEvent(_:)), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(kakaoEvent(_:)), for: .touchUpInside)
        findPwButton.addTarget(self, action: #selector(findPwEvent(_:)), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinEvent(_:)), for: .touchUpInside)
    }
    
    func setupTextFieldDelegate(){
        self.passwordTextField.delegate = self as? UITextFieldDelegate
    }
}

class CustomTextField : UITextField{
    
    var isSubwaySearch : Bool = true
    var bottomBorder = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(hex: "#d8f900")
        font = UIFont.font(type: .bold, size: 15)
        leftViewMode = .always
        leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16, height: 0)))
        
        //MARK: Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor(hex : "#666666")
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        
        self.addTarget(self, action: #selector(startEditAction), for: .editingDidBegin)
        self.addTarget(self, action: #selector(endEditAction), for: .editingDidEnd)
        self.addTarget(self, action: #selector(endEditAction), for: .editingDidEndOnExit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startEditAction() {
        if isSubwaySearch == false {
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(hex : "#333333").cgColor
        }
    }
    
    @objc func endEditAction() {
        if isSubwaySearch == false {
            self.backgroundColor = .customGray
            self.layer.borderWidth = 0
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class CustomLabel : UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(hex: "#ffffff")
        font = UIFont.font(type: .nanumBold, size: 13)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}

