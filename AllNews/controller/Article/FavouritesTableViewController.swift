//
//  FavouriteTableViewController.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 05/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var articleSearchBar: UISearchBar!
    
    // MARK: - Private properties
    private var viewModel = ArticleViewModel()
    private var selectedArticle: APIArticle?
    private var articles: [APIArticle] {
        return viewModel.articles
    }
    private var searchText: String = ""
    private var pageIndex = 1
    private var isLoading = false
    private var isEndOfResults = false

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        articleSearchBar.delegate = self
    }
    
    private func handleLoading() {
        isLoading = true
        isEndOfResults = false
        reloadAccessoryCell()
    }
    
    func performSearch() {
        handleLoading()
        viewModel.pageIndex = pageIndex
        viewModel.searchFromFavorites(text: searchText)
    }
    
    fileprivate func reloadAccessoryCell() {
        let indexPath = IndexPath(row: articles.count, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    private func resetController() {
        pageIndex = 1
        resetTableView()
        performSearch()
    }
    
    // MARK: - IBActions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        resetController()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell: UITableViewCell
        if indexPath.row < articles.count {
            cell = getArticleCell(cellForRowAt: indexPath)
        } else {
            cell = getAccessoryCell(cellForRowAt: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row < articles.count {
            selectedArticle = articles[indexPath.row]
            performSegue(withIdentifier: "goToArticleDetail", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       switch segue.identifier {
       case "goToArticleDetail":
           let vc = segue.destination as! ArticleDetailViewController
           vc.viewModel = viewModel
           vc.article = selectedArticle
           vc.isFavorite = viewModel.isSaved(article: selectedArticle!)
       default: break
        }
    }

}

// MARK: - Setup
extension FavouritesTableViewController {
    private func setupTableView() {
        let articleNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: "headlineCell")
        
        let loadingNib = UINib(nibName: "AccessoryTableViewCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "accessoryCell")
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        performSearch()
    }
    
    private func resetTableView() {
        viewModel.reset()
        tableView.reloadData()
    }
}

// MARK: - ArticleViewModelDelegate
extension FavouritesTableViewController: ArticleViewModelDelegate {
    func viewModelWillBeginRequest(_ viewModel: ArticleViewModel) {
    }
    
    func viewModelDidFinishLoadingArticles(_ viewModel: ArticleViewModel, _ loadedArticles: [APIArticle]) {
        isLoading = false
        isEndOfResults = loadedArticles.count < viewModel.limit
        
        if loadedArticles.count > 0 {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
            viewModel.loadImages(forArticles: loadedArticles)
        } else {
            DispatchQueue.main.async { [unowned self] in
                self.reloadAccessoryCell()
            }
        }
    }
    
    func viewModelDidFinishLoadingImages(_ viewModel: ArticleViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func viewModelDidFinishSearch(_ viewModel: ArticleViewModel) {
        
    }
    
    func viewModelWillBeginSearch(_ viewModel: ArticleViewModel) {
    }
}
// MARK: - Table view helper methods
extension FavouritesTableViewController {
    private func getAccessoryCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accessoryCell", for: indexPath) as! AccessoryTableViewCell
        cell.setState(state: isLoading ? .loading : isEndOfResults ? .results : .loadMore)
        if cell.delegate == nil {
            cell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getArticleCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as! ArticleTableViewCell
        
        let article = articles[indexPath.row]
        var urlComponents = URLComponents.init(string: article.urlToImage ?? "")
        urlComponents?.scheme = "https"
        
        if let url = urlComponents?.url, viewModel.cacheImageKeys.contains(url), let articleImage = viewModel.getArticleImage(from: url) {
            cell.articleImage.image = articleImage
            cell.articleImage.isHidden = false
            cell.articleImage.alpha = 0
            UIView.animate(withDuration: 1) {
                cell.articleImage.alpha = 1
            }
        } else {
            cell.articleImage.image = nil
            cell.articleImage.isHidden = true
        }
        cell.titleLabel.text = article.title
        cell.sourceLabel.text = article.source.name
        cell.descriptionLabel.text = article.articleDescription
        
        return cell
    }
}

// MARK: - SearchBar delegate
extension FavouritesTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchText = ""
        searchBar.endEditing(true)
        resetController()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var text = searchBar.text ?? ""
        text = text.trimmingCharacters(in: [" "])
        searchBar.endEditing(true)
        resetTableView()
        searchText = text
        performSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = searchBar.text == nil
    }
}

// MARK: - AccessoryTableViewCellDelegate
extension FavouritesTableViewController: AccessoryTableViewCellDelegate {
    
    func loadMoreButtonPressed() {
        pageIndex += 1
        performSearch()
    }
}
