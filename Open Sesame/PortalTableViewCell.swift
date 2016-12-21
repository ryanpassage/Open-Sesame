//
//  PortalTableViewCell.swift
//  Open Sesame
//
//  Created by Ryan Passage on 9/30/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import UIKit

class PortalTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
