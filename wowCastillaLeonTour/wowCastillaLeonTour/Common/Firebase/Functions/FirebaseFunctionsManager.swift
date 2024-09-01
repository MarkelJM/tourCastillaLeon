//
//  FirebaseFunctionsManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import FirebaseFunctions
import Foundation

class FirebaseFunctionsManager {
    private lazy var functions = Functions.functions()
    
    func getMapboxToken(completion: @escaping (Result<String, Error>) -> Void) {
        functions.httpsCallable("getMapboxToken").call { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = result?.data as? [String: Any],
               let token = data["token"] as? String {
                completion(.success(token))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token no encontrado"])))
            }
        }
    }
}
