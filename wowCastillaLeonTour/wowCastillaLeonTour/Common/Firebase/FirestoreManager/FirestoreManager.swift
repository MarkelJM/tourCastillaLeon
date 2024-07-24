//
//  FirestoreManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirestoreManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // Create user profile in Firestore
    func createUserProfile(user: User) -> Future<Void, Error> {
        return Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                return promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            }
            
            let userData = user.toFirestoreData()
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // Fetch user profile from Firestore
    func fetchUserProfile() -> Future<User, Error> {
        return Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                return promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            }
            
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    if let user = User(from: data) {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
    }
    
    // Update task IDs in Firestore
    func updateUserTaskIDs(taskID: String, activityType: String) -> Future<Void, Error> {
        return Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                return promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
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
            
            let userRef = self.db.collection("users").document(uid)
            userRef.updateData([field: FieldValue.arrayUnion([taskID])]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // Register new user with FirebaseAuth
    func registerUser(email: String, password: String) -> Future<Void, Error> {
        return Future { promise in
            self.auth.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // Login user with FirebaseAuth
    func loginUser(email: String, password: String) -> Future<Void, Error> {
        return Future { promise in
            self.auth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // Send email verification
    func sendEmailVerification() -> Future<Void, Error> {
        return Future { promise in
            self.auth.currentUser?.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    // Check email verification status
    func checkEmailVerification() -> Future<Bool, Error> {
        return Future { promise in
            self.auth.currentUser?.reload { error in
                if let error = error {
                    promise(.failure(error))
                } else if let isVerified = self.auth.currentUser?.isEmailVerified {
                    promise(.success(isVerified))
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to check email verification"])))
                }
            }
        }
    }
}
