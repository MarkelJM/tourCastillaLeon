//
//  FirebaseFunctionsManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//



import FirebaseFunctions
import Foundation
import Combine

class FirebaseFunctionsManager {
    private lazy var functions = Functions.functions()
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func getMapboxToken() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            self.functions.httpsCallable("getMapboxToken").call { result, error in
                if let error = error {
                    print("Error al obtener el token de Mapbox: \(error.localizedDescription)")
                    promise(.failure(error))
                    return
                }

                // Verificar la respuesta y decodificar el token
                guard let data = result?.data else {
                    print("No data available in the response")
                    promise(.failure(NSError(domain: "DataUnavailable", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])))
                    return
                }

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    if let tokenDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let token = tokenDict["token"] as? String {
                        print("Token de Mapbox recibido: \(token)")
                        promise(.success(token))
                    } else {
                        throw NSError(domain: "TokenParsing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token no encontrado en la respuesta"])
                    }
                } catch {
                    print("Error al decodificar el token: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}



/*
import FirebaseFunctions
import Foundation
import Combine

class FirebaseFunctionsManager {
    private lazy var functions = Functions.functions()
    
    func getMapboxToken() -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            self.functions.httpsCallable("getMapboxToken").call { result, error in
                if let error = error {
                    print("Error al obtener el token de Mapbox: \(error.localizedDescription)")
                    promise(.failure(error))
                } else if let data = result?.data as? [String: Any],
                          let token = data["token"] as? String {
                    print("Token de Mapbox recibido: \(token)")
                    promise(.success(token))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token no encontrado"])
                    print("Error: Token no encontrado en la respuesta")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
*/
