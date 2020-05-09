//
//  NewArticleTableViewCell.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 17/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        articleView.layer.cornerRadius = 15
        
        let borderColor = UIColor(named: "CellBorderColor")!
        articleView.layer.borderColor = borderColor.cgColor
        articleView.layer.borderWidth = CGFloat(3.0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            let borderColor = UIColor(named: "CellBorderColor")!
            articleView.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
