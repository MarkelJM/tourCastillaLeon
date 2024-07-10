//
//  ProfileDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import Foundation

class ProfileDataManager {
    private let firestoreManager = FirestoreManager()
    
    func createUserProfile(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.createUserProfile(user: user, completion: completion)
    }
    
    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        firestoreManager.fetchUserProfile(completion: completion)
    }
}
