//
//  BaseViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/7/24.
//

import Combine
import FirebaseFirestore

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let firestoreManager = FirestoreManager()
    var cancellables = Set<AnyCancellable>()
    let userDefaultsManager = UserDefaultsManager()
    
    // Fetch the user profile from Firestore and store it in 'user'
    func fetchUserProfile() {
        firestoreManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
    
    // Update task IDs and spot IDs in the user's profile
    func updateUserTaskIDs(taskID: String, activityType: String, city: String? = nil, challenge: String) {
        guard var user = user else { return }
        
        // Check if the task has already been completed
        if isTaskAlreadyCompleted(taskID: taskID, activityType: activityType, city: city, challenge: challenge, user: user) {
            alertMessage = "Esta tarea ya está completada."
            showAlert = true
            return
        }

        // Add the task ID to the challenge
        if user.challenges[challenge] != nil {
            user.challenges[challenge]?.append(taskID)
        } else {
            user.challenges[challenge] = [taskID]
        }

        // Reassign the updated user to the 'user' property
        self.user = user
        
        // Update Firestore with the new task ID and spot ID
        updateTaskForUser(taskID: taskID, challenge: challenge)
        updateSpotForUser()
    }

    // Update task IDs in Firestore
    private func updateTaskForUser(taskID: String, challenge: String) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, challenge: challenge)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error actualizando la tarea: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User task updated in Firestore")
            }
            .store(in: &cancellables)
    }

    // Update spot IDs in Firestore
    private func updateSpotForUser() {
        // Get the spot ID from UserDefaults
        if let spotID = userDefaultsManager.getSpotID() {
            firestoreManager.updateUserSpotIDs(spotID: spotID)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error actualizando el spot: \(error.localizedDescription)"
                        self.showAlert = true
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("User spot updated in Firestore")
                }
                .store(in: &cancellables)

            // Clear the spot ID from UserDefaults after updating
            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }

    // Check if the task is already completed
    private func isTaskAlreadyCompleted(taskID: String, activityType: String, city: String?, challenge: String, user: User) -> Bool {
        return user.challenges[challenge]?.contains(taskID) ?? false
    }

    // Public method to check if a task is completed
    func isTaskCompleted(taskID: String, activityType: String, city: String? = nil, challenge: String) -> Bool {
        guard let user = user else { return false }
        return user.challenges[challenge]?.contains(taskID) ?? false
    }
}



