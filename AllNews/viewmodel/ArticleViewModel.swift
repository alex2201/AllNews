//
//  ArticleModelView.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 14/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation
import UIKit.UIImage

class ArticleViewModel {
    // MARK: - Public properties
    var articles: [APIArticle] = []
    var limit = 20
    var cacheImageKeys = Set<URL>()
    var delegate: ArticleViewModelDelegate?
    var pageIndex: Int = 1
    
    // MARK: - Private properties
    private let cache = Cache<String, Data>()
    private var language: Language {
        return UserSettings.shared.language
    }
    private var sourcesString: String {
        return SourceModel()
        .sources
        .map({ $0.id! })
        .reduce( "" , { "\($0)\($1)," })
    }
    private lazy var model = ArticleModel()
    
    // MARK: - Methods
    func reset() {
        cache.clear()
        articles = []
    }
    
    func isSaved(article: APIArticle) -> Bool {
        return model.isSaved(article: article)
    }
    
    func searchFromFavorites(text: String) {
        delegate?.viewModelWillBeginSearch(self)
        model.offset = (pageIndex - 1) * limit
        model.limit = limit
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let favArticles = self.model.getArticles(searchingFor: text)
            let apiArticles = favArticles.map({ $0.toAPIArticle() })
            self.articles.append(contentsOf: apiArticles)
            self.delegate?.viewModelDidFinishSearch(self)
            self.delegate?.viewModelDidFinishLoadingArticles(self, apiArticles)
        }
    }
    
    func loadTopHeadlinesChunk() {
        delegate?.viewModelWillBeginRequest(self)
        let sources = sourcesString
        let request = NewsAPI.request(
            for: .topHeadlines,
            withParams: [
                URLQueryItem(name: "language", value: language.rawValue),
                URLQueryItem(name: "pageSize", value: "\(limit)"),
                URLQueryItem(name: "page", value: "\(pageIndex)"),
                URLQueryItem(name: "sources", value: sources),
            ]
        )
        DispatchQueue.global(qos: .userInitiated).async {
            NewsAPI.performRequest(request, withDelegate: self)
        }
    }
    
    func searchFromAPI(text: String) {
        self.delegate?.viewModelWillBeginSearch(self)
        let sources = sourcesString
        let request = NewsAPI.request(
            for: .everything,
            withParams: [
                URLQueryItem(name: "language", value: language.rawValue),
                URLQueryItem(name: "pageSize", value: "\(limit)"),
                URLQueryItem(name: "page", value: "\(pageIndex)"),
                URLQueryItem(name: "qInTitle", value: text),
                URLQueryItem(name: "sortBy", value: "relevancy"),
                URLQueryItem(name: "sources", value: sources),
            ]
        )
        NewsAPI.performRequest(request, withDelegate: self)
        self.delegate?.viewModelDidFinishSearch(self)
    }
    
    private func getImageData(fromUrl url: URL) -> Data? {
        var imageData: Data? = nil
        do {
            imageData = try Data(contentsOf: url)
        } catch {
//            print("ERROR retrieving image from \"\(url)\": \(error)")
        }
        
        return imageData
    }
    
    fileprivate func insertInCache(imageData data: Data, forKey key: String) {
        cache.insert(data, forKey: key)
    }
    
    fileprivate func getLoadImageWorkItem(forUrl url: URL) -> DispatchWorkItem {
        return DispatchWorkItem(qos: .userInitiated) { [unowned self] in
            if let imageData = self.getImageData(fromUrl: url) {
                self.insertInCache(imageData: imageData, forKey: url.description)
            }
        }
    }
    
    fileprivate func loadImageAsync(inQueue queue: DispatchQueue, inGroup group: DispatchGroup,forUrl url: URL) {
        let workItem = getLoadImageWorkItem(forUrl: url)
        queue.async(group: group, execute: workItem)
    }
    
    private func loadImagesInCache(fromUrls urls: [URL]) {
        let queue = DispatchQueue(label: "com.lonelydeadman.AllNews.loadImages", qos: .utility, attributes: .concurrent)
        let group = DispatchGroup()
        
        urls.forEach { loadImageAsync(inQueue: queue, inGroup: group, forUrl: $0) }
        
        group.notify(queue: queue) { [unowned self] in
            self.handleFinishLoadingImagesInCache(fromUrls: urls)
        }
    }
    
    private func handleFinishLoadingImagesInCache(fromUrls urls: [URL]) {
        urls.forEach({ [unowned self] url in
            self.cacheImageKeys.insert(url)
        })
        self.delegate?.viewModelDidFinishLoadingImages(self)
    }
    
    func getArticleImage(from url: URL) -> UIImage? {
        var image: UIImage? = nil
        
        // Try loading from cache else load from url
        if let cacheData = cache[url.description] {
            image = UIImage(data: cacheData)
        } else if let imageData = getImageData(fromUrl: url) {
            insertInCache(imageData: imageData, forKey: url.description)
            image = UIImage(data: imageData)
        }
        return image
    }
    
    func loadImages(forArticles articles: [APIArticle]) {
        let urlsToImages = articles.map { (article) -> URL? in
            guard let urlString = article.urlToImage, !urlString.contains(".gif") else { return nil }
            return URL.getValidURLFrom(string: urlString)
        }.compactMap({ $0 })
        self.loadImagesInCache(fromUrls: urlsToImages)
    }
}

// MARK: - Image transformation
extension ArticleViewModel {
    private func scale(_ image: UIImage, into size: CGSize) -> UIImage {
        let minBound = min(size.height, size.width)
        let imageSize = image.size
        let heighScale = minBound / imageSize.height
        let widthScale = minBound / imageSize.width
        let scale = min(heighScale, widthScale)
        return resizedImage(image, for: CGSize(width: imageSize.width * scale, height: imageSize.height * scale))
    }
    
    private func resizedImage(_ image: UIImage, for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}

// MARK: - APIRequestDelegate
extension ArticleViewModel: APIRequestDelegate {
    
    func didFinishRequest(data: Data?, error: (code: String, message: String)?) {
        var articles:[APIArticle] = []
        defer {
            self.delegate?.viewModelDidFinishLoadingArticles(self, articles)
        }
        if error == nil {
            articles = decodeArticles(fromData: data)
            self.articles.append(contentsOf: articles)
        } else {
            print("ERROR \(error!.code): \(error!.message)")
        }
    }
    
    private func decodeArticles(fromData data: Data?) -> [APIArticle] {
        guard let data = data else { return [] }
        let decoder = JSONDecoder()
        let articleResponse = try? decoder.decode(APIArticleResponse.self, from: data)
        return articleResponse?.articles ?? []
    }
    
}

// MARK: - Protocol ArticleViewModelDelegate
protocol ArticleViewModelDelegate {
    func viewModelDidFinishLoadingArticles(_ viewModel: ArticleViewModel, _ loadedArticles: [APIArticle])
    func viewModelDidFinishLoadingImages (_ viewModel: ArticleViewModel)
    func viewModelDidFinishSearch(_ viewModel: ArticleViewModel)
    func viewModelWillBeginSearch(_ viewModel: ArticleViewModel)
    func viewModelWillBeginRequest(_ viewModel: ArticleViewModel)
}
