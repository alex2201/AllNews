//
//  ArticleModel.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 05/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation
import CoreData

class ArticleModel: ManagedObjectModel {
    // MARK: - Private properties
    
    // MARK: - Public properties
    var offset: Int = 0
    var limit = 20
    
    // MARK: - Methods
    override init() {
        super.init()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    private func getArticlesRequest(searchingFor string: String) -> NSFetchRequest<Article> {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.fetchLimit = limit
        request.fetchOffset = offset
        
        return request
    }
    
    func getArticles(searchingFor string: String) -> [Article] {
        let request: NSFetchRequest<Article> = getArticlesRequest(searchingFor: string)
        var articles: [Article] = []
        do {
            articles = try context.fetch(request)
            articles = articles.filter({ articleFilter($0, forString: string) })
        } catch {
            debugPrint(string, error, separator: "->")
        }
        
        return articles
    }
    
    private func articleFilter(_ article: Article, forString string: String) -> Bool {
        return string.isEmpty
            || article.title!.lowercased().contains(string)
            || article.content!.lowercased().contains(string)
    }
    
    func save(article: APIArticle) {
        let saveArticle = Article(context: context)
        saveArticle.title = article.title
        saveArticle.articleDescription = article.articleDescription
        saveArticle.author = article.author
        saveArticle.content = article.content
        saveArticle.publishedAt = article.publishedAt
        saveArticle.sourceName = article.source.name
        saveArticle.url = article.url
        saveArticle.urlToImage = article.urlToImage
        saveContext()
    }
    
    func remove(article: APIArticle) {
        let url = article.url
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(format: "url=%@", url)
        if let data = try? context.fetch(request) {
            let savedArticle = data.first!
            context.delete(savedArticle)
            saveContext()
        }
    }
    
    func isSaved(article: APIArticle) -> Bool {
        let url = article.url
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(format: "url=%@", url)
        guard let data = try? context.fetch(request) else { return false }
        return data.count > 0
    }
}
