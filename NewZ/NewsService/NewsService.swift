//
//  NewsService.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-13.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import Foundation

fileprivate extension URL {
    static let apiUrl = URL(string: "https://api.sr.se/api/v2/news?format=json")!
}

struct APIResponse: Codable {
    let programs: [ProgramJSON]
}

struct ProgramJSON: Codable {
    let id: Int
    let name: String
    let description: String
    let programUrlString: String
    let programImageUrlString: String
    let responsibleEditor: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case programUrlString = "programurl"
        case programImageUrlString = "programimage"
        case responsibleEditor = "responsibleeditor"
    }
}

class NewsService {

    private lazy var decoder = JSONDecoder()

    func updatePrograms(completion: @escaping (Result<APIResponse,Error>) -> Void) {

        let task = URLSession.shared.dataTask(with: .apiUrl) { [decoder] (data, response, error) in

            if let anError = error {
                completion(Result.failure(anError))
                return
            }

            guard let data = data, let response = try? decoder.decode(APIResponse.self, from: data) else {
                let error = NSError(
                    domain: "NewZ",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "Could not parse data"])
                completion(Result.failure(error))
                return
            }
            
            completion(Result.success(response))
        }
        task.resume()
    }

}
