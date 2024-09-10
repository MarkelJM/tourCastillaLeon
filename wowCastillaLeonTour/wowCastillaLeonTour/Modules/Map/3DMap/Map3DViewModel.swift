//
//  Map3DViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import Foundation
import MapKit

class Map3DViewModel: MapViewModel {
    @Published var selectedSpot: Spot?
    @Published var selectedReward: ChallengeReward?
    @Published var cameraBoundary: MKMapView.CameraBoundary?
    @Published var cameraZoomRange: MKMapView.CameraZoomRange?

    override init(appState: AppState) {
        super.init(appState: appState)
        setup3DCamera()
    }

    func setup3DCamera() {
        print("Configuring 3D camera...")
        self.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        self.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 50000)
        region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    }

    func focusOnAnnotation(annotation: UnifiedAnnotation, mapView: MKMapView) {
        print("Focusing on annotation at coordinate: \(annotation.coordinate)")
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)
    }

    func handleAnnotationSelection(annotation: UnifiedAnnotation, mapView: MKMapView) {
        if let spot = annotation.spot {
            print("Annotation selected for spot: \(spot.name)")
            self.selectedSpot = spot
            focusOnAnnotation(annotation: annotation, mapView: mapView)
        } else if let reward = annotation.reward {
            print("Annotation selected for reward: \(reward.challengeTitle)")
            self.selectedReward = reward
            focusOnAnnotation(annotation: annotation, mapView: mapView)
        } else {
            print("Annotation selected but no spot or reward found.")
        }
    }
}
