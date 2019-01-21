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



struct LoginInfoData {
    var status_code: String? = ""
    var status: String?  = ""
    var accessToken: String?  = ""
    var user_tel: String?  = ""
    var cvid: String?  = ""
    var coinid: String?  = ""
    var user_name: String?   = ""
    var market_name: String?  = ""
    var coint_pw: String?  = ""
    
    var firstLogin = 0
    var recommender_cnt = 0
    var user_role = 0
    var marketInfos = 0
    
    var recommenderInfo = [[:]]
}


class LoginViewController: UIViewController {
    
    //MARK: Data member variable
    var coin_id = ""
    static var isLogin = false
    static var LoginData = LoginInfoData()
    
    
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
        
//        self.indicator.isHidden = false
//        self.indicator.startAnimating()
        
        APIService.shared.post(url: "login", string: array.json()) { (result, resultDict) in
        
//            self.indicator.stopAnimating()
//            self.indicator.isHidden = true
            
            
            if result == .success{
                UserDefaults.standard.set(resultDict["userRole"], forKey: "userRole")
                
                
                LoginViewController.isLogin = true
                
                LoginViewController.LoginData.coinid       = resultDict["coinid"] as? String
                LoginViewController.LoginData.accessToken  = resultDict["accessToken"] as? String
                LoginViewController.LoginData.coint_pw     = resultDict["coinpw"] as? String
                LoginViewController.LoginData.user_tel     = resultDict["userTel"] as? String
                LoginViewController.LoginData.user_name    = resultDict["username"] as? String
                LoginViewController.LoginData.cvid         = resultDict["cvid"] as? String
                LoginViewController.LoginData.status_code  = resultDict["status_code"] as? String
                LoginViewController.LoginData.status       = resultDict["status"] as? String
                
                LoginViewController.LoginData.firstLogin   = (resultDict["firstLogin"] as! NSString).integerValue
                LoginViewController.LoginData.user_role    = (resultDict["userRole"] as! NSString).integerValue
                
                LoginViewController.LoginData.recommender_cnt  = resultDict["recommenderCnt"] as! Int
                LoginViewController.LoginData.marketInfos      = resultDict["marketInfos"] as! Int
                
                if LoginViewController.LoginData.recommender_cnt >= 1{
                    
                    if let jsonArr = resultDict["recommenderInfo"] as? [[String:Any]]{
                        for index in 0 ..< jsonArr.count{
                            let dict = jsonArr[index]
                            LoginViewController.LoginData.recommenderInfo.append(dict)
                        }
                    }
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
    @objc func autoLoginEvent(_ sender : UIButton) {
        print("autoLoginEvent")
    }
    @objc func facebookEvent(_ sender : UIButton) {
        print("facebookEvent")
    }
    @objc func kakaoEvent(_ sender : UIButton) {
        print("kakaoEvent")
    }
    @objc func findPwEvent(_ sender : UIButton) {
        print("findPwEvnet")
    }
    @objc func joinEvent(_ sender : UIButton) {
        print("joinEvnet")
    }
    
}

extension LoginViewController{
    
    func setupUI(){
        
        logoImage.image = UIImage(named: "logo")
        
        phoneLabel.text = "핸드폰 번호"
        phoneTextField.keyboardType = .phonePad
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "PHONE NUMBER",
                                                                  attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                               NSAttributedString.Key.foregroundColor : UIColor(hex : "#555555")])
        
        passwordLabel.text = "비밀 번호"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                                     attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                                  NSAttributedString.Key.foregroundColor : UIColor(hex : "#555555")])
        
        loginButton.setImage(UIImage(named: "login_btn"), for: .normal)
        
        findPwButton.setTitle("비밀번호 찾기", for: .normal)
        findPwButton.setTitleColor(UIColor(hex: "#e4e4e4"), for: .normal)
        findPwButton.titleLabel?.font = UIFont.font(type: .nanumBold, size: 13)
        
        facebookButton.setImage(UIImage(named: "facebook"), for: .normal)
        kakaoButton.setImage(UIImage(named: "kakao"), for: .normal)
        
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.setTitleColor(UIColor(hex: "#d8f900"), for: .normal)
        joinButton.titleLabel?.font = UIFont.font(type: .nanumBold, size: 15)
        
        snsLoginLabel.font = UIFont.font(type: .nanumBold, size: 13)
        snsLoginLabel.textColor = UIColor(hex : "#ffffff")
        snsLoginLabel.text = "SNS로 로그인"
        
        autoLoginLabel.font = UIFont.font(type: .nanumBold, size: 10)
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
            make.height.equalTo(97)
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
            make.top.equalTo(phoneStackView.snp.bottom).offset(20)
            make.bottom.equalTo(passwordTextField).offset(17)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(97)
        }
        
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pwStackView).offset(20)
            make.leading.equalTo(passwordTextField)
            make.width.equalToSuperview().multipliedBy(0.93)
            make.height.equalTo(15)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordLabel.snp.bottom).offset(20)
            make.bottom.equalTo(pwStackView)
            make.leading.equalTo(passwordLabel)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentStackView).offset(350)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        findPwButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.top.equalTo(findPwButton.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-68)
            make.height.equalTo(41)
            make.width.equalTo(41)
        }
        
        kakaoButton.snp.makeConstraints { (make) in
            make.top.equalTo(findPwButton.snp.bottom).offset(10)
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

