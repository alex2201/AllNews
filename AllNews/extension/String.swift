//
//  String.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 09/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation

extension String {
    var comparable: String {
        return self.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    }
}
