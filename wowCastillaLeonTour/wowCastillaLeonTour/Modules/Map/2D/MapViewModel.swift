//
//  MapViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//



import Foundation
import Combine
import CoreLocation
import MapKit

class MapViewModel: BaseViewModel {
    @Published var spots: [Spot] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion
    @Published var selectedChallenge: String
    @Published var showChallengeSelection: Bool = false
    @Published var isChallengeBegan: Bool = false
    @Published var challenges: [Challenge] = []
    @Published var mapAnnotations: [UnifiedAnnotation] = []



    private var locationManager = LocationManager()
    private var dataManager = MapDataManager()
    private var hasCenteredOnUser = false
    var appState: AppState

    init(appState: AppState) {
        self.appState = appState
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6528, longitude: -2.7286),
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        self.selectedChallenge = "retoBasico"
        super.init()
        self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"
        setupBindings()
        fetchUserProfileAndUpdateState()
        fetchChallenges()
    }



    private func setupBindings() {
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.fetchSpots()
                } else if status == .denied {
                    self?.errorMessage = "Location permissions denied."
                }
            }
            .store(in: &cancellables)

        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }
                if !self.hasCenteredOnUser {
                    self.region.center = location.coordinate
                    self.hasCenteredOnUser = true
                }
            }
            .store(in: &cancellables)
    }

    private func fetchUserProfileAndUpdateState() {
        super.fetchUserProfile()

        if let user = self.user {
            self.checkChallengeStatus()
        } else {
            self.alertMessage = "Error: No user data found."
            self.showAlert = true
        }
    }

    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenges in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }

    func fetchSpots() {
        dataManager.fetchSpots(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] spots in
                self?.spots = spots
                self?.addSpotsToMap(spots: spots)
                self?.checkForChallengeCompletionAndAddReward()
            }
            .store(in: &cancellables)
    }

    func isTaskCompleted(spotID: String) -> Bool {
        guard let user = user else { return false }
        return user.spotIDs.contains(spotID)
    }

    func addSpotsToMap(spots: [Spot]) {
        guard let user = user else { return }

        let completedSpotIDs = user.spotIDs

        for spot in spots {
            var annotation = UnifiedAnnotation(spot: spot)

            if completedSpotIDs.contains(spot.id) {
                annotation.image = "checkmark.circle.fill"
            }
            
            mapAnnotations.append(annotation)
        }

        print("Map annotations count after loading spots: \(mapAnnotations.count)")
    }

    func checkForChallengeCompletionAndAddReward() {
        guard let user = user else { return }

        if let challenge = challenges.first(where: { $0.challengeName == selectedChallenge }) {
            let completedTasksCount = user.challenges[selectedChallenge]?.count ?? 0
            let tasksRequired = challenge.taskAmount

            print("Completed tasks count: \(completedTasksCount), tasks required: \(tasksRequired)")

            if completedTasksCount >= tasksRequired {
                print("Challenge \(selectedChallenge) completed.")
                fetchChallengeReward(for: selectedChallenge)
            } else {
                print("Challenge \(selectedChallenge) has not been completed yet.")
            }
        }
    }

    func fetchChallengeReward(for challengeName: String) {
        dataManager.fetchChallengeReward(for: challengeName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] reward in
                print("Reward received: \(reward)")
                self?.addChallengeRewardToMap(reward: reward)
            }
            .store(in: &cancellables)
    }

    func addChallengeRewardToMap(reward: ChallengeReward) {
        let annotation = UnifiedAnnotation(reward: reward)
        mapAnnotations.append(annotation)
        print("Added reward annotation. Total annotations: \(mapAnnotations.count)")
    }

    func handleRewardTap(annotation: UnifiedAnnotation) {
        if let reward = annotation.reward {
            print("Navigating to challengeReward with challenge: \(reward.challenge)")
            appState.currentView = .challengeReward(challengeName: reward.challenge)
        }
    }

    func showChallengeSelectionView() {
        self.showChallengeSelection = true
    }

    func selectChallenge(_ challenge: Challenge) {
        selectedChallenge = challenge.challengeName

        if user?.challenges[selectedChallenge] != nil {
            appState.currentView = .map
        } else {
            appState.currentView = .challengePresentation(challengeName: selectedChallenge)
        }

        userDefaultsManager.saveChallengeName(selectedChallenge)
        showChallengeSelection = false
    }

    func checkChallengeStatus() {
        guard let user = user else { return }
        isChallengeBegan = user.challenges[selectedChallenge] != nil
    }

    func beginChallenge() {
        guard var user = user else { return }

        if user.challenges[selectedChallenge] == nil {
            user.challenges[selectedChallenge] = []
            saveUserChallengeState(user: user)
            appState.currentView = .challengePresentation(challengeName: selectedChallenge)
        } else {
            appState.currentView = .map
        }

        userDefaultsManager.saveChallengeName(selectedChallenge)
        isChallengeBegan = true
    }

    private func saveUserChallengeState(user: User) {
        firestoreManager.updateUserChallenges(user: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User challenge state successfully updated in Firestore")
            }
            .store(in: &cancellables)
    }

    func saveSpotID(_ spotID: String) {
        userDefaultsManager.saveSpotID(spotID)
    }
}


