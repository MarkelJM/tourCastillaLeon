//
//  ChallengeRewardViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 27/8/24.
//

import Combine
import FirebaseFirestore

class ChallengeRewardViewModel: BaseViewModel {
    @Published var challengeReward: ChallengeReward?
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""

    private let dataManager = ChallengeRewardDataManager()
    private var activityId: String

    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()
        fetchChallengeRewardById(activityId)
    }
    
    func fetchChallengeRewardById(_ id: String) {
        isLoading = true
        dataManager.fetchChallengeRewardById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { reward in
                self.challengeReward = reward
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func completeRewardTask() {
        guard let reward = challengeReward else { return }
        
        updateTaskForUser(taskID: reward.id, challenge: reward.challenge)
        updateSpotForUser()
        addSpecialRewardToUser(rewardID: reward.id)

        // Mostrar el mensaje personalizado desde Firestore
        self.resultMessage = reward.correctAnswerMessage
        self.showResultModal = true
    }

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

    private func updateSpotForUser() {
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

            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }

    private func addSpecialRewardToUser(rewardID: String) {
        firestoreManager.addSpecialRewardToUser(rewardID: rewardID)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error añadiendo el premio especial: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("Special reward added to user in Firestore")
            }
            .store(in: &cancellables)
    }
}
