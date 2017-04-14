//
//  RSCartTableViewCell.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/15/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import UIKit

class RSCartTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
