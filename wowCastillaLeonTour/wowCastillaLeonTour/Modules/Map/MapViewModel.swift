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
    @Published var challengeReward: ChallengeReward?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion
    @Published var selectedChallenge: String
    @Published var showChallengeSelection: Bool = false
    @Published var isChallengeBegan: Bool = false
    @Published var tasksAmount: Int = 0
    @Published var challenges: [Challenge] = []

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
                self?.checkForChallengeCompletion()
            }
            .store(in: &cancellables)
    }

    func checkForChallengeCompletion() {
        guard let user = user else { return }
        guard let completedTasks = user.challenges[selectedChallenge]?.count else { return }

        if completedTasks >= tasksAmount {
            // Aquí se comentan las partes relacionadas con `ChallengeReward`
            // fetchChallengeReward()
        }
    }

    func selectChallenge(_ challenge: Challenge) {
        selectedChallenge = challenge.challengeName

        if user?.challenges[selectedChallenge] != nil {
            // Si el desafío ya está en los desafíos del usuario, navegar al mapa
            appState.currentView = .map
        } else {
            // Si el desafío no está en los desafíos del usuario, navegar a la presentación del desafío
            appState.currentView = .challengePresentation(challengeName: selectedChallenge)
        }

        userDefaultsManager.saveChallengeName(selectedChallenge)
        showChallengeSelection = false
    }

    /*
    // Comentamos la función relacionada con `ChallengeReward`
    func fetchChallengeReward() {
        dataManager.fetchChallengeReward(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] reward in
                self?.challengeReward = reward
                self?.tasksAmount = reward.tasksAmount
                self?.addChallengeRewardToMap(reward: reward)
            }
            .store(in: &cancellables)
    }

    private func addChallengeRewardToMap(reward: ChallengeReward) {
        let rewardSpot = Spot(
            id: reward.id,
            abstract: reward.abstract,
            activityID: reward.activityID,
            activityType: reward.activityType,
            coordinates: reward.location,
            image: reward.prizeImage,
            isCompleted: false,
            name: reward.challengeTitle,
            province: reward.province,
            title: reward.challengeTitle
        )

        spots.append(rewardSpot)
    }
    */

    func checkChallengeStatus() {
        guard let user = user else { return }
        if user.challenges[selectedChallenge] != nil {
            isChallengeBegan = true
        } else {
            isChallengeBegan = false
        }
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
                print("Challenge state saved in Firestore")
            }
            .store(in: &cancellables)
    }

    func saveSpotID(_ spotID: String) {
        userDefaultsManager.saveSpotID(spotID)
    }

    func showChallengeSelectionView() {
        self.showChallengeSelection = true
    }
}

/*
import Foundation
import Combine
import CoreLocation
import MapKit

class MapViewModel: BaseViewModel {
    @Published var spots: [Spot] = []
    // @Published var challengeReward: ChallengeReward? // Comentado
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion
    @Published var selectedChallenge: String
    @Published var showChallengeSelection: Bool = false
    @Published var isChallengeBegan: Bool = false
    @Published var tasksAmount: Int = 0
    @Published var challenges: [Challenge] = []

    private var locationManager = LocationManager()
    private var dataManager = MapDataManager()
    private var hasCenteredOnUser = false

    init(appState: AppState) {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6528, longitude: -2.7286),
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        self.selectedChallenge = "retoBasico"  // Inicializar temporalmente antes de super.init()
        super.init()
        self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"  // Reasignar después de super.init()
        setupBindings()
        fetchUserProfileAndUpdateState()
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
                self?.checkForChallengeCompletion()
            }
            .store(in: &cancellables)
    }

    func checkForChallengeCompletion() {
        guard let user = user else { return }
        guard let completedTasks = user.challenges[selectedChallenge]?.count else { return }

        if completedTasks >= tasksAmount {
            // fetchChallengeReward() // Comentado
        }
    }

    /*
    func fetchChallengeReward() {
        dataManager.fetchChallengeReward(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] reward in
                self?.challengeReward = reward
                self?.tasksAmount = reward.tasksAmount
                self?.addChallengeRewardToMap(reward: reward)
            }
            .store(in: &cancellables)
    }

    private func addChallengeRewardToMap(reward: ChallengeReward) {
        let rewardSpot = Spot(
            id: reward.id,
            abstract: reward.abstract,
            activityID: reward.activityID,
            activityType: reward.activityType,
            coordinates: reward.location,
            image: reward.prizeImage,
            isCompleted: false,
            name: reward.challengeTitle,
            province: reward.province,
            title: reward.challengeTitle
        )

        spots.append(rewardSpot)
    }
    */

    func checkChallengeStatus() {
        guard let user = user else { return }
        if user.challenges[selectedChallenge] != nil {
            isChallengeBegan = true
        } else {
            isChallengeBegan = false
        }
    }

    func beginChallenge() {
        guard var user = user else { return }

        if user.challenges[selectedChallenge] == nil {
            user.challenges[selectedChallenge] = []
            saveUserChallengeState(user: user)
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
                print("Challenge state saved in Firestore")
            }
            .store(in: &cancellables)
    }

    func saveSpotID(_ spotID: String) {
        userDefaultsManager.saveSpotID(spotID)
    }

    func showChallengeSelectionView() {
        showChallengeSelection = true
    }
}


*/

/*
import Foundation
import Combine
import CoreLocation
import MapKit

class MapViewModel: BaseViewModel {
    @Published var spots: [Spot] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion
    @Published var selectedChallenge: String = "retoBasico"
    @Published var showChallengeSelection: Bool = false
    @Published var isChallengeBegan: Bool = false

    private var locationManager = LocationManager()
    private var dataManager = MapDataManager()
    private var hasCenteredOnUser = false

    override init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6528, longitude: -2.7286),
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        super.init()
        setupBindings()
        fetchUserProfile()
        checkChallengeStatus()
    }

    // Método para guardar el spotID en UserDefaults
    func saveSpotID(_ spotID: String) {
        userDefaultsManager.saveSpotID(spotID)
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
            }
            .store(in: &cancellables)
    }

    func checkChallengeStatus() {
        guard let user = user else { return }
        if user.challenges[selectedChallenge] != nil {
            isChallengeBegan = true
        } else {
            isChallengeBegan = false
        }
    }

    func beginChallenge() {
        guard var user = user else { return }
        
        // Comprobar si ya existe el reto, si no, añadirlo
        if user.challenges[selectedChallenge] == nil {
            user.challenges[selectedChallenge] = []
            saveUserChallengeState(user: user)
        }
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
                print("Challenge state saved in Firestore")
            }
            .store(in: &cancellables)
    }
}

*/

/*
import Foundation
import Combine
import CoreLocation
import MapKit

class MapViewModel: BaseViewModel {
    @Published var points: [Point] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region: MKCoordinateRegion

    private var locationManager = LocationManager()
    private var dataManager = MapDataManager()
    private var hasCenteredOnUser = false

    override init() {
        // init in CyL
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.6528, longitude: -2.7286), 
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        super.init()
        setupBindings()
        fetchUserProfile()
    }

    private func setupBindings() {
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.fetchPoints()
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

    func fetchPoints() {
        dataManager.fetchPoints()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] points in
                self?.points = points
            }
            .store(in: &cancellables)
    }
}
*/
