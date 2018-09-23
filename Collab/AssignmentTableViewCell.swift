//
//  AssignmentTableViewCell.swift
//  Collab
//
//  Created by Parth Saxena on 9/22/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attachmentsLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
