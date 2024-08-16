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
