//
//  ArticleDetailViewController.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 21/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit
import SafariServices

class ArticleDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var goToButton: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var removeFromFavoriteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Public properties
    var article: APIArticle!
    var viewModel: ArticleViewModel!
    var isFavorite: Bool!
    
    // MARK: - Private properties
    private var validDateString: String {
        var dateString = article.publishedAt
        // Slice valid date string
        let index = dateString.index(dateString.startIndex, offsetBy: 18)
        dateString = String(dateString[dateString.startIndex...index])
        return dateString
    }
    private var date: Date? {
        let decodeFormater = DateFormatter()
        decodeFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        return decodeFormater.date(from: validDateString)
    }
    private var formatedDateString: String? {
        let preferedFormatFormater = DateFormatter()
        preferedFormatFormater.locale = Locale(identifier: "es_MX")
        preferedFormatFormater.dateStyle = .medium
        guard let date = date else { return nil }
        
        return preferedFormatFormater.string(from: date)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    fileprivate func setupButtons() {
        goToButton.layer.cornerRadius = 10
        handleShowFavoriteButton()
    }
    
    private func handleShowFavoriteButton() {
        if isFavorite {
            addToFavoriteButton.isHidden = true
            removeFromFavoriteButton.isHidden = false
        } else {
            addToFavoriteButton.isHidden = false
            removeFromFavoriteButton.isHidden = true
        }
    }
    
    fileprivate func setupLabels() {
        titleLabel.text = article.title
        authorLabel.text = article.author
        sourceLabel.text = article.source.name
        descriptionLabel.text = article.articleDescription
        contentLabel.text = article.content
        dateLabel.text = formatedDateString
    }
    
    func setup() {
        setupLabels()
        setupButtons()
        setupArticleImage()
    }
    
    private func setupArticleImage() {
        // Load image if exist else hides imageview
        if  let urlString = article.urlToImage,
            let url = URL.getValidURLFrom(string: urlString),
            viewModel.cacheImageKeys.contains(url),
            let image = viewModel.getArticleImage(from: url) {
            articleImage.image = image
        } else {
            articleImage.isHidden = true
        }
    }
    
    // MARK: - IBActions
    @IBAction func redirectButtonPressed(_ sender: UIButton) {
        let url = URL(string: article.url)!
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addToFavoritePressed(_ sender: Any) {
        let articleModel = ArticleModel()
        articleModel.save(article: article)
        isFavorite = true
        handleShowFavoriteButton()
    }
    
    @IBAction func removeFromFavoritePressed(_ sender: Any) {
        let articleModel = ArticleModel()
        articleModel.remove(article: article)
        isFavorite = false
        handleShowFavoriteButton()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
