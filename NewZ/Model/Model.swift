//
//  Model.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-14.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import Foundation
import CoreData

class Model {

    internal let persistentContainer: NSPersistentContainer
    private let newsService: NewsService

    init(persistentContainer: NSPersistentContainer, newsService: NewsService) {
        self.persistentContainer = persistentContainer
        self.newsService = newsService
    }

    public func updatePrograms(completion: @escaping (Bool) -> Void) {
        newsService.updatePrograms { result in

            guard case .success(let apiResponse) = result else {
                completion(false)
                return
            }

            self.persistentContainer.performBackgroundTask { context in

                // You could add full syncing functionality here to also remove
                // programs that has been removed from the response received from the API
                // but I did not do that for this small test assignment.

                for responseProgram in apiResponse.programs {
                    let program = Program.with(id: responseProgram.id, in: context)

                    // Update information
                    program.name = responseProgram.name
                    program.programDescription = responseProgram.description
                    program.programUrlString = responseProgram.programUrlString
                    program.programImageUrlString = responseProgram.programImageUrlString
                    program.responsibleEditor = responseProgram.responsibleEditor
                }

                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    completion(false)
                    fatalError("Error saving background context")
                }
            }

        }
    }

}
