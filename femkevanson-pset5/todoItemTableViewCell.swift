//
//  todoItemTableViewCell.swift
//  femkevanson-pset5
//
//  Created by Femke van Son on 30-11-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit

class todoItemTableViewCell: UITableViewCell {
   
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var todoItem: UILabel!
 
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
