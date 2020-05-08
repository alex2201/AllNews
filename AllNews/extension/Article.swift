//
//  Article.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 06/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation

extension Article {
    func toAPIArticle() -> APIArticle {
        let apiArticle = APIArticle(
            source: APIArticleSource(id: "", name: sourceName!),
            author: author,
            title: title!,
            articleDescription: articleDescription,
            url: url!,
            urlToImage: urlToImage,
            publishedAt: publishedAt!,
            content: content
        )
        return apiArticle
    }
}
