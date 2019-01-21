//
//  BannerCell.swift
//  cocobot
//
//  Created by samyoung79 on 16/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit

class BannerCell: UITableViewCell {

    @IBOutlet weak var adImageScrollview: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adImageScrollview.translatesAutoresizingMaskIntoConstraints = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
