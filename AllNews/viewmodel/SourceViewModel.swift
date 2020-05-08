//
//  SourceViewModel.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 26/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import Foundation
import CoreData

class SourceViewModel {
    // MARK: - Public properties
    let sourceModel = SourceModel()
    var delegate: SourceViewModelDelegate?
    var sourcesStatus = [(source: SourceElement, isSaved: Bool)]()
    
    // MARK: - Private properties
    private var language: Language {
        return UserSettings.shared.language
    }
    
    // MARK: - Methods
    func setup() {
        loadAPISources()
    }
    
    private func loadAPISources() {
        let request = NewsAPI.request(
            for: .sources,
            withParams: [
                URLQueryItem(name: "language", value: language.rawValue),
            ]
        )
        NewsAPI.performRequest(request, withDelegate: self)
    }
    
    func insertSource(withId id: String) {
        sourceModel.createSource(withId: id)
        
        if let index = sourcesStatus.firstIndex(where: { $0.0.id == id }){
            sourcesStatus[index].1 = true
        }
    }
    
    func removeSource(withId id: String) {
        sourceModel.removeSource(withId: id)
        if let index = sourcesStatus.firstIndex(where: {$0.0.id == id}) {
            sourcesStatus[index].1 = false
        }
    }
}

// MARK: - APIRequestDelegate
extension SourceViewModel: APIRequestDelegate {
    
    func didFinishRequest(data: Data?, error: (code: String, message: String)?) {
        if error == nil {
            sourcesStatus = decodeSourcesStatus(fromData: data)
        } else {
            print("ERROR \(error!.code): \(error!.message)")
        }
        delegate?.didFinishLoading(self)
    }
    
    private func decodeSourcesStatus(fromData data: Data?) -> [(SourceElement, Bool)]{
        guard let data = data else { return [] }
        let decoder = JSONDecoder()
        let sourceResponse = try? decoder.decode(APISourceResponse.self, from: data)
        let savedSourcesId = Set(sourceModel.sources.map({ $0.id }))
        return sourceResponse?.sources.map({ ($0, savedSourcesId.contains($0.id))}) ?? []
    }
}

// MARK: - Protocol SourceViewModelDelegate
protocol SourceViewModelDelegate {
    func didFinishLoading(_ viewModel: SourceViewModel)
}
