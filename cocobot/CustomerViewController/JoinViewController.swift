//
//  JoinViewController.swift
//  cocobot
//
//  Created by samyoung79 on 17/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    let logoImage: UIImageView = UIImageView()
    let customer_join_view: UIView = UIView()
    let store_join_view: UIView = UIView()
    let customer_label: UILabel = UILabel()
    let store_label: UILabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor.black
        logoImage.image = UIImage(named: "logo")
        
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
        store_join_view.backgroundColor = UIColor(hex: "#8dfd73")
        
        
        contentStackView.addSubview(logoImage)
        contentStackView.addSubview(customer_join_view)
        contentStackView.addSubview(store_join_view)
        
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
            make.top.equalTo(logoImage.snp.bottom).offset(80)
            make.left.equalTo(contentStackView).offset(30)
            make.right.equalTo(contentStackView).offset(-30)
            make.height.equalTo(150)
        }
        
        store_join_view.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentStackView)
            make.top.equalTo(customer_join_view.snp.bottom).offset(30)
            make.left.equalTo(contentStackView).offset(30)
            make.right.equalTo(contentStackView).offset(-30)
            make.height.equalTo(150)
        }
        
        customer_label.snp.makeConstraints { (make) in
            make.centerX.equalTo(customer_join_view)
            make.bottom.equalTo(customer_join_view.snp.bottom).offset(-20)
            make.left.equalTo(customer_join_view.snp.left).offset(30)
            make.right.equalTo(customer_join_view.snp.right).offset(-30)
            make.height.equalTo(20)
        }
        
        customer_label.text = "AAAA"
        customer_label.textAlignment = .center
        
        store_label.snp.makeConstraints { (make) in
            make.centerX.equalTo(store_join_view)
            make.bottom.equalTo(store_join_view.snp.bottom).offset(-20)
            make.left.equalTo(store_join_view.snp.left).offset(30)
            make.right.equalTo(store_join_view.snp.right).offset(-30)
            make.height.equalTo(20)
        }
        store_label.text = "AAAA"
        store_label.textAlignment = .center
        
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
