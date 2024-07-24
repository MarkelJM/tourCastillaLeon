//
//  BaseViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/7/24.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let firestoreManager = FirestoreManager()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func updateUserTaskIDs(taskID: String, activityType: String) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, activityType: activityType)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error: \(error.localizedDescription)"
                case .finished:
                    self.alertMessage = "Tarea añadida correctamente."
                }
                self.showAlert = true
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func isTaskCompleted(taskID: String, activityType: String) -> Bool {
        switch activityType {
        case "coin":
            return user?.coinTaskIDs.contains(taskID) ?? false
        case "gadget":
            return user?.gadgetTaskIDs.contains(taskID) ?? false
        default:
            return user?.taskIDs.contains(taskID) ?? false
        }
    }
}
