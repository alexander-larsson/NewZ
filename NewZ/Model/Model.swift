//
//  Model.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-14.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import Foundation
import CoreData

public class Model {

    let persistentContainer: NSPersistentContainer
    let newsService: NewsService

    init(persistentContainer: NSPersistentContainer, newsService: NewsService) {
        self.persistentContainer = persistentContainer
        self.newsService = newsService
    }

    public func updatePrograms(completion: @escaping (Bool) -> Void) {
        newsService.updatePrograms { result in

            guard case .success(let apiResponse) = result else {
                print("ERROR: Program update failed!")
                completion(false)
                return
            }

            self.persistentContainer.performBackgroundTask { context in

                // TODO: This needs full sync, create, delete, update
                for responseProgram in apiResponse.programs {
                    let program = Program.with(id: responseProgram.id, in: context)

                    // Update information
                    program.name = responseProgram.name
                    program.programDescription = responseProgram.description
                    program.programURL = responseProgram.programURL
                    program.programImage = responseProgram.programImage
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
