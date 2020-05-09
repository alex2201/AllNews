//
//  LoadingTableViewCell.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 18/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class AccessoryTableViewCell: UITableViewCell {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var delegate: AccessoryTableViewCellDelegate?
    
    enum State {
        case loading
        case loadMore
        case results
    }
    @IBAction func loadMoreButtonPressed(_ sender: Any) {
        delegate?.loadMoreButtonPressed()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    private func setup() {
        // Button
        loadMoreButton.layer.borderColor = UIColor(named: "CellBorderColor")!.cgColor
        loadMoreButton.layer.borderWidth = CGFloat(3.0)
        loadMoreButton.layer.cornerRadius = 15
        
        // Label
        resultsLabel.layer.borderColor = UIColor(named: "CellBorderColor")!.cgColor
        resultsLabel.layer.borderWidth = CGFloat(3.0)
        resultsLabel.layer.cornerRadius = 15
    }
    
    func setState(state: State) {
        showElements(forState: state)
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            loadingIndicator.hidesWhenStopped = true
        case .loadMore:
            break
        case .results:
            break
        }
    }
    
    private func showElements(forState state: State) {
        loadingIndicator.isHidden = state != .loading
        loadMoreButton.isHidden = state != .loadMore
        resultsLabel.isHidden = state != .results
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
            loadMoreButton.layer.borderColor = UIColor(named: "CellBorderColor")!.cgColor
            resultsLabel.layer.borderColor = UIColor(named: "CellBorderColor")!.cgColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - AccessoryTableViewCellDelegate
protocol AccessoryTableViewCellDelegate {
    func loadMoreButtonPressed()
}
