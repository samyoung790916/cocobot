//
//  TermsViewController.swift
//  cocobot
//
//  Created by samyoung79 on 30/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {


    @IBOutlet weak var label: UILabel!
    //  @IBOutlet weak var TermView: UIView!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    @IBOutlet weak var infoLabel4: UILabel!
    @IBOutlet weak var infoLabel5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "가입약관"
        infoLabel1.text = "원활한 서비스 이용을 위해 필수 항목\n동의가 필요합니다."
        infoLabel2.text = "서비스 이용약관(필수)\n서비스 이용약관 보기"
        infoLabel3.text = "개인정보 수집 및 이용 동의(필수)\n개인정보 이용약관 보기"
        infoLabel4.text = "위치정보 이용 동의(선택)\n위치정보 이용약관 보기"
        infoLabel5.text = "마케팅 SNS 수신 동의(선택)\n위치정보 이용약관 보기"
    }
    
    @IBAction func NextAction(_ sender: UIButton) {
     //   performSegue(withIdentifier: "identitySegue", sender: self)
         JoinViewController.bIdenti = true
          self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
//        self.willMove(toParent: nil)
//        self.view.removeFromSuperview()
//        self.removeFromParent()
       
        self.dismiss(animated: true, completion: nil)
        
    //    self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
     
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        parent?.navigationController?.popViewController(animated: true)
//    }
//    override func willMove(toParent parent: UIViewController?) {
//        parent?.navigationController?.popViewController(animated: true)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}






