//
//  StreamTableViewCell.swift
//  Collab
//
//  Created by Parth Saxena on 9/22/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit

class StreamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
