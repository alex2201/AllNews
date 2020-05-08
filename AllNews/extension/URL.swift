//
//  URL.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 05/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation

extension URL {
    static func getValidURLFrom(string: String) -> URL? {
        guard var urlComponents = URLComponents.init(string: string) else { return nil }
        urlComponents.scheme = "https"
        return urlComponents.url
    }
}
