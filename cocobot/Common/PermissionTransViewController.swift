//
//  PermissionTransViewController.swift
//  cocobot
//
//  Created by samyoung79 on 18/02/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class PermissionTransViewController: UIViewController {

    @IBOutlet weak var InfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
            self.navigationItem.title = "비밀번호 설정"
        
        InfoLabel.numberOfLines = 0
        InfoLabel.text = "설정한 비밀번호는 매장내 비치된 빈큐에 사용되며,\n 전화번호 앱 로그인시에도 사용할 수 있습니다."

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
