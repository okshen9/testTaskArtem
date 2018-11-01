//
//  AnnotationTVC.swift
//  testTaskArtem
//
//  Created by Артём Нешко on 29/10/2018.
//  Copyright © 2018 Артём Нешко. All rights reserved.
//

import UIKit

class AnnotationTVC: UITableViewCell {

    @IBOutlet weak var ibDescriptionLabel: UILabel!
    @IBOutlet weak var ibScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(description: String, score: Double) {
        self.ibDescriptionLabel.text = description
        self.ibScoreLabel.text = "\(score)"
    }
}
