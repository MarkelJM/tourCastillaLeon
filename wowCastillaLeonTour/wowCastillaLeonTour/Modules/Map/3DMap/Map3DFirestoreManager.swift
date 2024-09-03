//
//  Map3DFirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 2/9/24.
//

import FirebaseFirestore
import Combine

class Map3DFirestoreManager {
    private var db = Firestore.firestore()
    
    // Función para obtener spots para un challenge específico en el contexto del mapa 3D
    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        Future { promise in
            self.db.collection("spots")  // Cambiado para diferenciar spots específicos del mapa 3D
                .document(challengeName)
                .collection("locationsSpot")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let spots = querySnapshot?.documents.compactMap { document in
                            Spot(from: document.data())
                        } ?? []
                        promise(.success(spots))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // Función para obtener challenges en el contexto del mapa 3D
    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        Future { promise in
            self.db.collection("challenges")  // Cambiado para diferenciar challenges específicos del mapa 3D
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let challenges = querySnapshot?.documents.compactMap { document in
                            Challenge(from: document.data())
                        } ?? []
                        promise(.success(challenges))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // Función para obtener una recompensa para un challenge específico en el contexto del mapa 3D
    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        Future { promise in
            self.db.collection("challengeAward")  // Cambiado para diferenciar las recompensas específicas del mapa 3D
                .document(challengeName)
                .getDocument { document, error in
                    if let document = document, document.exists {
                        if let rewardData = document.data(), let reward = ChallengeReward(from: rewardData) {
                            promise(.success(reward))
                        } else {
                            promise(.failure(NSError(domain: "Error decoding reward", code: -1, userInfo: nil)))
                        }
                    } else {
                        promise(.failure(error ?? NSError(domain: "Document does not exist", code: -1, userInfo: nil)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
