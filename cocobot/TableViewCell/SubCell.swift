//
//  SubCell.swift
//  cocobot
//
//  Created by samyoung79 on 08/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {

    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    
    override func awakeFromNib() { 
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
