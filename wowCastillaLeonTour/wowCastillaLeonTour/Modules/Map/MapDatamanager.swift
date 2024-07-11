//
//  MapDatamanager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation

class MapDataManager {
    private let firestoreManager = MapFirestoreManager()
    
    func fetchPoints(completion: @escaping ([Point]) -> Void, failure: @escaping (Error) -> Void) {
        firestoreManager.fetchPoints { result in
            switch result {
            case .success(let points):
                completion(points)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
