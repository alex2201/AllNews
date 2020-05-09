//
//  SourcesTableViewCell.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 22/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
