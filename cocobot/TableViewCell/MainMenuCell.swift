//
//  MainMenuCell.swift
//  cocobot
//
//  Created by samyoung79 on 03/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class MainMenuCell: UITableViewCell {

    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var SubLabel: UILabel!
    
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var JoinBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
