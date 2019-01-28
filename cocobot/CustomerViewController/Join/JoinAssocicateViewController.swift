//
//  JoinAssocicateViewController.swift
//  cocobot
//
//  Created by samyoung79 on 28/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class JoinAssocicateViewController: UIViewController {

    @IBOutlet weak var JoinCompleteLabel: UILabel!
    @IBOutlet weak var CautionLabel: UILabel!
    @IBOutlet weak var Ment1Label: UILabel!
    @IBOutlet weak var Ment2Label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JoinCompleteLabel.text = "가입이 완료되었습니다."
        CautionLabel.text = "주의!"
        Ment1Label.text = "* 회원가입 완료 되었습니다."
        Ment2Label.text = "* 좀 더 다양한 기능의 사용을 원하시면 본인확인을 진행해 주세요."
        

        // Do any additional setup after loading the view.
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
