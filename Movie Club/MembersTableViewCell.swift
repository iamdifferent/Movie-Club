//
//  MembersTableViewCell.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {

    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
