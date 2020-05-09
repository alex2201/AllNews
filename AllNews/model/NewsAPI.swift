// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - API
struct NewsAPI {
    // MARK: - Private properties
    private static let key = PrivateData.apiKey
    
    // MARK: - Public properties
    enum Endpoint: String {
        case sources
        case topHeadlines = "top-headlines"
        case everything
    }
    
    // MARK: - Methods
    static func request(for endpoint: Endpoint, withParams params: [URLQueryItem]) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        
        switch endpoint {
        case .sources:
            urlComponents.path = "/v2/" + endpoint.rawValue
        case .topHeadlines:
            urlComponents.path = "/v2/" + endpoint.rawValue
        case .everything:
            urlComponents.path = "/v2/" + endpoint.rawValue
        }
        
        urlComponents.queryItems = params
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(key, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
    
    static func performRequest(_ request: URLRequest, withDelegate delegate: APIRequestDelegate) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if let apiResponse = try? decoder.decode(APIResponse.self, from: data!) {
                    let status = apiResponse.status
                    
                    if status != "error" {
                        delegate.didFinishRequest(data: data, error: nil)
                    } else {
                        delegate.didFinishRequest(data: data, error: (code: apiResponse.code!, message: apiResponse.message!))
                    }
                }
            }
        }.resume()
    }
}

// MARK: - APIResponse
struct APIResponse: Codable {
    let status: String
    let message, code: String?
}

// MARK: - ArticleResponse
struct APIArticleResponse: Codable {
    let totalResults: Int?
    let articles: [APIArticle]?
}

// MARK: - Article
struct APIArticle: Codable {
    let source: APIArticleSource
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - ArticleSource
struct APIArticleSource: Codable {
    let id: String?
    let name: String
}

// MARK: - Sources
struct APISourceResponse: Codable {
    let sources: [SourceElement]
}

// MARK: - SourceElement
struct SourceElement: Codable {
    let id, name, sourceDescription: String
    let url: String
    let category: Category?
    let language: String?
    let country: Country?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
}

// MARK: - Country
enum Country: String, Codable {
    case ae = "ae"
    case ar = "ar"
    case at = "at"
    case au = "au"
    case be = "be"
    case bg = "bg"
    case br = "br"
    case ca = "ca"
    case ch = "ch"
    case cn = "cn"
    case co = "co"
    case cu = "cu"
    case cz = "cz"
    case de = "de"
    case eg = "eg"
    case fr = "fr"
    case gb = "gb"
    case gr = "gr"
    case hk = "hk"
    case hu = "hu"
    case id = "id"
    case ie = "ie"
    case il = "il"
    case `in` = "in"
    case it = "it"
    case jp = "jp"
    case kr = "kr"
    case lt = "lt"
    case lv = "lv"
    case ma = "ma"
    case mx = "mx"
    case my = "my"
    case ng = "ng"
    case nl = "nl"
    case no = "no"
    case nz = "nz"
    case ph = "ph"
    case pl = "pl"
    case pt = "pt"
    case ro = "ro"
    case rs = "rs"
    case ru = "ru"
    case sa = "sa"
    case se = "se"
    case sg = "sg"
    case si = "si"
    case sk = "sk"
    case th = "th"
    case tr = "tr"
    case tw = "tw"
    case ua = "ua"
    case us = "us"
    case ve = "ve"
    case za = "za"
    case es = "es"
    case `is` = "is"
}

// MARK: - CountryDescription
enum CountryDescription: String, Codable {
    case ae = "Emiratos Árabes Unidos"
    case ar = "Argentina"
    case at = "Austria"
    case au = "Australia"
    case be = "Bélgica"
    case bg = "Bulgaria"
    case br = "Brazil"
    case ca = "Canada"
    case ch = "Suiza"
    case cn = "China"
    case co = "Colombia"
    case cu = "Cuba"
    case cz = "República Checa"
    case de = "Alemania"
    case eg = "Egipto"
    case fr = "Francia"
    case gb = "Reino Unido"
    case gr = "Grecia"
    case hk = "Hong Kong"
    case hu = "Hungría"
    case id = "Indonesia"
    case ie = "Irlanda"
    case il = "Israel"
    case `in` = "India"
    case it = "Italia"
    case jp = "Japón"
    case kr = "Korea"
    case lt = "Lituania"
    case lv = "Latvia"
    case ma = "Macaco"
    case mx = "México"
    case my = "Malasia"
    case ng = "Nigeria"
    case nl = "Paises Bajos"
    case no = "Noruega"
    case nz = "Nueva Zelanda"
    case ph = "Filipinas"
    case pl = "Polonia"
    case pt = "Portugal"
    case ro = "Rumania"
    case rs = "Serbia"
    case ru = "Rusia"
    case sa = "Samoa"
    case se = "Suecia"
    case sg = "Singapur"
    case si = "Eslovenia"
    case sk = "Eslovakia"
    case th = "Tailandia"
    case tr = "Turquía"
    case tw = "Taiwan"
    case ua = "Ucrania"
    case us = "Estados Unidos"
    case ve = "Venezuela"
    case za = "Sud-África"
    case es = "España"
    case `is` = "Iceland"
}

// MARK: - Language
enum Language: String, Codable, CaseIterable {
//    case ar = "ar"
    case de = "de"
    case en = "en"
    case es = "es"
    case fr = "fr"
//    case he = "he"
    case it = "it"
//    case nl = "nl"
//    case no = "no"
//    case pt = "pt"
//    case ru = "ru"
//    case se = "se"
//    case ud = "ud"
//    case zh = "zh"
}

// MARK: - LanguageDescription
enum LanguageDescription: String, CaseIterable {
//    case ar = "ar"
    case de = "Deutsch"
    case en = "English"
    case es = "Español"
    case fr = "Français"
//    case he = "he"
    case it = "Italiano"
//    case nl = "nl"
//    case no = "no"
//    case pt = "pt"
//    case ru = "ru"
//    case se = "se"
//    case ud = "ud"
//    case zh = "zh"
    
    init?(forValue value: String) {
        for v in LanguageDescription.allCases where "\(v)" == value {
            self = v
            return
        }
        return nil
    }
}

// MARK: - Category
enum Category: String, Codable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}
