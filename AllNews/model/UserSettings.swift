//
//  UserSettings.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 19/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation

class UserSettings {
    var language: Language
    var sources: [APIArticleSource] = []
    static let shared = UserSettings()
    
    private init(language: Language) {
        self.language = language
        UserDefaults.standard.setValue(language.rawValue, forKey: "language")
    }
    
    private init() {
        if let storedLanguage = UserDefaults.standard.string(forKey: "language") {
            self.language = Language(rawValue: storedLanguage)!
        } else {
            self.language = Language(rawValue: Locale.current.languageCode!)!
        }
    }
    
    func set(language: Language) {
        self.language = language
    }
}
