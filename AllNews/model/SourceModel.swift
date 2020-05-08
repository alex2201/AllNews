//
//  SourceModel.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 26/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit
import CoreData

class SourceModel: ManagedObjectModel {
    
    // MARK: - Private properties
    private var language: Language {
        return UserSettings.shared.language
    }
    private var sourcesRequest: NSFetchRequest<SourceEntity> {
        let request:NSFetchRequest<SourceEntity> = SourceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "language=%@", language.rawValue)
        return request
    }
    
    // MARK: - Public properties
    var sources: [SourceEntity] {
        let request: NSFetchRequest<SourceEntity> = sourcesRequest
        var savedSources: [SourceEntity]?
        
        if let data = try? context.fetch(request) {
            savedSources = data
        }
        
        return savedSources ?? []
    }
    
    // MARK: - Methods
    override init() {
        super.init()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createSource(withId id: String) {
        let source = SourceEntity(context: context)
        source.id = id
        source.language = language.rawValue
        saveContext()
    }
    
    func getSource(withId id: String) -> SourceEntity? {
        let request:NSFetchRequest<SourceEntity> = SourceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "language=%@ and id=%@", language.rawValue, id)
        let sources = try? context.fetch(request)
        return sources?.first
    }
    
    func removeSource(withId id: String) {
        if let source = getSource(withId: id) {
            context.delete(source)
            saveContext()
        }
    }
    
}
