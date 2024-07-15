//
//  MapDatamanager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import Combine

class MapDataManager {
    private let firestoreManager = MapFirestoreManager()
    
    func fetchPoints() -> AnyPublisher<[Point], Error> {
        Future { promise in
            self.firestoreManager.fetchPoints { result in
                switch result {
                case .success(let points):
                    promise(.success(points))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
