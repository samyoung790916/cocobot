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
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    @IBOutlet weak var infoLabel4: UILabel!
    @IBOutlet weak var infoLabel5: UILabel!
    
    @IBOutlet weak var termsAllagree: UIButton!
    @IBOutlet weak var terms_btn1: UIButton!
    @IBOutlet weak var terms_btn2: UIButton!
    @IBOutlet weak var terms_btn3: UIButton!
    @IBOutlet weak var terms_btn4: UIButton!
    
    
    var bAllSelect: Bool = false
    var bTerms:[Bool] = [false, false, false,false]
    
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
        
        if bAllSelect == true || (bTerms[0] == true && bTerms[1] == true){
            JoinViewController.bIdenti = true
            self.dismiss(animated: true, completion: nil)
        }else{
             AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "필수 약관에 모두 동의하셔야 합니다.") { (index, title) in}
            
        }
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    @IBAction func AllagreeAction(_ sender: Any) {
        
        if bAllSelect == false{
            
            bAllSelect = true
            bTerms[0] = true
            bTerms[1] = true
            bTerms[2] = true
            bTerms[3] = true
            
            termsAllagree.setImage(UIImage(named: "check_btn"), for: .normal)
            terms_btn1.setImage(UIImage(named: "check_btn"), for: .normal)
            terms_btn2.setImage(UIImage(named: "check_btn"), for: .normal)
            terms_btn3.setImage(UIImage(named: "check_btn"), for: .normal)
            terms_btn4.setImage(UIImage(named: "check_btn"), for: .normal)
            
        }else{
            
            bAllSelect = false
            bTerms[0] = false
            bTerms[1] = false
            bTerms[2] = false
            bTerms[3] = false
            
            termsAllagree.setImage(UIImage(named: "close_btn_disable"), for: .normal)
            terms_btn1.setImage(UIImage(named: "close_btn_disable"), for: .normal)
            terms_btn2.setImage(UIImage(named: "close_btn_disable"), for: .normal)
            terms_btn3.setImage(UIImage(named: "close_btn_disable"), for: .normal)
            terms_btn4.setImage(UIImage(named: "close_btn_disable"), for: .normal)
        }
        
    }
    
    @IBAction func terms1Action(_ sender: Any) {
        if self.bTerms[0] == false{
            self.bTerms[0] = true
            terms_btn1.setImage(UIImage(named: "check_btn"), for: .normal)
        }else{
            self.bTerms[0] = false
            terms_btn1.setImage(UIImage(named: "close_btn_disable"), for: .normal)
        }
    }
    
    @IBAction func terms2Actioon(_ sender: Any) {
        if self.bTerms[1] == false{
            self.bTerms[1] = true
            terms_btn2.setImage(UIImage(named: "check_btn"), for: .normal)
        }else{
            self.bTerms[1] = false
            terms_btn2.setImage(UIImage(named: "close_btn_disable"), for: .normal)
        }
    }
    
    @IBAction func terms3Action(_ sender: Any) {
        if self.bTerms[2] == false{
            self.bTerms[2] = true
            terms_btn3.setImage(UIImage(named: "check_btn"), for: .normal)
        }else{
            self.bTerms[2] = false
            terms_btn3.setImage(UIImage(named: "close_btn_disable"), for: .normal)
        }
    }
    
    @IBAction func terms4Action(_ sender: Any) {
        if self.bTerms[3] == false{
            self.bTerms[3] = true
            terms_btn4.setImage(UIImage(named: "check_btn"), for: .normal)
        }else{
            self.bTerms[3] = false
            terms_btn4.setImage(UIImage(named: "close_btn_disable"), for: .normal)
        }
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






