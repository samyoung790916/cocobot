//
//  SideSubCell.swift
//  cocobot
//
//  Created by samyoung79 on 07/02/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class SideSubCell: UITableViewCell {

    @IBOutlet weak var SubImage: UIImageView!
    @IBOutlet weak var SubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
