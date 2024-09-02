//
//  Map3DDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 2/9/24.
//

import Foundation
import FirebaseFunctions
import Combine

class Map3DDataManager {
    private lazy var functions = Functions.functions()

    func getMapboxToken() -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            self.functions.httpsCallable("getMapboxToken").call { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = result?.data as? [String: Any],
                          let token = data["token"] as? String {
                    promise(.success(token))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token no encontrado"])
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
