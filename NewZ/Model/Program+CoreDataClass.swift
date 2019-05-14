//
//  Program+CoreDataClass.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-14.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Program)
public class Program: NSManagedObject {

    public class func with(id: Int, in context: NSManagedObjectContext) -> Program {
        let request: NSFetchRequest<Program> = Program.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(Program.id), NSNumber(value: id))
        request.fetchLimit = 1

        if let firstResult = (try? context.fetch(request))?.first {
            return firstResult
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Program", in: context)!
            let program = NSManagedObject(entity: entity, insertInto: context) as! Program
            program.id = Int64(id)
            return program
        }
    }

}
