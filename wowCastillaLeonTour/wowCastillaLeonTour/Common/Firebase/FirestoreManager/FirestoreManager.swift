//
//  FirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // Create user profile in Firestore
    func createUserProfile(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }
        
        let userData = user.toFirestoreData()
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Fetch user profile from Firestore
    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data() ?? [:]
                if let user = User(from: data) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    // Update task IDs in Firestore
    func updateUserTaskIDs(taskID: String, activityType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }
        
        var field: String
        
        switch activityType {
        case "coin":
            field = "coinTaskIDs"
        case "gadget":
            field = "gadgetTaskIDs"
        default:
            field = "taskIDs"
        }
        
        let userRef = db.collection("users").document(uid)
        userRef.updateData([field: FieldValue.arrayUnion([taskID])]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Register new user with FirebaseAuth
    func registerUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Login user with FirebaseAuth
    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Send email verification
    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        auth.currentUser?.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Check email verification status
    func checkEmailVerification(completion: @escaping (Result<Bool, Error>) -> Void) {
        auth.currentUser?.reload { error in
            if let error = error {
                completion(.failure(error))
            } else if let isVerified = self.auth.currentUser?.isEmailVerified {
                completion(.success(isVerified))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to check email verification"])))
            }
        }
    }
}
