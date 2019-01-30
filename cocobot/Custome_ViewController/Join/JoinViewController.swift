//
//  JoinViewController.swift
//  cocobot
//
//  Created by samyoung79 on 17/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import KakaoOpenSDK

class JoinViewController: UIViewController {
    
    // join popup
    var join_shadow_view = UIStackView()
    let close_btn = UIButton()
    let joinview_title = UILabel()
    
    let kakao_join_btn = UIButton()
    let facebook_join_btn = UIButton()
    let tel_joinbtn = UIButton()
    
    
    // UI
    let customer_join_view: UIView = UIView()
    let store_join_view: UIView = UIView()
    let customer_label: UILabel = UILabel()
    let store_label: UILabel = UILabel()
    
    let logoImage: UIImageView = UIImageView()
    let customer_icon: UIImageView = UIImageView()
    let store_icon: UIImageView = UIImageView()
    
    static var bHome = false
    static var bIdenti = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        self.setupEvent()
    }
    override func viewDidAppear(_ animated: Bool) {
        if JoinViewController.bHome == true{
            JoinViewController.bHome = false
            self.navigationController?.popToRootViewController(animated: true)
        }
        else if JoinViewController.bIdenti == true{
            JoinViewController.bIdenti = false
            
            performSegue(withIdentifier: "CertiSegue", sender: self)
        }
        
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor.black
        logoImage.image = UIImage(named: "logo")
        customer_icon.image = UIImage(named: "customer_icon")
        store_icon.image = UIImage(named: "store_icon")
        
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
        
        self.view.addSubview(contentStackView)
        customer_join_view.layer.cornerRadius = 15.0
        store_join_view.layer.cornerRadius = 15.0
        
        customer_join_view.backgroundColor = UIColor.white
        store_join_view.backgroundColor = UIColor(hex: "#d8f900")
        
        
        contentStackView.addSubview(logoImage)
        
        contentStackView.addSubview(customer_join_view)
        contentStackView.addSubview(customer_icon)
        
        contentStackView.addSubview(store_join_view)
        contentStackView.addSubview(store_icon)
        
        customer_join_view.addSubview(customer_label)
        store_join_view.addSubview(store_label)
        
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
        
        customer_join_view.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentStackView)
            make.top.equalTo(logoImage.snp.bottom).offset(50)
            make.left.equalTo(contentStackView).offset(30)
            make.right.equalTo(contentStackView).offset(-30)
            make.height.equalTo(150)
        }
        customer_icon.snp.makeConstraints { (make) in
            make.centerX.equalTo(customer_join_view)
            make.top.equalTo(customer_join_view.snp.top).offset(30)
            make.width.equalTo(55)
            make.height.equalTo(59)
        }
        
        store_join_view.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentStackView)
            make.top.equalTo(customer_join_view.snp.bottom).offset(30)
            make.left.equalTo(contentStackView).offset(30)
            make.right.equalTo(contentStackView).offset(-30)
            make.height.equalTo(150)
        }
        
        store_icon.snp.makeConstraints { (make) in
            make.centerX.equalTo(store_join_view)
            make.top.equalTo(store_join_view.snp.top).offset(30)
            make.width.equalTo(65)
            make.height.equalTo(65)
        }
        
        customer_label.snp.makeConstraints { (make) in
            make.centerX.equalTo(customer_join_view)
            make.bottom.equalTo(customer_join_view.snp.bottom).offset(-20)
            make.left.equalTo(customer_join_view.snp.left).offset(30)
            make.right.equalTo(customer_join_view.snp.right).offset(-30)
            make.height.equalTo(20)
        }
        
        customer_label.text = "개인용 회원가입"
        customer_label.textAlignment = .center
        customer_label.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        
        store_label.snp.makeConstraints { (make) in
            make.centerX.equalTo(store_join_view)
            make.bottom.equalTo(store_join_view.snp.bottom).offset(-20)
            make.left.equalTo(store_join_view.snp.left).offset(30)
            make.right.equalTo(store_join_view.snp.right).offset(-30)
            make.height.equalTo(20)
        }
        store_label.text = "매장용 회원가입"
        store_label.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        store_label.textAlignment = .center
    }
    
    func setupEvent(){
        let customer_touch   =  UITapGestureRecognizer(target: self, action: #selector(customer_join_action(_:)))
        let store_touch      =  UITapGestureRecognizer(target: self, action: #selector(store_join_action(_:)))
        
        self.customer_join_view.addGestureRecognizer(customer_touch)
        self.store_join_view.addGestureRecognizer(store_touch)
        
        self.close_btn.addTarget(self, action: #selector(popup_close_action(_:)), for: .touchUpInside)
        
        self.kakao_join_btn.addTarget(self, action: #selector(kakako_join_action(_:)), for: .touchUpInside)
        self.facebook_join_btn.addTarget(self, action: #selector(facebook_join_action(_:)), for: .touchUpInside)
        self.tel_joinbtn.addTarget(self, action: #selector(tel_join_action(_:)), for: .touchUpInside)
    }
    
    //MARK: 고객,점주 가입 이벤트
    @objc func customer_join_action(_ sender:UITapGestureRecognizer){
        self.show_join_popup()
    }
    
    @objc func store_join_action(_ sender:UITapGestureRecognizer){
        
    }
    
    @objc func popup_close_action(_ sender : UIButton) {
        self.hide_join_popup()
    }
    
    @objc func kakako_join_action(_ sender : UIButton) {
        
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
                            let array = ["USER_ROLE" : "5","USER_SNS" : me.id]
                            APIService.shared.post(url: "snsjoin/kakao", string: array.json()){[weak self] (result, resultDict) in
                                if result == .success {
                                    print("카카오톡 로그인")
                                    self!.performSegue(withIdentifier: "associateSegue", sender: self)
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
    
    @objc func facebook_join_action(_ sender : UIButton) {

        
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
                    let array = [
                        "USER_ROLE" : "5",
                        "USER_SNS" : id
                    ]
                    
                    APIService.shared.post(url: "snsjoin/facebook", string: array.json(), resultCompletion: { (result, resultDict) in
                        
                        if result == .success{
                            print("성공")
                            self.performSegue(withIdentifier: "associateSegue", sender: self)
                        }else{
                            print("실패")
                        }
                    })
                }
                
            }
        }
        
        
        
    }
    @objc func tel_join_action(_ sender : UIButton) {
         performSegue(withIdentifier: "TermsSegue", sender: self)
    }

    
    func show_join_popup(){
        
        join_shadow_view.addBackground(color: UIColor(hex: "#000000").withAlphaComponent(0.7))
        join_shadow_view.isOpaque = true
        join_shadow_view.isHidden = false
        self.view.addSubview(join_shadow_view)
        
        close_btn.setImage(UIImage(named: "close_btn"), for:.normal)
        
        let joinStackView = UIStackView()
        joinStackView.axis = .vertical
        joinStackView.alignment = .fill
        joinStackView.distribution = .fillEqually
        joinStackView.spacing = 10
        joinStackView.addBackground(color: UIColor(hex: "#ffffff"))
        
        let titleLabel = UILabel()
        titleLabel.text = "회원가입 방법을 선택하세요"
        titleLabel.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        titleLabel.textColor = UIColor(hex: "#1a1a1a")
        titleLabel.textAlignment = .center
        
        kakao_join_btn.setTitle("카카오 아이디로 간편가입", for: .normal)
        kakao_join_btn.setTitleColor(UIColor(hex: "#381e1e"), for:.normal)
        kakao_join_btn.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        kakao_join_btn.backgroundColor = UIColor(hex: "#ffe600")
        
        facebook_join_btn.setTitle("페이스북 아이디로 간편가입", for: .normal)
        facebook_join_btn.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        facebook_join_btn.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        facebook_join_btn.backgroundColor = UIColor(hex: "#445d97")
        
        
        tel_joinbtn.setTitle("핸드폰 번호로 간편가입", for: .normal)
        tel_joinbtn.setTitleColor(UIColor(hex: "#ffffff"), for: .normal)
        tel_joinbtn.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular" , size: 17)
        tel_joinbtn.backgroundColor = UIColor(hex: "#1a1a1a")
    
        join_shadow_view.addSubview(joinStackView)
        joinStackView.addSubview(close_btn)
        joinStackView.addSubview(titleLabel)
        joinStackView.addSubview(kakao_join_btn)
        joinStackView.addSubview(facebook_join_btn)
        joinStackView.addSubview(tel_joinbtn)
        
        join_shadow_view.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        joinStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(185)
            make.left.equalToSuperview().offset(27)
            make.right.equalToSuperview().offset(-27)
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(joinStackView)
            make.top.equalTo(joinStackView).offset(40)
            make.width.equalTo(400)
            make.height.equalTo(20)
        }
        
        kakao_join_btn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        facebook_join_btn.snp.makeConstraints { (make) in
            make.top.equalTo(kakao_join_btn.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        tel_joinbtn.snp.makeConstraints { (make) in
            make.top.equalTo(facebook_join_btn.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        
        
        close_btn.snp.makeConstraints { (make) in
            make.top.equalTo(joinStackView).offset(6)
            make.right.equalTo(joinStackView.snp.right).offset(-7)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    func hide_join_popup(){
        self.join_shadow_view.removeFromSuperview()
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
